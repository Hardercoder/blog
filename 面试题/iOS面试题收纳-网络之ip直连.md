#### 背景

IP直连可以避免localDNS解析导致的DNS劫持，但是在iOS中不仅仅是将host直接换成IP地址就可以了，还有以下需要注意的问题。

#### 注意事项

- HTTP请求头HOST字段设置
   HTTP/1.1要求所有的请求都必须传递HOST头部，HOST头部值为域名。如果使用IP地址对URL中的域名进行了替换，那么网络库会将IP地址作为HOST头部的内容，会导致服务端的解析异常(服务端认可的是您的域名信息，而非IP信息)。为了解决这个问题，可以主动设置HTTP请求HOST字段的值，以HttpUrlConnection为例：

```objective-c
// 在header中增加域名，防止运营商懵逼
[mutableRequest setValue:url.host forHTTPHeaderField:@"HOST"];
```

- HTTP请求头cookie字段设置
   由于使用IP地址对host进行了替换，根据iOS已有的cookie携带规则，iOS找不到替换之后的host对应的cookie，从而不会将请求原URL的cookie设置到请求头中。iOS对URL查找cookie的规则是：`If the domain does not start with a dot, then the cookie is only sent to the exact host specified by the domain. If the domain does start with a dot, then the cookie is sent to other hosts in that domain as well, subject to certain restrictions. See [RFC 6265](https://tools.ietf.org/html/rfc6265.html) for more detail.`
   所以需要我们自己在请求头部加上cookie

```objectivec
// 获取符合规则的第一个cookie
- (NSString *)getRequestCookieHeaderForURL:(NSURL *)URL {
    NSArray *cookieArray = [self getCookiesForURL:URL];
    if (cookieArray != nil && cookieArray.count > 0) {
        NSDictionary *cookieDic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
        if ([cookieDic objectForKey:@"Cookie"]) {
            NSString *returnString = cookieDic[@"Cookie"];
            return returnString;
        }
    }
    return nil;
}

- (NSArray <NSHTTPCookie *> *)getCookiesForURL:(NSURL *)URL
{
    NSMutableArray *cookieArray = [NSMutableArray array];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        // filterBlock为根据URL选择cookie的方式，与iOS选择cookie方式保持一致
        if (filterBlock(cookie, URL)) {
            [cookieArray addObject:cookie];
        }
    }
    return cookieArray;
}
```

