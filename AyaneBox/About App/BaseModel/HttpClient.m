//
//  HttpClient.m
//  HuiXin
//
//  Created by 文俊 on 15/11/6.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import "HttpClient.h"

static NSString *kAppUrl;

@implementation HttpClient

+ (void)startWithURL:(NSString *)url{
    kAppUrl = url;
    [self sharedInstance];
}

+ (instancetype)sharedInstance{
    static HttpClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *clientURL = [NSURL URLWithString:kAppUrl];
        
        if(!clientURL.host){
            NSLog(@"没有设置host，请先调用“startWithURL:”设置host");
        }
        
        if([clientURL.scheme isEqualToString:@"https"]){
            client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        } else {
            if (![clientURL.scheme isEqualToString:@"http"]) {
                clientURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",kAppUrl]];
            }
        }
        
        client = [[HttpClient alloc] initWithBaseURL:clientURL];
        client.responseType = ResponseOther;
        client.requestType = RequestOther;
    });
    return client;
}

#pragma mark - Get & set methods
- (void)setResponseType:(ResponseType)responseType{
    _responseType = responseType;
    if(responseType == ResponseXML){
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }else if(responseType == ResponseJSON){
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }else{
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
}

- (void)setRequestType:(RequestType)requestType{
    _requestType = requestType;
    if(requestType == RequestXML){
        self.requestSerializer = [AFPropertyListRequestSerializer serializer];
    }else if(requestType == RequestJSON){
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.requestSerializer.timeoutInterval = 30;
    }else{
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
}

@end
