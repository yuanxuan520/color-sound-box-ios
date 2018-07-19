//
//  UIViewController+GoToMeTableViewController.h
//  Resident
//
//  Created by Xin Sui Lu on 03/05/2017.
//  Copyright © 2017 XingKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Base)

@property (nonatomic, strong) NSMutableArray *networkOperations;
@property (nonatomic, strong) UITapGestureRecognizer *keyTap;

/**
 *  添加按钮，跳转到“我的”界面
 */
- (void)addButtonGoToMeTableViewController;

- (UIBarButtonItem*)getBackBarButton;

- (void)configBackBarButton;

- (void)popAndDismiss;

//- (void)loginVerify:(void (^)())success;

/// 添加网络操作，便于释放
- (void)addNet:(NSURLSessionDataTask *)net;

/// 释放网络
- (void)releaseNet;

//点击空白处键盘收回
- (void)keyboardReturn;

@end
