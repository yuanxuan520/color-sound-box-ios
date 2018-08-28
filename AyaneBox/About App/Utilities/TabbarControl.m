//
//  TabbarControl.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/8/1.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "TabbarControl.h"
#import "LEEAlert.h"
#import "RecordsViewController.h"
@implementation TabbarControl
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[RecordsViewController class]] && [PCMDataSource sharedData].ipAddress == nil){
        [LEEAlert alert].config
        .LeeTitle(@"注意")
        .LeeContent(@"请绑定设备，才能录音")
        .LeeAction(@"确认", ^{
        })
        .LeeShow();
        return NO;
    }
    if ([PCMDataSource sharedData].isRecord == YES) {
        [LEEAlert alert].config
        .LeeTitle(@"注意")
        .LeeContent(@"请停止录音，才能切换")
        .LeeAction(@"确认", ^{
        })
        .LeeShow();
        return NO;
    }
    
    if ([PCMDataSource sharedData].isPlay == YES) {
        [LEEAlert alert].config
        .LeeTitle(@"注意")
        .LeeContent(@"请停止播放，才能切换")
        .LeeAction(@"确认", ^{
        })
        .LeeShow();
        return NO;
    }
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}
@end
