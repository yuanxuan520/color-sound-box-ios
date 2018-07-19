//
//  UIView+SplitLine.h
//  SellHouseManager
//
//  Created by 文俊 on 2016/11/17.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ZDBorderType) {
    ZDBorderTypeTop     = 1 << 0,
    ZDBorderTypeRight   = 1 << 1,
    ZDBorderTypeBottom  = 1 << 2,
    ZDBorderTypeLeft    = 1 << 3
};

@interface UIView (SplitLine)

///边框类型
@property(nonatomic,assign) ZDBorderType borderType;

///边框颜色
@property(nonatomic,strong) UIColor *borderColor;

@end
