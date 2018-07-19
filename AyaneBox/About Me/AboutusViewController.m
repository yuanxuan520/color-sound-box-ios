//
//  AboutusViewController.m
//  ParkProject
//
//  Created by yuanxuan on 16/9/6.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "AboutusViewController.h"

@interface AboutusViewController ()
@property (nonatomic, strong) UIView *mainview;
@end

@implementation AboutusViewController
@synthesize mainview;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = UIColorHex(0xf8f8f8);
    
    self.mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APPMainViewWidth, APPMainViewHeight)];
    [self.view addSubview:mainview];
    
    UIImageView *backimgview = [[UIImageView alloc] initWithFrame:CGRectMake(APPMainViewWidth/2-50, 60,100, 100)];
    backimgview.contentMode = UIViewContentModeScaleAspectFill;
    backimgview.image = [UIImage imageNamed:@"ic_launcher"];
    backimgview.layer.cornerRadius = 25;
    backimgview.clipsToBounds = YES;
    [self.mainview addSubview:backimgview];
    
    UIButton *visionbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [visionbtn setFrame:CGRectMake(APPMainViewWidth/2 - 50, 170, 100, 20)];
    [visionbtn setTitleColor:UIColorHex(0x484848) forState:UIControlStateNormal];
    visionbtn.titleLabel.font = SystemFont(14);
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [visionbtn setTitle:[NSString stringWithFormat:@"version %@",appVersion] forState:UIControlStateNormal];
    [self.mainview addSubview:visionbtn];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, APPMainViewWidth, 200)];
    backView.backgroundColor = UIColorHex(0xffffff);
    [self.mainview addSubview:backView];
    
    UILabel *infolabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, APPMainViewWidth, 50)];
    infolabel.text = @"公司信息:";
    infolabel.textColor = UIColorHex(0x333333);
    infolabel.font = SystemFont(14);
    [backView addSubview:infolabel];
    
    UILabel *infoDetaillabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth-10, 50)];
    infoDetaillabel.text = @"北京市XXX智能设备有限公司";
    infoDetaillabel.textAlignment = NSTextAlignmentRight;
    infoDetaillabel.textColor = UIColorHex(0x999999);
    infoDetaillabel.font = SystemFont(14);
    [backView addSubview:infoDetaillabel];
    
    UILabel *addressinfolabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, APPMainViewWidth, 50)];
    addressinfolabel.text = @"公司地址:";
    addressinfolabel.textColor = UIColorHex(0x333333);
    addressinfolabel.font = SystemFont(14);
    [backView addSubview:addressinfolabel];
    
    UILabel *addressinfoDetaillabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, APPMainViewWidth-10, 50)];
    addressinfoDetaillabel.text = @"北京市XX软件园XX栋1号";
    addressinfoDetaillabel.textAlignment = NSTextAlignmentRight;
    addressinfoDetaillabel.textColor = UIColorHex(0x999999);
    addressinfoDetaillabel.font = SystemFont(14);
    [backView addSubview:addressinfoDetaillabel];
    
    
    UILabel *supportlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, APPMainViewWidth, 50)];
    supportlabel.text = @"技术支持:";
    supportlabel.textColor = UIColorHex(0x333333);
    supportlabel.font = SystemFont(14);
    [backView addSubview:supportlabel];
    
    UILabel *supportDetaillabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, APPMainViewWidth-10, 50)];
    supportDetaillabel.text = @"北京市XX软件公司";
    supportDetaillabel.textAlignment = NSTextAlignmentRight;
    supportDetaillabel.textColor = UIColorHex(0x999999);
    supportDetaillabel.font = SystemFont(14);
    [backView addSubview:supportDetaillabel];
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, APPMainViewWidth, 50)];
    phonelabel.text = @"联系电话:";
    phonelabel.textColor = UIColorHex(0x333333);
    phonelabel.font = SystemFont(14);
    [backView addSubview:phonelabel];
    
    UILabel *phoneDetaillabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, APPMainViewWidth-10, 50)];
    phoneDetaillabel.text = @"010-132323232";
    phoneDetaillabel.textAlignment = NSTextAlignmentRight;
    phoneDetaillabel.textColor = UIColorHex(0x999999);
    phoneDetaillabel.font = SystemFont(14);
    [backView addSubview:phoneDetaillabel];
    
    UIView *linelabel1 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, APPMainViewWidth, 0.5)];
    linelabel1.backgroundColor = UIColorHex(0xf8f8f8);
    UIView *linelabel2 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, APPMainViewWidth, 0.5)];
    linelabel2.backgroundColor = UIColorHex(0xf8f8f8);
    UIView *linelabel3 = [[UIView alloc] initWithFrame:CGRectMake(0, 150, APPMainViewWidth, 0.5)];
    linelabel3.backgroundColor = UIColorHex(0xf8f8f8);
    [backView addSubview:linelabel1];
    [backView addSubview:linelabel2];
    [backView addSubview:linelabel3];
    
    
//    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, APPMainViewHeight - 100, APPMainViewWidth, 20)];
//    moreButton.backgroundColor = [UIColor clearColor];
//    moreButton.titleLabel.font = SystemFont(12);
//    [moreButton setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
//    [moreButton setTitle:@"Wuhan Topflames Information Tech Inc." forState:UIControlStateNormal];
////    [moreButton addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.mainview addSubview:moreButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
