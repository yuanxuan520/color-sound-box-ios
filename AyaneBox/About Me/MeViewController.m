//
//  MeViewController.m
//  GNIM
//
//  Created by 给力 on 14-7-16.
//  Copyright (c) 2014年 给力. All rights reserved.
//

#import "MeViewController.h"
#import "SettingTableViewCell.h"
//#import "PersonInfoViewController.h"
//#import "UIButton+WebCache.h"
#import "UpdatePasswordViewController.h"
#import "AboutusViewController.h"
#import "LoginViewController.h"

#define HEADHEIGHT (APPMainViewWidth*0.5)
@interface MeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *navBarHairlineImageView;
}
@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) NSMutableArray *settingList;
@property (nonatomic, strong) NSMutableArray *settingList1;
@property (nonatomic, strong) NSMutableArray *settingList2;


@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIButton *iconImgView;
@property (nonatomic, strong) UILabel *iconImgLabel;
@property (nonatomic, strong) UIButton *editbtn;

@end

@implementation MeViewController

@synthesize settingTableView,settingList,iconImgLabel,iconImgView,headImgView,editbtn,headView;
@synthesize settingList1,settingList2;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = UIColorHex(0xebebeb);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = UIColorHex(0x303f4a);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.view.backgroundColor = UIColorHex(0xf8f8f8);

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xf8f8f8);
    //添加一个通知 来修改重新登录的人的资料图
    
    self.title = @"我的";
    
    self.settingList = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *collectDict = [NSDictionary dictionaryWithObjectsAndKeys:@"修改密码",@"title",[UIImage imageNamed:@"ic_change_password"],@"img", nil];
    [settingList addObject:collectDict];
    
    NSDictionary *clearCacheDict = [NSDictionary dictionaryWithObjectsAndKeys:@"清除缓存",@"title",[UIImage imageNamed:@"ic_clear_cache"],@"img", nil];
    [settingList addObject:clearCacheDict];
    
    self.settingList1 = [NSMutableArray arrayWithCapacity:0];

    NSDictionary *feedbackDict = [NSDictionary dictionaryWithObjectsAndKeys:@"工单管理",@"title",[UIImage imageNamed:@"ic_list_manage"],@"img", nil];
    [settingList1 addObject:feedbackDict];
    
    NSDictionary *aboutusDict = [NSDictionary dictionaryWithObjectsAndKeys:@"关于我们",@"title",[UIImage imageNamed:@"ic_about_us"],@"img", nil];
    [settingList1 addObject:aboutusDict];
    
    
    self.settingList2 = [NSMutableArray arrayWithCapacity:0];

    NSDictionary *logOutDict = [NSDictionary dictionaryWithObjectsAndKeys:@"退出登录",@"title",[UIImage imageNamed:@"ic_quiet"],@"img", nil];
    [settingList2 addObject:logOutDict];
    
    
    //    NSDictionary *contactCustomerServiceDict = [NSDictionary dictionaryWithObjectsAndKeys:@"联系客服",@"title",[UIImage imageNamed:@"setting_lxkf"],@"img", nil];
    //    [settingList addObject:contactCustomerServiceDict];
    // Do any additional setup after loading the view.
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    [self createSettingView];
    
        [self updateIMGinfo];
}

- (void)updateIMGinfo
{
    self.iconImgLabel.text = [USERDEFAULTS objectForKey:@"userName"];;
    [self.iconImgView setImage:[UIImage imageNamed:@"ic_logo"] forState:UIControlStateNormal];
    self.headImgView.image = [UIImage imageNamed:@"bg_login"];
}


