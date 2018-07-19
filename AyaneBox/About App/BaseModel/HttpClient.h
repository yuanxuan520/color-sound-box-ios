//
//  HttpClient.h
//  HuiXin
//
//  Created by 文俊 on 15/11/6.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum : NSUInteger {
    ResponseXML,
    ResponseJSON,
    ResponseOther,
} ResponseType;

typedef enum : NSUInteger {
    RequestXML,
    RequestJSON,
    RequestOther,
} RequestType;

#define kHttpClient [HttpClient sharedInstance]

@interface HttpClient : AFHTTPSessionManager


@property (nonatomic) ResponseType responseType; //响应类型
@property (nonatomic) RequestType requestType; //请求类型

//设置host
+ (void)startWithURL:(NSString *)url;

//单例
+ (instancetype)sharedInstance;

@end
