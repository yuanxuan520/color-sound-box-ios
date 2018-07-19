//
//  UIViewController+ErrorTips.m
//  Resident
//
//  Created by wenjun on 2017/6/5.
//  Copyright © 2017年 XingKang. All rights reserved.
//

#import "UIViewController+ErrorTips.h"
#import <objc/runtime.h>


static char *kCSErrorTipsKey = "kCSErrorTipsKey";

@interface UIViewController ()

- (void)needReloadData;

@end

@implementation UIViewController (ErrorTips)

- (void)setTipsView:(CSErrorTips *)tipsView {
    objc_setAssociatedObject(self, &kCSErrorTipsKey, tipsView, OBJC_ASSOCIATION_RETAIN);
}

- (CSErrorTips*)tipsView {
    return objc_getAssociatedObject(self, &kCSErrorTipsKey);
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type  superView:(UIView*)superView frame:(CGRect)frame imageName:(NSString*)imageName
{
    if (type == ErrorTipsType_BadNetWork) {
        [self showTipsByBadNetWorkWithFrame:frame superView:superView];
    } else if (type == ErrorTipsType_NoData) {
        [self showNoDataTips:tips subTips:subTips type:type withFrame:frame superView:superView imageName:imageName];
    } else if (type == ErrorTipsType_Loading) {
        [self showLoadingTipsWithFrame:frame superView:superView];
    } else if (type == ErrorTipsType_ServerError) {
        [self showTipsBySeverErrorWithFrame:frame superView:superView];
    }
    return self.tipsView;
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type  superView:(UIView*)superView frame:(CGRect)frame
{
    return [self showLoadTips:tips subTips:subTips type:type superView:superView frame:frame imageName:nil];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type frame:(CGRect)frame
{
    return [self showLoadTips:tips subTips:subTips type:type superView:self.view frame:frame];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type superView:(UIView*)superView
{
    if (superView && (![superView isEqual:self.view])) {
        [superView addSubview:self.tipsView];
    }
    return [self showLoadTips:tips subTips:subTips type:type superView:superView frame:superView.bounds];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type
{
    return [self showLoadTips:tips subTips:subTips type:type superView:self.view frame:self.view.bounds];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type superView:(UIView*)superView frame:(CGRect)frame
{
    return [self showLoadTips:tips subTips:nil type:type superView:superView frame:frame];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type frame:(CGRect)frame
{
    return [self showLoadTips:tips type:type superView:self.view frame:frame];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type superView:(UIView*)superView
{
    if (superView && (![superView isEqual:self.view])) {
        [superView addSubview:self.tipsView];
    }
    return [self showLoadTips:tips type:type superView:superView frame:superView.bounds];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type imageName:(NSString*)imageName
{
    return [self showLoadTips:tips subTips:nil type:type superView:self.view frame:self.view.bounds imageName:imageName];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type
{
    return [self showLoadTips:tips type:type superView:self.view frame:self.view.bounds];
}

- (CSErrorTips*)showLoadType:(ErrorTipsType)type
{
    return [self showLoadTips:nil type:type superView:self.view frame:self.view.bounds];
}



//网络错误
- (void)showTipsByBadNetWorkWithFrame:(CGRect)frame superView:(UIView*)superView
{
    if (!self.tipsView) {
        self.tipsView = [[CSErrorTips alloc] initWithFrame:frame];
        [superView addSubview:self.tipsView];
    }
    self.tipsView.frame = frame;
    self.tipsView.hidden = NO;
    [self.view bringSubviewToFront:self.tipsView];
    [self.tipsView reloadTips:@"网络正开小差！" subTips:nil withType:ErrorTipsType_BadNetWork];
    @weakify(self);
    self.tipsView.repeatLoadBlock = ^(){
        @strongify(self);
        if ([self respondsToSelector:@selector(needReloadData)]) {
            [self needReloadData];
        }
    };
}

//服务器错误
- (void)showTipsBySeverErrorWithFrame:(CGRect)frame superView:(UIView*)superView
{
    if (!self.tipsView) {
        self.tipsView = [[CSErrorTips alloc] initWithFrame:frame];
        [superView addSubview:self.tipsView];
    }
    self.tipsView.frame = frame;
    self.tipsView.hidden = NO;
    [self.view bringSubviewToFront:self.tipsView];
    [self.tipsView reloadTips:@"数据加载失败！" subTips:nil withType:ErrorTipsType_ServerError];
    @weakify(self);
    self.tipsView.repeatLoadBlock = ^(){
        @strongify(self);
        if ([self respondsToSelector:@selector(needReloadData)]) {
            [self needReloadData];
        }
    };
}

//页面加载数据中
- (void)showLoadingTipsWithFrame:(CGRect)frame superView:(UIView*)superView
{
    if (!self.tipsView) {
        self.tipsView = [[CSErrorTips alloc] initWithFrame:frame];
        [superView addSubview:self.tipsView];
    }
    self.tipsView.hidden = NO;
    [self.view bringSubviewToFront:self.tipsView];
    [self.tipsView reloadTips:nil subTips:nil withType:ErrorTipsType_Loading];
}

//暂无数据
- (void)showNoDataTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type withFrame:(CGRect)frame superView:(UIView*)superView imageName:(NSString*)imageName
{
    if (!self.tipsView) {
        self.tipsView = [[CSErrorTips alloc] initWithFrame:frame];
        [superView addSubview:self.tipsView];
    }
    self.tipsView.frame = frame;
    self.tipsView.hidden = NO;
    [self.view bringSubviewToFront:self.tipsView];
    [self.tipsView reloadTips:tips?:@"Nothing，暂无相关数据！" subTips:subTips withType:type imageName:imageName];
}

- (CSErrorTips*)tipsSuccessWithStatusModel:(StatusModel*)data
{
    BOOL noData;
    if ([data.data isKindOfClass:[NSArray class]]) {
        NSArray *array = data.data;
        noData = array.count<=0;
    }else{
        noData = data.data?YES:NO;
    }
    return [self tipsSuccessWithStatusModel:data noData:noData];
}

- (CSErrorTips*)tipsSuccessWithStatusModel:(StatusModel*)data noData:(BOOL)noData
{
    if (data.isSucceed) {
        if (noData) {
            return [self showLoadType:ErrorTipsType_NoData];
        }else{
            if ([self.view isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scroll = (UIScrollView*)self.view;
                scroll.scrollEnabled = YES;
            }
            [self hideTipsView];
            return nil;
        }
    }else{
        if ([data isBadNetWork]) {
            return [self showLoadType:ErrorTipsType_BadNetWork];
        }else {
            return [self showLoadType:ErrorTipsType_ServerError];
        }
    }
}

- (CSErrorTips*)tipsStartLoad
{
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView*)self.view;
        scroll.scrollEnabled = NO;
    }
    return [self showLoadType:ErrorTipsType_Loading];
}

- (void)hideTipsView
{
    
    [self.tipsView hideTipsView];
}

- (BOOL)isTipsViewHidden
{
    if (!self.tipsView) {
        return YES;
    }
    
    return self.tipsView.hidden;
}

@end
