//
//  UIViewController+ErrorTips.h
//  Resident
//
//  Created by wenjun on 2017/6/5.
//  Copyright © 2017年 XingKang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSErrorTips.h"

@interface UIViewController (ErrorTips)

@property (nonatomic, strong) CSErrorTips *tipsView;

//加载数据、数据返回提示视图，服务器错误的可以无需传tips；全局页面加载的无需传frame
- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type  superView:(UIView*)superView frame:(CGRect)frame;
- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type frame:(CGRect)frame;
- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type superView:(UIView*)superView;
- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type  superView:(UIView*)superView frame:(CGRect)frame;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type frame:(CGRect)frame;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type superView:(UIView*)superView;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type imageName:(NSString*)imageName;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type;
- (CSErrorTips*)showLoadType:(ErrorTipsType)type;


//自动处理网络错误，无数据等界面,   注意重写- (void)needReloadData
- (CSErrorTips*)tipsSuccessWithStatusModel:(StatusModel*)data;

- (CSErrorTips*)tipsSuccessWithStatusModel:(StatusModel*)data noData:(BOOL)noData;

//开始加载
- (CSErrorTips*)tipsStartLoad;

//隐藏加载数据、数据返回提示视图；
- (void)hideTipsView;
//重新请求数据 子类重写
//- (void)needReloadData;

- (BOOL)isTipsViewHidden;

@end
