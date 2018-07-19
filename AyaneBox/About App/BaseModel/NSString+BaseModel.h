//
//  NSString+BaseModel.h
//  HuiXin
//
//  Created by 文俊 on 15/11/6.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BaseModel)

- (NSString *)bm_cacheMD5;

- (NSDictionary *)bm_dictionaryWithJSON;

@end
