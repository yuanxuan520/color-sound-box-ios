//
//  RequestPostData.m
//  ParkProject
//
//  Created by yuanxuan on 16/6/27.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "RequestPostData.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"

@interface RequestPostData ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) AFURLSessionManager *urlManager;
@end



@implementation RequestPostData
@synthesize httpManager,urlManager;
@synthesize downloadQueueDict;
+ (RequestPostData *)shareRequestPostData{
    static RequestPostData *networking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networking = [[RequestPostData alloc] init];
        
        AFHTTPSessionManager *httphmanager = [AFHTTPSessionManager manager];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *urlmanager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSMutableDictionary *dictinfo = [NSMutableDictionary dictionaryWithCapacity:0];
        
        
        networking.httpManager = httphmanager;
        networking.urlManager = urlmanager;
        networking.downloadQueueDict = dictinfo;
        
    });
    return networking;
}

- (void)commonRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SEVERURL,intefacePath];
    NSDictionary *parameters = nil;
    if (jsondata != nil) {
        parameters = @{@"params" : jsondata};
    }
    //    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *manage = [RequestPostData shareRequestPostData].httpManager;
    //申明返回的结果是json类型
    manage.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    //申明请求的数据是json类型
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    //    multipart/form-data
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    
    
    //    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie]];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        NSData *jsonData = responseObject;
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"%@",datastr);
        if (datastr == nil) {
            datastr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
        }
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData==nil){//接口请求发生异常，直接返回
            return;
        }
        //
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //                NSLog(@"next:json%@",json);
        if (completionBlock) {
            completionBlock(json);
        }
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //                NSLog(@"%@",error.userInfo);
        //        NSData *jsonData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        //        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}

- (void)loginAFRequest:(NSString *)intefacePath userName:(NSString *)username password:(NSString *)password timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    
    //    NSString *password = nil;//123456
    //    password = [self sha1: [self md5:password]];
    //    NSString *dJson = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",username,password];//wap/token
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SEVERURL,intefacePath];
    
    NSDictionary *parameters = @{@"username" : username,@"password" : password , @"v":@"2"};
    //    NSLog(@"%@",parameters);
    
    
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    //    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    // 是否允许,NO-- 不允许无效的证书
    //    [securityPolicy setAllowInvalidCertificates:YES];
    //    [securityPolicy setValidatesDomainName:NO];
    //    // 设置证书
    //    [securityPolicy setPinnedCertificates:certSet];
    //申明返回的结果是json类
    AFHTTPSessionManager *manage = [RequestPostData shareRequestPostData].httpManager;
    
    //    manage.securityPolicy = securityPolicy;
    manage.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manage.requestSerializer setHTTPShouldHandleCookies:YES];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    //申明请求的数据是json类型
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    //    multipart/form-data
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    
    
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        NSData *jsonData = responseObject;
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"%@",datastr);
        
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData==nil){//接口请求发生异常，直接返回
            NSLog(@"登录发生错误!");
            return;
        }
        //
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //        NSLog(@"next:json%@",json);
        if (completionBlock) {
            //            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            //            if (response.allHeaderFields[@"Set-Cookie"]) {
            //                NSString *cookie = response.allHeaderFields[@"Set-Cookie"];
            //                [USERDEFAULTS setObject:cookie forKey:kUserDefaultsCookie];
            //                [USERDEFAULTS synchronize];
            //            }
            
            [self setCookies:urlString];
            completionBlock(json);
        }
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
}

// 常用的parameters 包裹
- (void)startAFRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SEVERURL,intefacePath];
    NSDictionary *parameters = nil;
    if (jsondata != nil) {
        parameters = @{@"params" : jsondata};
    }
    //    NSLog(@"%@",parameters);
    
    AFHTTPSessionManager *manage = [RequestPostData shareRequestPostData].httpManager;
    //申明返回的结果是json类型
    manage.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    //申明请求的数据是json类型
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    //    multipart/form-data
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    
    id cookieStr = [USERDEFAULTS objectForKey:kUserDefaultsCookie];
    if (cookieStr && [cookieStr isKindOfClass:[NSString class]]) {
        [manage.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }else{
        [manage.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
    }
    //    NSString *cookieStr = [self setCookies];
    //    [manage.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    //    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[USERDEFAULTS objectForKey:kUserDefaultsCookie]];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    //
    
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        if (responseObject == nil) {
            if (completionBlock) {
                completionBlock(nil);
            }
        }else{
            NSData *jsonData = responseObject;
            //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            //        NSLog(@"json:%@",jsonData);
            NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //        NSLog(@"%@",datastr);
            if (datastr == nil) {
                datastr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
            }
            NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
            if(jsonData==nil){//接口请求发生异常，直接返回
                return;
            }
            //
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //                NSLog(@"next:json%@",json);
            if (completionBlock) {
                completionBlock(json);
            }
        }
        
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        NSData *jsonData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        //                [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (json) {
            NSInteger result = [json[@"result"] integerValue];
            if (result == 1001) { // 根据1001 判断是否登录失效
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:json[@"msg"]
                                      delegate:nil
                                      cancelButtonTitle:@"知道了"
                                      otherButtonTitles:nil, nil];
                [alert show];
                [USERDEFAULTS removeObjectForKey:kUserDefaultsCookie];
                [USERDEFAULTS removeObjectForKey:kSaveUserDefaultsCookie];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTIFACTION object:nil];
            }
        }
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
    
    //    NSString *password = nil;//123456
    //    password = [self sha1: [self md5:password]];
    //    NSString *dJson = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",username,password];//wap/token
    //    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

}

