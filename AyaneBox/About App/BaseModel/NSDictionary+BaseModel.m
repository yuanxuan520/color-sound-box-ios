//
//  NSDictionary+BaseModel.m
//  HuiXin
//
//  Created by 文俊 on 15/11/6.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import "NSDictionary+BaseModel.h"

#define dddata @"data"
#define ddmime @"mimeType"
#define ddfile @"fileName"
#define ddname @"name"

@implementation NSDictionary (BaseModel)

+ (instancetype)bm_dictionaryWithData:(NSData*)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [dictionary setObject:data forKey:dddata];
    [dictionary setObject:name forKey:ddname];
    [dictionary setObject:fileName forKey:ddfile];
    [dictionary setObject:mimeType forKey:ddmime];
    return dictionary;
}

- (NSString *)data{
    return [self objectForKey:dddata];
}

- (NSString *)mimeType{
    return [self objectForKey:ddmime];
}

- (NSString *)fileName{
    return [self objectForKey:ddfile];
}

- (NSString *)name{
    return [self objectForKey:ddname];
}

- (NSString *)bm_jsonString{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if(error)
        NSLog(@"error = %@",error);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
