//
//  StatusModel.m
//  HKMember
//
//  Created by 文俊 on 14-3-20.
//  Copyright (c) 2014年 文俊. All rights reserved.
//

#import "StatusModel.h"

@interface StatusModel ()
{
    BOOL _isServersError;
}
@end

@implementation StatusModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"code":@"ret_code",
             @"msg":@"ret_msg"};
}

+ (StatusModel *)statusModelFromJSONObject:(id)object class:(Class) class {
    StatusModel *statusModel = [StatusModel mj_objectWithKeyValues:object];
    id returnObject = nil;
    id rs = object[@"ret_data"];
    if (rs) {
        if ([rs isKindOfClass:[NSDictionary class]]) {
            returnObject = [class mj_objectWithKeyValues:rs];
        } else if ([rs isKindOfClass:[NSArray class]]) {
            returnObject = [class mj_objectArrayWithKeyValuesArray:rs];
        } else if ([rs isKindOfClass:[NSNull class]]) {
            returnObject = nil;
        }
    }
    statusModel.data = returnObject;
    statusModel.originalData = rs;
    return statusModel;
}

#pragma mark - Overwrite
- (void)mj_keyValuesDidFinishConvertingToObject
{
    //标准化系统msg
    NSString *fMsg = [[self class] innerFormatMessage:_code msg:_msg];
    if (![fMsg isEqualToString:_msg]) {
        self.msg = fMsg;
    }
}

#pragma mark - Init

- (id)initWithCode:(NSInteger)code msg:(NSString *)msg
{
    self = [super init];
    if (self) {
        self.code = code;
        self.msg = msg;
    }
    return self;
}

- (id)initWithError:(NSError*)error
{
    self = [super init];
    if (self) {
        // 先设置默认值
        NSString *msg;
        NSInteger code = error.code;
        //        msg = error.userInfo[NSLocalizedDescriptionKey];
        switch (error.code)
        {
            case NSURLErrorCancelled: // 网络请求已经取消!
                msg = @"";
                break;
            case  NSURLErrorTimedOut: // 网络请求超时
                msg = @"网络请求超时!";
                break;
            case NSURLErrorBadServerResponse: // 网络通了 404 500-内部服务器错误（有可能你的接口不对）
                msg = @"服务器内部错误!";
                break;
            case NSURLErrorCannotFindHost: //主机名时返回一个URL不能解决
                msg = @"找不到服务器!";
                break;
            case NSURLErrorCannotConnectToHost: //当试图连接到主机返回失败了。这可能发生在一个主机名解析,但主机或可能不会接受特定端口上的连接。
                msg = @"无法连接到服务器!";
                break;
            case NSURLErrorNotConnectedToInternet: // 没有网络   返回一个网络资源请求的时候,但不是建立一个互联网连接和自动无法建立,通过缺乏连接,或由用户选择不自动进行网络连接
                msg = @"网络不可用,请检查网络!";
                break;
            default:
                msg = @"网络请求出现未知错误!";
                break;
        }
        
        self.code = code;
        self.msg = msg;
        _isServersError = error.code != 0;
    }
    return self;
}

- (BOOL)isBadNetWork
{
    if (self.code == NSURLErrorCannotFindHost || self.code == NSURLErrorCannotConnectToHost || self.code == NSURLErrorNotConnectedToInternet) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isServersError
{
    return _isServersError;
}

- (BOOL)isSucceed
{
    return (_code == 1);
}

#pragma mark - Private

/// 格式化输出系统提示信息
+ (NSString *)innerFormatMessage:(NSInteger)flag msg:(NSString *)msg {
    NSString *tmpMsg = msg;
    /*
    switch (flag) {
        case -1:
            
            break;
    }
     */
    return tmpMsg;
}

@end
