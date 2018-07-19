//
//  UIButton+BadegeImage.m
//  SellHouseManager
//
//  Created by yangxu on 16/5/23.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "UIButton+BadegeImage.h"
#import "UIButton+TouchAreaInsets.h"

@implementation UIButton (BadegeImage)

- (void)setBadegeImage:(UIImage *)image
{
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGFloat imageWH = 15;
        imageView.frame = CGRectMake(0, 0, imageWH, imageWH);
        imageView.center = CGPointMake(self.width, 0);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:imageView];
        self.touchAreaInsets= UIEdgeInsetsMake(imageWH/2, 0, 0, imageWH/2);
    }
}

- (void)setMinusStyleBadege
{
    [self setBadegeImage:[UIImage imageNamed:@"xzrc_guanbi"]];
}

@end
