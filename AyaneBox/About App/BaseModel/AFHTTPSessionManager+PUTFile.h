//
//  AFHTTPSessionManager+PUTFile.h
//  Resident
//
//  Created by wenjun on 2017/6/2.
//  Copyright © 2017年 XingKang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BaseModel.h"

@interface AFHTTPSessionManager (PUTFile)

- (nullable NSURLSessionDataTask *)uploadMethod:(NSString *_Nullable)method
                                      URLString:(NSString *_Nullable)URLString
                                     parameters:(nullable id)parameters
                      constructingBodyWithBlock:(nullable void (^)(id _Nullable formData))block
                                       progress:(nullable void (^)(NSProgress * _Nullable uploadProgress))uploadProgress
                                        success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

@end
