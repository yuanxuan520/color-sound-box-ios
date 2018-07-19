//
//  NetCache.h
//  HuiXin
//
//  Created by 文俊 on 15/11/5.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import "BaseModel.h"

@interface NetCache : BaseModel

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *parameter;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *updateDate;

+ (void)queryWithPath:(NSString *)path
            parameter:(NSDictionary *)parameter
               result:(void (^)(NetCache *))block;

- (instancetype)initWithPath:(NSString *)path
                   parameter:(NSDictionary *)parameter
                     content:(id)content;

+ (void)cacheWithPath:(NSString *)path
            parameter:(NSDictionary *)parameter
              content:(id)content;

@end
