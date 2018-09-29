//
//  LoginViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "LoginViewController.h"
#import "PPFileOperate.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIView *tapbackView;
@property (nonatomic, strong) UITextField *phoneNumberField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation LoginViewController
@synthesize mainView,tapbackView,phoneNumberField,passwordField;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = UIColorHex(0x373447);
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight)];
    mainView.contentSize = CGSizeMake(APPMainViewWidth, APPMainViewHeight+APPMainViewHeight);
    mainView.backgroundColor = UIColorHex(0x303f4b);
    mainView.scrollEnabled = NO;
    [self.view addSubview:mainView];
    
    tapbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight)];
    tapbackView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbackimgView:)];
    tap1.numberOfTapsRequired = 1;
    [tapbackView addGestureRecognizer:tap1];
    
    [mainView addSubview:tapbackView];
    
    UIImageView *iconimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    iconimgView.contentMode = UIViewContentModeScaleAspectFit;
    iconimgView.center = CGPointMake(APPMainViewWidth/2, APPMainViewHeight/3/1.6);
    iconimgView.image = [UIImage imageNamed:@"ic_logo"];
    [mainView addSubview:iconimgView];

    //输入手机号
    phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth-100, 40)];
    phoneNumberField.center = CGPointMake(APPMainViewWidth/2, APPMainViewHeight/3*1.4-25);
    phoneNumberField.backgroundColor = [UIColor whiteColor];
    phoneNumberField.placeholder = @"账号";
    phoneNumberField.keyboardType = UIKeyboardTypeASCIICapable;
    phoneNumberField.delegate = self;
    phoneNumberField.tag = 102;
    
    phoneNumberField.returnKeyType = UIReturnKeyNext;
    phoneNumberField.textColor = UIColorHex(0x000000);
    [phoneNumberField setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [phoneNumberField setValue:UIColorHex(0xEEEEEE) forKeyPath:@"_placeholderLabel.textColor"];
    [phoneNumberField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumberField.font = [UIFont systemFontOfSize:16];
    phoneNumberField.layer.cornerRadius = 20;
    
    [mainView addSubview:phoneNumberField];
    
//    UIButton *phone_clear_button = [phoneNumberField valueForKey:@"_clearButton"];
//    [phone_clear_button setImage:[UIImage imageNamed:@"clear_btn"] forState:UIControlStateNormal];
//    [phone_clear_button setImage:[UIImage imageNamed:@"clear_btn_press"] forState:UIControlStateHighlighted];
//
    UIButton *user_accountView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    user_accountView.userInteractionEnabled = NO;
    user_accountView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [user_accountView setImage:[UIImage imageNamed:@"user_account"] forState:UIControlStateNormal];
    [user_accountView setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
    phoneNumberField.leftView = user_accountView;
    phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
    //    phoneNumberField.text = @"";
    
    //输入密码框
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth-100, 40)];
    passwordField.center = CGPointMake(APPMainViewWidth/2, APPMainViewHeight/3*1.4+35);
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.textColor = UIColorHex(0x000000);
    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"密码";
    passwordField.tag = 123456;
    passwordField.delegate = self;
    passwordField.layer.cornerRadius = 20;
    [passwordField.layer setMasksToBounds:YES];
//    [passwordField setValue:UIColorHex(0xEEEEEE) forKeyPath:@"_placeholderLabel.textColor"];
    passwordField.returnKeyType = UIReturnKeyGo;
    passwordField.font = [UIFont systemFontOfSize:16];
    //    passwordField.text = @"";// 123456
    
    UIButton *user_passwordView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    user_passwordView.userInteractionEnabled = NO;
    user_passwordView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [user_passwordView setImage:[UIImage imageNamed:@"user_password"] forState:UIControlStateNormal];
    [user_passwordView setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
    passwordField.leftView = user_passwordView;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    [mainView addSubview:passwordField];
    
    //忘记密码 button
//    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [registerBtn setFrame:CGRectMake(APPMainViewWidth-100, 180, 100, 30)];
//    [registerBtn.titleLabel setFont:SystemFont(15)];
//    [registerBtn setTitle:@"用户注册" forState:UIControlStateNormal];
//    registerBtn.center = CGPointMake(APPMainViewWidth-85, APPMainViewHeight/3*2.6);
//    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    registerBtn.layer.borderWidth = 1;
//    registerBtn.layer.cornerRadius = 4;
//    registerBtn.hidden = YES;
//    [registerBtn addTarget:self action:@selector(enterRegisterAccound) forControlEvents:UIControlEventTouchUpInside];
//    [mainView addSubview:registerBtn];
    
    //忘记密码 button
    //    UIButton *forgetPassword = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [forgetPassword setFrame:CGRectMake(APPMainViewWidth-100, 180, 100, 40)];
    //    [forgetPassword.titleLabel setFont:SystemFont(15)];
    //    [forgetPassword setTitle:@"忘记密码?" forState:UIControlStateNormal];
    //    forgetPassword.center = CGPointMake(APPMainViewWidth-60, APPMainViewHeight/3*1.85);
    //    [forgetPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ////    [forgetPassword addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    //    [mainView addSubview:forgetPassword];
    
    //登录 button
    UIButton *login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    login.titleLabel.font = [UIFont systemFontOfSize:18];
    login.frame = CGRectMake(35, 220, APPMainViewWidth-100, 40);
    login.center = CGPointMake(APPMainViewWidth/2, APPMainViewHeight/3*1.8);
    
    [login.layer setMasksToBounds:YES];
    [login.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
    login.backgroundColor = UIColorHex(0x33cbcc);
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    //    @selector(login)
    [mainView addSubview:login];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, APPMainViewHeight-50, APPMainViewWidth, 30)];
    version.textColor = UIColorHex(0Xfefefe);
    version.textAlignment = NSTextAlignmentCenter;
    version.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    version.text = [NSString stringWithFormat:@"version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mainView addSubview:version];
    // Do any additional setup after loading the view.
    
//    PPFileOperate *ppfileop = [[PPFileOperate alloc] init];
//    //默认创建 一个用户信息文件夹 跟一个用户下载数据文件夹
//    [ppfileop createDirName:USERDATA];
//    [ppfileop createDirName:KLCDATA];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BOOL isLogin = [USERDEFAULTS objectForKey:@"isLogin"];
    if (isLogin) {
        UIStoryboard * sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabbarVc = [sboard instantiateViewControllerWithIdentifier:@"home"];
        AppDelegate* appDelagete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController = tabbarVc;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tapbackimgView:(UITapGestureRecognizer *)tap
{
    [phoneNumberField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [mainView setContentOffset:CGPointMake(0, 0) animated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 102) {
        [textField resignFirstResponder];
        [passwordField becomeFirstResponder];
    }else if(textField.tag == 123456){
        [self login:nil];
    }
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    NSInteger movementDistance = textField.frame.origin.y-textField.frame.origin.y*0.5; // tweak as needed
    //    const float movementDuration = 0.3f; // tweak as needed
    
    
    
    //    NSInteger movement = (up ? -movementDistance : movementDistance);
    
    
    //    [UIView beginAnimations: @"anim" context: nil];
    //
    //    [UIView setAnimationBeginsFromCurrentState: YES];
    //
    //    [UIView setAnimationDuration: movementDuration];
    if (up) {
        [mainView setContentOffset:CGPointMake(0, movementDistance) animated:YES];
    }else{
        [mainView setContentOffset:CGPointMake(0, 0) animated:YES];
        //        [mainView setContentSize:CGSizeMake(APPMainViewWidth, APPMainViewHeight)];
    }
    //    createView.frame = CGRectOffset(createView.frame, 0, movement);
    
    //    [UIView commitAnimations];
    
}

- (void)login:(UIButton *)btn
{
    [phoneNumberField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    
    //show
    [WSProgressHUD showWithStatus:@"正在登录.." maskType:WSProgressHUDMaskTypeBlack];
    
    RequestPostData *request = [[RequestPostData alloc] init];///wap/token //login/mobileVerify
    [request loginAFRequest:Login userName:phoneNumberField.text password:passwordField.text timeOutSeconds:30 completionBlock:^(NSDictionary *json) {
        NSLog(@"%@",json);
        
        if (![[json objectForKey:@"result"] integerValue]) {
            //            保存信息
            NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:json];
            NSString *userId = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"userId"]];
            //            NSString *account = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"account"]];
            NSString *userName = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"userName"]];
            NSString *userType = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"userType"]];
            //            NSString *avatar = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"avatar"]];
            //            NSString *userAccount = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"userAccount"]];
            //            NSString *mobile = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"mobile"]];
            //            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            //            pasteboard.string = token;
            
            //            [USERDEFAULTS setObject:token forKey:@"cooki"];
            
            UIStoryboard * sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabbarVc = [sboard instantiateViewControllerWithIdentifier:@"home"];
            AppDelegate* appDelagete = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelagete.window.rootViewController = tabbarVc;
            
            //初始化登录信息类ECLoginInfo实例（ECLoginInfo已经包含在SDK包里，不要用户创建）
            //默认模式：对AppKey、AppToken和userName鉴权
            
            
            NSLog(@"登录成功");
//          初始化音频所需要的数据
            [PCMDataSource sharedData];
            //保存数据
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUCCESSNOTIFACTION object:nil];  //登录成功
            //            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            //            NSData *data = nil;
            //            NSURL *url = [NSURL URLWithString:[PPAPPDataClass sharedappData].severUrl];
            //            for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            //                if ([cookie.domain isEqualToString:[url host]]) {
            //                    data = [NSKeyedArchiver archivedDataWithRootObject:cookie];
            //                }
            //            }
            //
            //            [USERDEFAULTS setObject:data forKey:kUserDefaultsCookie];
            //                    [USERDEFAULTS synchronize];
            
            [USERDEFAULTS setObject:self.phoneNumberField.text forKey:@"phoneNumber"];
            [USERDEFAULTS setObject:self.phoneNumberField.text forKey:@"account"];
            [USERDEFAULTS setObject:self.passwordField.text forKey:@"password"];
            
            [USERDEFAULTS setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
            [USERDEFAULTS setObject:userId forKey:@"userId"];
            [USERDEFAULTS setObject:userType forKey:@"userNickname"];
            [USERDEFAULTS setObject:userName forKey:@"userName"];
            //            [USERDEFAULTS setObject:avatar forKey:@"avatar"];
            //            [USERDEFAULTS setObject:userAccount forKey:@"userAccount"];
            //            [USERDEFAULTS setObject:mobile forKey:@"userAccount"];
            [USERDEFAULTS synchronize];
//            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEMYINFO object:nil];//更新我的图片
            
            //登录后创建数据库
//            [DBoperate createDB];
            
            //创建文件夹
//            PPFileOperate *ppfileop = [[PPFileOperate alloc] init];
//            NSString *dirName = [NSString stringWithFormat:@"%@",@"wavFile"];
//            [ppfileop createDownloadDirName:dirName];
        
            
            
        }else{
            [WSProgressHUD showShimmeringString:[json objectForKey:@"msg"] maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
            [WSProgressHUD autoDismiss:1.5];
        }
        
    } failedBlock:^(NSError *error) {
        NSLog(@"失败");
        [WSProgressHUD showShimmeringString:@"网络不通畅，请检查网络后重试." maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
        [WSProgressHUD autoDismiss:1.5];
        //弹出提示框   是否是重新登录还是咋地
    }];
    
    
    
    
}
@end