- 客户端验证服务器证书domain不匹配[[1\]](https://links.jianshu.com/go?to=https%3A%2F%2Fhelp.aliyun.com%2Fdocument_detail%2F30143.html%3Fspm%3Da2c4g.11186623.2.28.62766e96yMTgIh)

发送HTTPS请求首先要进行SSL/TLS握手，握手过程大致如下：

1. 客户端发起握手请求，携带随机数、支持算法列表等参数。
2. 服务端收到请求，选择合适的算法，下发公钥证书和随机数。
3. 客户端对服务端证书进行校验，并发送随机数信息，该信息使用公钥加密。
4. 服务端通过私钥获取随机数信息。
5. 双方根据以上交互的信息生成session ticket，用作该连接后续数据传输的加密密钥。

上述过程中，和HTTPDNS有关的是第3步，客户端需要验证服务端下发的证书，验证过程有以下两个要点：

1. 客户端用本地保存的根证书解开证书链，确认服务端下发的证书是由可信任的机构颁发的。
2. 客户端需要检查证书的domain域和扩展域，看是否包含本次请求的host。

如果上述两点都校验通过，就证明当前的服务端是可信任的，否则就是不可信任，应当中断当前连接。`当客户端使用HTTPDNS解析域名时，请求URL中的host会被替换成HTTPDNS解析出来的IP，所以在证书验证的第2步，会出现domain不匹配的情况，导致SSL/TLS握手不成功`。

针对`domain不匹配`问题，可以采用如下方案解决：hook证书校验过程中第2步，将IP直接替换成原来的域名，再执行证书验证。

```css
【注意】基于该方案发起网络请求，若报出SSL校验错误，比如iOS系统报错kCFStreamErrorDomainSSL, -9813; The certificate for this server is invalid，Android系统报错System.err: javax.net.ssl.SSLHandshakeException: java.security.cert.CertPathValidatorException: Trust anchor for certification path not found.，请检查应用场景是否为SNI（单IP多HTTPS域名）。
```

方法为在客户端收到服务器的质询请求代理方法`-URLSession:task:didReceiveChallenge:completionHandler:`中，首先从header中获取host(第一点注意事项：HTTP请求头HOST字段设置)，从header中如果没有取到host，就去URL中获取host(降级为LocalDNS解析时不进行替换)，然后拿着host在自己的方法-evaluateServerTrust:forDomain:中创建SSL Policy证书校验策略，然后对证书进行校验。

```objectivec
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    if (!challenge) {
        return;
    }
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    /*
     * 获取原始域名信息。
     */
    NSString* host = [[self.request allHTTPHeaderFields] objectForKey:@"host"];
    if (!host) {
        host = self.request.URL.host;
    }
    // 检查质询的验证方式是否是服务器端证书验证，HTTPS的验证方式就是服务器端证书验证
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition,credential);
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain {
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    } else {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
}
```

SNI（Server Name Indication）是为了解决一个服务器使用多个域名和证书的SSL/TLS扩展。它的工作原理如下：
 在连接到服务器建立SSL链接之前先发送要访问站点的域名(Hostname)，服务器根据这个域名返回一个合适的证书。
 目前，大多数操作系统和浏览器都已经很好地支持SNI扩展，OpenSSL 0.9.8也已经内置这一功能。
 上述过程中，当客户端使用HTTPDNS解析域名时，请求URL中的host会被替换成HttpDNS解析出来的IP，导致SSL/TLS握手中服务器接收到的客户端发出的clientHello中的SNI为host解析后的IP，从而无法找到匹配的证书，只能返回默认的证书或者不返回，所以会出现SSL/TLS握手不成功的错误。

比如当你需要通过HTTPS访问CDN资源时，CDN的站点往往服务了很多的域名，所以需要通过SNI指定具体的域名证书进行通信。

SNI（单IP多HTTPS证书）场景下，iOS上层网络库 NSURLConnection/NSURLSession 没有提供接口进行 SNI 字段 配置，因此需要 Socket 层级的底层网络库例如 CFNetwork，来实现 IP 直连网络请求适配方案。苹果提供的一些指导，在[Networking Programming Topics](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FNetworkingInternet%2FConceptual%2FNetworkingTopics%2FArticles%2FOverridingSSLChainValidationCorrectly.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40012544-SW1)中，可以通过如下方式指定一个TLS hostname：

```objective-c
NSDictionary *sslSettings = [NSDictionary dictionaryWithObjectsAndKeys:@"www.gatwood.net”, (__bridge id)kCFStreamSSLPeerName, nil];
if (![myInputStream setProperty: sslSettings forKey: (__bridge NSString *)kCFStreamPropertySSLSettings]) {
    // Handle the error here.
}
```

[Apple - Communicating with HTTP Servers](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fcontent%2Fdocumentation%2FNetworking%2FConceptual%2FCFNetwork%2FCFHTTPTasks%2FCFHTTPTasks.html%3Fspm%3Da2c4g.11186623.2.15.69695c57YspidG)
 [Apple - HTTPS Server Trust Evaluation - Server Name Failures](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fcontent%2Ftechnotes%2Ftn2232%2F_index.html%3Fspm%3D5176.doc30143.2.4.5016q8%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FDTS40012884-CH1-SECSERVERNAME)
 [Apple - HTTPS Server Trust Evaluation - Trusting One Specific Certificate](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fcontent%2Ftechnotes%2Ftn2232%2F_index.html%3Fspm%3D5176.doc30143.2.5.5016q8%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FDTS40012884-CH1-SECCUSTOMCERT)

#### 参考文献

[HTTPS场景IP直连方案说明](https://links.jianshu.com/go?to=https%3A%2F%2Fhelp.aliyun.com%2Fdocument_detail%2F30143.html%3Fspm%3Da2c4g.11186623.2.28.62766e96yMTgIh)

[使用CFNetwork进行HTTP请求](https://www.jianshu.com/p/20f0dddf9ccc)

