//
//  UIViewController+GoToMeTableViewController.m
//  Resident
//
//  Created by Xin Sui Lu on 03/05/2017.
//  Copyright © 2017 XingKang. All rights reserved.
//

#import "UIViewController+Base.h"
//#import "XK_LoginViewController.h"

static char *kNetworkOperationsKey = "kNetworkOperationsKey";
static char *kKeyTapKey = "kKeyTapKey";

@interface UIViewController ()

- (void)backToSuperView;

@end

@implementation UIViewController (Base)

- (void)setNetworkOperations:(NSMutableArray *)networkOperations {
    objc_setAssociatedObject(self, &kNetworkOperationsKey, networkOperations, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray*)networkOperations {
    return objc_getAssociatedObject(self, &kNetworkOperationsKey);
}

- (void)setKeyTap:(UITapGestureRecognizer *)keyTap {
    objc_setAssociatedObject(self, &kKeyTapKey, keyTap, OBJC_ASSOCIATION_RETAIN);
}

- (UITapGestureRecognizer*)keyTap {
    return objc_getAssociatedObject(self, &kKeyTapKey);
}

+ (void)load
{
    [self swizzle:@selector(viewDidLoad)];
    [self swizzle:@selector(viewDidDisappear:)];
    [self swizzle:@selector(viewWillAppear:)];
    [self swizzle:@selector(viewWillDisappear:)];
//    [self swizzle:NSSelectorFromString(@"dealloc")];
}

+ (void)swizzle:(SEL)selector
{
    NSString *name = [NSString stringWithFormat:@"swizzled_%@", NSStringFromSelector(selector)];
    
    Method m1 = class_getInstanceMethod(self, selector);
    Method m2 = class_getInstanceMethod(self, NSSelectorFromString(name));
    
    method_exchangeImplementations(m1, m2);
}

- (void)swizzled_dealloc
{
    [self swizzled_dealloc];
    DLog(@"%@释放了",NSStringFromClass([self class]));
}

- (void)swizzled_viewDidLoad
{
    [self swizzled_viewDidLoad];
    [UIViewController attemptRotationToDeviceOrientation];
//    UINavigationController *nav = self.navigationController;
//    if (nav && nav.viewControllers.firstObject != self) {
//        [self configBackBarButton];
//    }
}

- (void)swizzled_viewDidDisappear:(BOOL)animated
{
    [self swizzled_viewDidDisappear:animated];
    if (!self.navigationController) {
        [self releaseNet];
        [self deallocTextFieldNSNotification];
    }
}

- (void)swizzled_viewWillAppear:(BOOL)animated
{
    [self swizzled_viewWillAppear:animated];
}

- (void)swizzled_viewWillDisappear:(BOOL)animated
{
    [self swizzled_viewWillDisappear:animated];
}

- (UIBarButtonItem*)getBackBarButton
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setImage:[[UIImage imageNamed:@"icon_nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    bt.frame = CGRectMake(0, 0, 44, 44);
    bt.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [bt addTarget:self action:@selector(a_backToSuperView) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}

- (void)configBackBarButton
{
    self.navigationItem.leftBarButtonItem = [self getBackBarButton];
}

- (void)a_backToSuperView
{
    if ([self respondsToSelector:@selector(backToSuperView)]) {
        [self backToSuperView];
        return;
    }
    [self popAndDismiss];
}

- (void)popAndDismiss
{
    if (self.navigationController.viewControllers.firstObject == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (self.presentedViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 登录相关
//- (void)loginVerify:(void (^)())success
//{
//    if ([DataManager sharedManager].isLogin) {
//        if (success) {
//            success();
//        }
//    }else{
//        XK_LoginViewController *loginVC = [[XK_LoginViewController alloc] init];
//        loginVC.completionBack = [success copy];
//        UINavigationController *navigationController = [[UINavigationController alloc]
//                                                        initWithRootViewController:loginVC];
//        [self presentViewController:navigationController animated:YES completion:nil];
//    }
//}

#pragma mark- 网络操作的添加和释放

- (void)addNet:(NSURLSessionDataTask *)net
{
    if (!self.networkOperations)
    {
        self.networkOperations = [[NSMutableArray alloc] init];
    }
    [self.networkOperations addObject:net];
}

- (void)releaseNet
{
    for (NSURLSessionDataTask *net in self.networkOperations)
    {
        if ([net isKindOfClass:[NSURLSessionDataTask class]]) {
            [net cancel];
        }
    }
    self.networkOperations = nil;
}

// 只支持竖屏
//- (BOOL)shouldAutorotate {
// return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
// return UIInterfaceOrientationMaskPortrait;
//}
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
// return UIInterfaceOrientationPortrait;
//}


#pragma mark-
#pragma mark- 键盘弹出点击空白处回收键盘

//点击空白处键盘收回
- (void)keyboardReturn{
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //键盘弹出后在屏幕添加手势，点击空白处收回键盘
    self.keyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHidden)];
}

//键盘弹出添加手势
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self.view addGestureRecognizer:self.keyTap];
}

//键盘收回移除手势
- (void)keyboardWillHide:(NSNotification*)notification
{
    [self.view removeGestureRecognizer:self.keyTap];
}

//收回键盘
- (void)keyboardHidden
{
    [self.view endEditing:YES];
}

//销毁键盘弹出通知
- (void)deallocTextFieldNSNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//end

@end