// 常用的parameters 包裹
- (void)startAFRequest:(NSString *)intefacePath requestPOSTdata:(NSDictionary *)postDict parameters:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock
{
    dispatch_group_t group_request = dispatch_group_create();
    dispatch_group_enter(group_request);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SEVERURL,intefacePath];
    NSMutableDictionary *parameters = nil;
    if (postDict) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:postDict];
    }else {
        parameters = [NSMutableDictionary dictionaryWithCapacity:0];

    }
    if (jsondata != nil) {
        [parameters setObject:jsondata forKey:@"params"];
    }
    
    AFHTTPSessionManager *manage = [RequestPostData shareRequestPostData].httpManager;
    //申明返回的结果是json类型
    manage.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    //申明请求的数据是json类型
    manage.requestSerializer.timeoutInterval = timeOutSeconds;
    //    multipart/form-data
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    
    id cookieStr = [USERDEFAULTS objectForKey:kUserDefaultsCookie];
    if (cookieStr && [cookieStr isKindOfClass:[NSString class]]) {
        [manage.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }else{
        [manage.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
    }
    //    NSString *cookieStr = [self setCookies];
    //    [manage.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    //    NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[USERDEFAULTS objectForKey:kUserDefaultsCookie]];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    //
    
    [manage POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        if (responseObject == nil) {
            if (completionBlock) {
                completionBlock(nil);
            }
        }else{
            NSData *jsonData = responseObject;
            //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            //        NSLog(@"json:%@",jsonData);
            NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //        NSLog(@"%@",datastr);
            if (datastr == nil) {
                datastr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
            }
            NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
            if(jsonData==nil){//接口请求发生异常，直接返回
                return;
            }
            //
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //                NSLog(@"next:json%@",json);
            if (completionBlock) {
                completionBlock(json);
            }
        }
        
        dispatch_group_leave(group_request);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        NSData *jsonData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        //                [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (json) {
            NSInteger result = [json[@"result"] integerValue];
            if (result == 1001) { // 根据1001 判断是否登录失效
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:json[@"msg"]
                                      delegate:nil
                                      cancelButtonTitle:@"知道了"
                                      otherButtonTitles:nil, nil];
                [alert show];
                [USERDEFAULTS removeObjectForKey:kUserDefaultsCookie];
                [USERDEFAULTS removeObjectForKey:kSaveUserDefaultsCookie];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTIFACTION object:nil];
            }
            //            []
        }
        if (failedBlock) {
            NSError *requestError = error;
            failedBlock(requestError);
        }
        dispatch_group_leave(group_request);
    }];
    dispatch_group_notify(group_request, dispatch_get_main_queue(), ^{
        
    });
    
    //    NSString *password = nil;//123456
    //    password = [self sha1: [self md5:password]];
    //    NSString *dJson = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",username,password];//wap/token
    
    
    
    //    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    
    
    
}



- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)sha1:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

- (void)setCookies:(NSString *)urlString {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlString]];
    //    NSHTTPCookie *cookie = [cookies lastObject];
    // 存储cookie
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [USERDEFAULTS setObject:cookiesData forKey:kSaveUserDefaultsCookie];
    [USERDEFAULTS synchronize];
    
    //    NSData *cookiesData = [USERDEFAULTS objectForKey:kSaveUserDefaultsCookie];
    //    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
    //    for (NSHTTPCookie *cookie in cookies) {
    //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //    }
    
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    //    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    
    NSMutableString *cookieStr = [[NSMutableString alloc] initWithString:@""];
    for (NSString *key in [cookieDic allKeys]) {
        if ([key isEqualToString:@"JSESSIONID"]) {
            NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
            [cookieStr appendString:appendString];
        }
    }
    [USERDEFAULTS setObject:cookieStr forKey:kUserDefaultsCookie];
    [USERDEFAULTS synchronize];
}

//1.获取登陆请求成功后保存的cookies:
+ (NSString *)cookieValueWithKey:(NSString *)key
{
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    if ([sharedHTTPCookieStorage cookieAcceptPolicy] != NSHTTPCookieAcceptPolicyAlways) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    }
    
    NSArray         *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:@"http://192...."]];
    NSEnumerator    *enumerator = [cookies objectEnumerator];
    NSHTTPCookie    *cookie;
    while (cookie = [enumerator nextObject]) {
        if ([[cookie name] isEqualToString:key]) {
            return [NSString stringWithString:[[cookie value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return nil;
}

//2.删除cookies (key所对应的cookies) ///因为cookies保存在NSHTTPCookieStorage.cookies中.这里删除它里边的元素即可.
+ (void)deleteCookieWithKey:(NSString *)key
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (NSHTTPCookie *cookie in cookies) {
        if ([[cookie name] isEqualToString:key]) {
            [cookieJar deleteCookie:cookie];
        }
    }
}


@end
