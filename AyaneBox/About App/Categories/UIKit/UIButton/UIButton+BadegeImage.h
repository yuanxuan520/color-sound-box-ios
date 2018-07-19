//
//  UIButton+BadegeImage.h
//  SellHouseManager
//
//  Created by yangxu on 16/5/23.
//  Copyright © 2016年 JiCe. All rights reserved.
//

/* 设置按钮右上角图片view */

#import <UIKit/UIKit.h>

@interface UIButton (BadegeImage)

/* 设置按钮右上角图片 */
- (void)setBadegeImage:(UIImage *)image;
/* 设置按钮右上角减号图片 */
- (void)setMinusStyleBadege;

@end
