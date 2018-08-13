//
//  PPRDData.h
//  ParkProject
//
//  Created by yuanxuan on 16/6/27.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestPostData : NSObject
@property (nonatomic, strong) NSMutableDictionary *downloadQueueDict;

+(RequestPostData *)shareRequestPostData;

//无cookie 常用请求
- (void)commonRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//用户登录使用
- (void)loginAFRequest:(NSString *)intefacePath userName:(NSString *)username password:(NSString *)password timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//普通的post请求
- (void)startAFRequest:(NSString *)intefacePath requestdata:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;

//更加完善的post请求
- (void)startAFRequest:(NSString *)intefacePath requestPOSTdata:(NSDictionary *)postDict parameters:(NSString *)jsondata timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock;
@end
