//
//  UpdatePasswordViewController.m
//  MuTianXia
//
//  Created by yuanxuan on 15/11/26.
//  Copyright © 2015年 yuanxuan. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import <CommonCrypto/CommonDigest.h>


@interface UpdatePasswordViewController ()<UIAlertViewDelegate>
{
    UITextField *userAccount;
    UITextField *originalPassword;
    UITextField *password;
    UITextField *againPassword;
}


@end

@implementation UpdatePasswordViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"修改密码";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xf8f8f8);
    [self.navigationController setNavigationBarHidden:NO];
    
    UIImageView *backimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight)];
    backimgView.userInteractionEnabled = YES;
    [self.view addSubview:backimgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbackimgView:)];
    tap1.numberOfTapsRequired = 1;
    [backimgView addGestureRecognizer:tap1];
    //    navigationimgView.backgroundColor = [UIColor whiteColor]
    
    
    //输入手机号
    userAccount = [[UITextField alloc] initWithFrame:CGRectMake(0, APPNavStateBar+10, APPMainViewWidth, 50)];
    //    userAccount.backgroundColor = [UIColor cyanColor];
    userAccount.placeholder = @"请输入您的注册手机号";
    userAccount.keyboardType = UIKeyboardTypePhonePad;
    userAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
    userAccount.userInteractionEnabled = NO;
    [userAccount.layer setMasksToBounds:YES];
    userAccount.font = SystemFont(14);
    userAccount.backgroundColor = [UIColor whiteColor];
    userAccount.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    [userAccount.layer setBorderWidth:0.5];
    userAccount.layer.borderColor = UIColorHex(0xf0f0f0).CGColor;
    [self.view addSubview:userAccount];
    UIButton *oneLeftLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [oneLeftLabel setTitle:@"当前账号:" forState:UIControlStateNormal];
    [oneLeftLabel setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    oneLeftLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
    oneLeftLabel.titleLabel.font = SystemFont(14);
    oneLeftLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    oneLeftLabel.titleLabel.textAlignment = NSTextAlignmentLeft;
    userAccount.leftView = oneLeftLabel;
    userAccount.leftViewMode = UITextFieldViewModeAlways;
    
    //输入密码
    originalPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, userAccount.frame.origin.y+userAccount.bounds.size.height+10, APPMainViewWidth, 50)];
    originalPassword.placeholder = @"请输入原密码";
    [originalPassword.layer setMasksToBounds:YES];
    [originalPassword.layer setBorderWidth:0.5];
    originalPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    originalPassword.layer.borderColor = UIColorHex(0xf0f0f0).CGColor;
    originalPassword.font = SystemFont(14);
    originalPassword.backgroundColor = [UIColor whiteColor];
    originalPassword.secureTextEntry = YES;
    
    [self.view addSubview:originalPassword];
    UIButton *originalLeftLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [originalLeftLabel setTitle:@"原密码:" forState:UIControlStateNormal];
    [originalLeftLabel setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    originalLeftLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
    originalLeftLabel.titleLabel.font = SystemFont(14);
    originalLeftLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    originalLeftLabel.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    originalPassword.leftView = originalLeftLabel;
    originalPassword.leftViewMode = UITextFieldViewModeAlways;
    
    //输入密码
    password = [[UITextField alloc] initWithFrame:CGRectMake(0, originalPassword.frame.origin.y+originalPassword.bounds.size.height+10, APPMainViewWidth, 50)];
    password.placeholder = @"请输入新密码";
    [password.layer setMasksToBounds:YES];
    [password.layer setBorderWidth:0.5];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    password.layer.borderColor = UIColorHex(0xf0f0f0).CGColor;
    password.font = SystemFont(14);
    password.backgroundColor = [UIColor whiteColor];
    password.secureTextEntry = YES;
    
    [self.view addSubview:password];
    UIButton *threeLeftLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [threeLeftLabel setTitle:@"新密码:" forState:UIControlStateNormal];
    [threeLeftLabel setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    threeLeftLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
    threeLeftLabel.titleLabel.font = SystemFont(14);
    threeLeftLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    threeLeftLabel.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    password.leftView = threeLeftLabel;
    password.leftViewMode = UITextFieldViewModeAlways;
    
    //确认密码
    againPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, password.frame.origin.y+password.bounds.size.height+10, APPMainViewWidth, 50)];
    againPassword.placeholder = @"请再输入一次新密码";
    [againPassword.layer setMasksToBounds:YES];
    againPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    againPassword.font = SystemFont(14);
    againPassword.backgroundColor = [UIColor whiteColor];
    [againPassword.layer setBorderWidth:0.5];
    againPassword.secureTextEntry = YES;
    
    againPassword.layer.borderColor = UIColorHex(0xf0f0f0).CGColor;
    [self.view addSubview:againPassword];
    UIButton *fourLeftLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [fourLeftLabel setTitle:@"确认密码:" forState:UIControlStateNormal];
    [fourLeftLabel setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    fourLeftLabel.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
    fourLeftLabel.titleLabel.font = SystemFont(14);
    fourLeftLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    fourLeftLabel.titleLabel.textAlignment = NSTextAlignmentLeft;
    againPassword.leftView = fourLeftLabel;
    againPassword.leftViewMode = UITextFieldViewModeAlways;
    
    //注册 button
    UIButton *regiester = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    regiester.frame = CGRectMake(30, againPassword.frame.origin.y+againPassword.bounds.size.height+50, APPMainViewWidth-60, 40);
    [regiester.layer setMasksToBounds:YES];
    [regiester.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    regiester.titleLabel.font = SystemFont(16);
    regiester.backgroundColor = UIColorHex(0x189cfb);
    [regiester setTitle:@"确认修改" forState:UIControlStateNormal];
    [regiester setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regiester addTarget:self action:@selector(modifypassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regiester];
}

- (void)modifypassword:(UIButton *)btn
{
    if (![originalPassword.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]) {
        [WSProgressHUD showShimmeringString:@"原密码不正确" maskType:WSProgressHUDMaskTypeDefault];
        [WSProgressHUD autoDismiss:1];
        return;
    }

    if ([password.text length] < 6) {
        [WSProgressHUD showShimmeringString:@"新密码必须为6位数以上" maskType:WSProgressHUDMaskTypeDefault];
        [WSProgressHUD autoDismiss:1];
        return;
    }

    if (![password.text isEqualToString:againPassword.text]) {
        [WSProgressHUD showShimmeringString:@"确认新密码不一致" maskType:WSProgressHUDMaskTypeDefault];
        [WSProgressHUD autoDismiss:1];
        return;
    }


    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeClear];
    //得到自己当前的下属
    NSString *dJson = [NSString stringWithFormat:@"{\"userPassword\":\"%@\"}",password.text];

    RequestPostData *pprddata = [[RequestPostData alloc] init];
    [pprddata startAFRequest:UpdatePwd
                 requestdata:dJson
              timeOutSeconds:30
             completionBlock:^(NSDictionary *json) {
                 if (![[json objectForKey:@"result"] integerValue]) {
                     [kUserDefaults setObject:password.text forKey:@"password"];
                     [kUserDefaults synchronize];
                     [WSProgressHUD showShimmeringString:@"修改密码成功!" maskType:WSProgressHUDMaskTypeDefault];
                     [WSProgressHUD autoDismiss:2];
                     //修改成功后返回 退出登录
                     [self.navigationController popViewControllerAnimated:NO];
//                     [self performSelector:@selector(relogin) withObject:nil afterDelay:1];
                 }else{

                     [WSProgressHUD showShimmeringString:[json objectForKey:@"msg"] maskType:WSProgressHUDMaskTypeDefault];
                     [WSProgressHUD autoDismiss:1];
                 }

             }
                 failedBlock:^(NSError *error) {
                     [WSProgressHUD showShimmeringString:@"修改失败" maskType:WSProgressHUDMaskTypeDefault];
                     [WSProgressHUD autoDismiss:1];

                     //显示暂无数据图
                 }];

}

- (void)relogin
{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCookie];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTIFACTION object:nil];
}

- (NSString *)sha1:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}


- (void)popMainViewContoller
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapbackimgView:(UITapGestureRecognizer *)tap
{
    if ([userAccount isFirstResponder]) {
        [userAccount resignFirstResponder];
    }
    
    if ([originalPassword isFirstResponder]) {
        [originalPassword resignFirstResponder];
    }
    
    if ([password isFirstResponder]) {
        [password resignFirstResponder];
    }
    
    if ([againPassword isFirstResponder]) {
        [againPassword resignFirstResponder];
    }
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

@end
