//
//  UITabBar+Badge.h
//  SellHouseManager
//
//  Created by yangxu on 16/8/31.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
