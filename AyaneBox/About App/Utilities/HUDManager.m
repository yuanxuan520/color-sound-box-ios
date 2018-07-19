//
//  HUDManager.m
//  DemoHUD
//
//  Created by zhangshaoyu on 14-10-28.
//  Copyright (c) 2014年 ygsoft. All rights reserved.
//

#import "HUDManager.h"

// 导入头文件 用于显示指示器的背景视图
#import "AppDelegate.h"

// 定义变量
static MBProgressHUD *mbProgressHUD;
static UIView *customView;
@implementation HUDManager

+ (void)showHUDWithMessage:(NSString *)aMessage
{
    [self showHUD:MBProgressHUDModeIndeterminate onTarget:nil hide:NO afterDelay:0 enabled:NO message:aMessage];
}

+ (void)showHUDWithMessage:(NSString *)aMessage onTarget:(UIView *)target
{
    [self showHUD:MBProgressHUDModeIndeterminate onTarget:target hide:NO afterDelay:0 enabled:NO message:aMessage];
}

+ (void)showHUD:(MBProgressHUDMode)mode hide:(BOOL)autoHide afterDelay:(NSTimeInterval)timeDelay enabled:(BOOL)autoEnabled message:(NSString *)aMessage
{
    [self showHUD:mode onTarget:nil hide:autoHide afterDelay:timeDelay enabled:autoHide message:aMessage];
}

+ (void)showHUD:(MBProgressHUDMode)mode onTarget:(UIView *)target hide:(BOOL)autoHide afterDelay:(NSTimeInterval)timeDelay enabled:(BOOL )autoEnabled message:(NSString *)aMessage
{
    [self showHUD:mode onTarget:target hide:autoHide afterDelay:timeDelay enabled:autoHide message:aMessage imageName:nil];
}

+ (void)showHUD:(MBProgressHUDMode)mode onTarget:(UIView *)target hide:(BOOL)autoHide afterDelay:(NSTimeInterval)timeDelay enabled:(BOOL )autoEnabled message:(NSString *)aMessage imageName:(NSString*)imageName
{
    // 如果已存在，则从父视图移除
    if (mbProgressHUD.superview)
    {
        [mbProgressHUD removeFromSuperview];
        mbProgressHUD = nil;
    }
    
    if (target && [target isKindOfClass:[UIView class]]) {
        // 添加到目标视图
        mbProgressHUD = [MBProgressHUD showHUDAddedTo:target animated:YES];
    } else {
        // 创建显示视图
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        mbProgressHUD = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    }
    
    // 设置显示模式
    [mbProgressHUD setMode:mode];
    
    // 如果是自定义图标模式，则显示
    if (mode == MBProgressHUDModeCustomView)
    {
        if (imageName) {
            // 设置自定义图标
            UIImageView *customImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            [mbProgressHUD setCustomView:customImageView];
        }else if (customView) {
            [mbProgressHUD setCustomView:customView];
            customView = nil;
        }
    }
    
    // 如果是填充模式
    if (mode == MBProgressHUDModeDeterminate || mode == MBProgressHUDModeAnnularDeterminate || mode == MBProgressHUDModeDeterminateHorizontalBar)
    {
        // 方法2
        [mbProgressHUD showWhileExecuting:@selector(showProgress) onTarget:self withObject:nil animated:YES];
    }
    
    // 设置标示标签
    [mbProgressHUD setLabelText:aMessage];
    
    // 设置显示类型 出现或消失
    [mbProgressHUD setAnimationType:MBProgressHUDAnimationZoomOut];
    
    // 显示
    [mbProgressHUD show:YES];
    
    // 加上这个属性才能在HUD还没隐藏的时候点击到别的view
    // 取反，即!autoEnabled
    [mbProgressHUD setUserInteractionEnabled:!autoEnabled];
    
    // 隐藏后从父视图移除
    [mbProgressHUD setRemoveFromSuperViewOnHide:YES];
    
    // 设置自动隐藏
    if (autoHide)
    {
        [mbProgressHUD hide:autoHide afterDelay:timeDelay];
    }
}

+ (void)hiddenHUD
{
    [mbProgressHUD hide:YES];
}

+ (void)showProgress
{
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.05f;
        [mbProgressHUD setProgress:progress];
        usleep(50000);
    }
}

+ (void)showSuccessWithTitle:(NSString*)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 43+10)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark"]];
    imageView.frame = CGRectMake(0, 0, 43, 43);
    [view addSubview:imageView];
    customView = view;
    
    [self showHUD:MBProgressHUDModeCustomView onTarget:nil hide:YES afterDelay:1 enabled:YES message:title imageName:nil];
    mbProgressHUD.backgroundColor = UIColorHexAndAlpha(0x000000, 0.1);
    mbProgressHUD.color = UIColorHex(0xffffff);
    mbProgressHUD.labelFont = [UIFont systemFontOfSize:16];
    mbProgressHUD.labelColor = kColor_Text_Black;
    mbProgressHUD.animationType = MBProgressHUDAnimationFade;
    mbProgressHUD.cornerRadius = 4.0;
    
}

+ (void)alertWithTitle:(NSString*)title
{
    if ([NSString isNull:title]) {
        return;
    }
    [self showHUD:MBProgressHUDModeText onTarget:nil hide:YES afterDelay:1.5 enabled:YES message:title];
    mbProgressHUD.margin = 6.f;
    mbProgressHUD.labelFont = [UIFont systemFontOfSize:16];
    mbProgressHUD.labelColor = [UIColor whiteColor];
    mbProgressHUD.yOffset = -58.f;
    mbProgressHUD.cornerRadius = 3;    //设置圆形角
//    mbProgressHUD.animationType = MBProgressHUDAnimationFade;
}

@end

@implementation HUDManager (ZHCategory)

+(void)setHUDCustomView:(UIView *)view{
    customView=view;
}

@end