- (void)createSettingView
{
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight) style:UITableViewStylePlain];
    [self.view addSubview:settingTableView];
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    settingTableView.backgroundColor = [UIColor clearColor];
    settingTableView.separatorInset = UIEdgeInsetsZero;
    if ([settingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [settingTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([settingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [settingTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    settingTableView.separatorColor = UIColorHex(0xf0f0f0);
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, HEADHEIGHT)];
    self.headImgView = [[UIImageView alloc] initWithFrame:headView.bounds];
    self.headImgView.image = [UIImage imageNamed:@"pp_userpicture"];
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImgView.userInteractionEnabled = YES;
    self.headImgView.clipsToBounds = YES;
    [self.headView addSubview:headImgView];
    
    self.iconImgView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconImgView.frame = CGRectMake(0, 0, 70, 70);
    self.iconImgView.clipsToBounds = YES;
    self.iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    //    self.iconImgView.layer.shadowColor = [UIColor whiteColor].CGColor;
    //    self.iconImgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    //    self.iconImgView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    //    self.iconImgView.layer.shadowRadius = 10;//阴影半径，默认3
    self.iconImgView.layer.cornerRadius = 35;
    self.iconImgView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    self.iconImgView.layer.borderWidth = 2;
    [self.headImgView addSubview:iconImgView];
    
    
    self.iconImgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    self.iconImgLabel.textColor = [UIColor whiteColor];
    self.iconImgLabel.textAlignment = NSTextAlignmentCenter;
    self.iconImgLabel.clipsToBounds = YES;
    self.iconImgLabel.font = [UIFont systemFontOfSize:14];
    //    self.iconImgLabel.layer.cornerRadius = 35;
    //
    [self.headImgView addSubview:self.iconImgLabel];
    
    
    // 与图像高度一样防止数据被遮挡
    self.settingTableView.tableHeaderView = headView;
    editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [editbtn setFrame:CGRectMake(0, 0, 120, 40)];
    editbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    editbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [editbtn setImage:[UIImage imageNamed:@"pp_edit_user"] forState:UIControlStateNormal];
    editbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    editbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [editbtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [editbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editbtn setTitleColor:[UIColor colorWithWhite:0.300 alpha:1.000] forState:UIControlStateHighlighted];
    [editbtn addTarget:self action:@selector(editUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    editbtn.hidden = YES;
    [self.headImgView addSubview:editbtn];
    
//    UIView *logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, 100)];
//
//    UIButton *logoutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [logoutbtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    logoutbtn.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
//    [logoutbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [logoutbtn setFrame:CGRectMake(20, 10, APPMainViewWidth-40, 44)];
////    [logoutbtn setBackgroundImage:[PPToolsClass imageWithColor:UIColorHex(0xee5768) size:logoutbtn.bounds.size] forState:UIControlStateNormal];
////    [logoutbtn setBackgroundImage:[PPToolsClass imageWithColor:UIColorHex(0x83323b) size:logoutbtn.bounds.size] forState:UIControlStateHighlighted];
//
//    //    logoutbtn.layer.borderColor = UIColorHex(0xee5768).CGColor;
//    logoutbtn.layer.cornerRadius = 4;
//    //    logoutbtn.layer.borderWidth = 1;
//    logoutbtn.clipsToBounds = YES;
//    [logoutbtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
//    [logoutView addSubview:logoutbtn];
//    settingTableView.tableFooterView = logoutView;
    
}

- (void)editUserInfo:(UIButton *)btn
{
//    PersonInfoViewController *personInfoViewController = [[PersonInfoViewController alloc] init];
//    personInfoViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:personInfoViewController animated:YES];
}

- (void)logout:(UIButton *)btn
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确认要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [USERDEFAULTS removeObjectForKey:@"isLogin"];
        [USERDEFAULTS removeObjectForKey:kUserDefaultsCookie];
        [self clearCookies];
        [USERDEFAULTS synchronize];
        UIStoryboard * sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewControl = [sboard instantiateViewControllerWithIdentifier:@"login"];
        AppDelegate* appDelagete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController = loginViewControl;
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clearCookies{
    
    //获取所有cookies
    
    NSArray *array = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:SEVERURL]];
    // NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
    for(NSHTTPCookie *cookie in array)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        CGFloat totalOffset = HEADHEIGHT - offsetY;
        // 图片放大比例
        CGFloat scale = totalOffset / HEADHEIGHT;
        CGFloat width = APPMainViewWidth;
        // 拉伸后图片位置
        self.headImgView.frame = CGRectMake(-(width * scale - width) / 2, offsetY, width * scale, totalOffset);
        //        NSLog(@"w:%f h:%f",totalOffset,totalOffset);
        //        self.headImgView.frame = CGRectMake(offsetY/2, offsetY, APPMainViewWidth - offsetY, HEADHEIGHT - offsetY);  // 修改头部的frame值就行了
        self.iconImgView.center = CGPointMake(self.headImgView.bounds.size.width/2, self.headImgView.bounds.size.height/2);
        self.iconImgLabel.center = CGPointMake(self.headImgView.bounds.size.width/2, self.headImgView.bounds.size.height/2+55);
        self.editbtn.center = CGPointMake(self.headImgView.bounds.size.width/2, self.headImgView.bounds.size.height/2+80);
        
    }
    
    /* 往上滑动contentOffset值为正，大多数都是监听这个值来做一些事 */
}
// 每个分区的页眉
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [pylist objectAtIndex:section];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return [self.settingList count];
        }
            break;
        case 1:
        {
            return [self.settingList1 count];
        }
            break;
        case 2:
        {
            return [self.settingList2 count];
        }
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                    case 0:
                {
                    UpdatePasswordViewController *updatePasswordViewController = [[UpdatePasswordViewController alloc] init];
                    updatePasswordViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:updatePasswordViewController animated:YES];
                }
                    break;
                    case 1:
                {
                    [self clearTmpPics];
                }
                    break;

                default:
                    break;
            }

        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                    case 0:
                {

                }
                    break;
                    case 1:
                {
                    AboutusViewController *aboutusViewController = [[AboutusViewController alloc] init];
                    aboutusViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutusViewController animated:YES];
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case 2:
        {
            [self logout:nil];
        }
            break;
        default:
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, 20)];
    headerView.backgroundColor = UIColorHex(0xebebeb);
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
//    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.drugsListArray count];
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"settingTableView";
    SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorHex(0xf0f0f0);
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.section) {
            case 0:
        {
            NSString *title = [NSString stringWithFormat:@"%@",[[self.settingList objectAtIndex:indexPath.row] objectForKey:@"title"]];
            cell.settingTitleLabel.text = title;
            cell.iConView.image = [[self.settingList objectAtIndex:indexPath.row] objectForKey:@"img"];
        }
            break;
            case 1:
        {
            
            cell.settingTitleLabel.text = [NSString stringWithFormat:@"%@",[[self.settingList1 objectAtIndex:indexPath.row] objectForKey:@"title"]];
            cell.iConView.image = [[self.settingList1 objectAtIndex:indexPath.row] objectForKey:@"img"];
        }
            break;
            case 2:
        {
           
            cell.settingTitleLabel.text = [NSString stringWithFormat:@"%@",[[self.settingList2 objectAtIndex:indexPath.row] objectForKey:@"title"]];
            cell.iConView.image = [[self.settingList2 objectAtIndex:indexPath.row] objectForKey:@"img"];
        }
            break;
        default:
        {
            cell.settingTitleLabel.text = [[self.settingList objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.iConView.image = [[self.settingList objectAtIndex:indexPath.row] objectForKey:@"img"];
        }
            break;
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 清理缓存图片
- (void)clearTmpPics
{
    //    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName = [NSString stringWithFormat:@"清除缓存"]; //(%@),[self getDataSizeString:size]
//    [[SDImageCache sharedImageCache] clearMemory];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //    [[SDImageCache sharedImageCache] cleanDisk];
    //    [[SDImageCache sharedImageCache] clearDisk];
    
    //    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:clearCacheName delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    [settingTableView reloadData];
}

#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(NSUInteger) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%ldB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%ldK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%ldM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%ldMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%ld.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else    // >1G
    {
        string = [NSString stringWithFormat:@"%ldG", nSize/1073741824];
    }
    
    return string;
}


@end
