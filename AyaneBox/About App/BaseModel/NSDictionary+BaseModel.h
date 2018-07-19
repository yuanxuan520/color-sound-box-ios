//
//  NSDictionary+BaseModel.h
//  HuiXin
//
//  Created by 文俊 on 15/11/6.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BaseModel)

@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *mimeType;

+ (instancetype)bm_dictionaryWithData:(NSData*)data
                                 name:(NSString *)name
                             fileName:(NSString *)fileName
                             mimeType:(NSString *)mimeType;


- (NSString *)bm_jsonString;

@end
