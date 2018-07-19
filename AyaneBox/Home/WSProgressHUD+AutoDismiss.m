//
//  WSProgressHUD+AutoDismiss.m
//  Manly
//
//  Created by yuanxuan on 2017/4/13.
//  Copyright © 2017年 topflames. All rights reserved.
//

#import "WSProgressHUD+AutoDismiss.h"

@implementation WSProgressHUD (AutoDismiss)
+ (void)autoDismiss:(CGFloat)secend
{
    int64_t sec = (int64_t)(secend * NSEC_PER_SEC);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
    
}
@end
