//
//  SettingsViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingOutTableViewCell.h"


@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UISwitch *chanelIn01Switch;
@property (nonatomic, strong) UISwitch *chanelIn02Switch;
@property (nonatomic, strong) UISwitch *chanelIn03Switch;

@property (nonatomic, strong) UISwitch *chanelOut01Switch;
@property (nonatomic, strong) UISwitch *chanelOut02Switch;
@property (nonatomic, strong) UISwitch *chanelOut03Switch;

@end

@implementation SettingsViewController
@synthesize chanelIn01Switch,chanelIn02Switch,chanelIn03Switch;
@synthesize chanelOut01Switch,chanelOut02Switch,chanelOut03Switch;

@synthesize settingTableView;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = UIColorHex(0xebebeb);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = UIColorHex(0x303f4a);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    self.chanelIn01Switch = [[UISwitch alloc] init];
    self.chanelIn01Switch.tag = 1;
    [self.chanelIn01Switch addTarget:self action:@selector(chanelInSwitch:) forControlEvents:UIControlEventValueChanged];
    self.chanelIn02Switch = [[UISwitch alloc] init];
    self.chanelIn02Switch.tag = 2;
    [self.chanelIn02Switch addTarget:self action:@selector(chanelInSwitch:) forControlEvents:UIControlEventValueChanged];
    self.chanelIn03Switch = [[UISwitch alloc] init];
    self.chanelIn03Switch.tag = 3;
    [self.chanelIn03Switch addTarget:self action:@selector(chanelInSwitch:) forControlEvents:UIControlEventValueChanged];

    self.chanelIn01Switch.on = [PCMDataSource sharedData].channelInput01;
    self.chanelIn02Switch.on = [PCMDataSource sharedData].channelInput02;
    self.chanelIn03Switch.on = [PCMDataSource sharedData].channelInput03;


    self.dataList = [NSMutableArray arrayWithCapacity:0];
    
    settingTableView.tableFooterView = [[UIView alloc] init];
    settingTableView.backgroundColor = [UIColor clearColor];
    settingTableView.separatorInset = UIEdgeInsetsZero;
    
    if ([settingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [settingTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([settingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [settingTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    settingTableView.separatorColor = UIColorHex(0xf0f0f0);
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[PCMDataSource sharedData] saveChannelInputOutput];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chanelInSwitch:(UISwitch *)channel
{
    switch (channel.tag) {
        case 1:
            {
                [PCMDataSource sharedData].channelInput01 = channel.on;
            }
            break;
        case 2:
            {
                [PCMDataSource sharedData].channelInput02 = channel.on;

            }
            break;
        case 3:
            {
                [PCMDataSource sharedData].channelInput03 = channel.on;
            }
            break;
            
        default:
            break;
    }
}

- (void)chanelOutSwitch:(UISwitch *)channel
{
    switch (channel.tag) {
        case 1:
        {
            [PCMDataSource sharedData].channelOutput01 = channel.on;
        }
            break;
        case 2:
        {
            [PCMDataSource sharedData].channelOutput02 = channel.on;
            
        }
            break;
        case 3:
        {
            [PCMDataSource sharedData].channelOutput03 = channel.on;
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - TableViewDelegate & TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; //默认为4个选项
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.5f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        static NSString *identify = @"tableTableView1";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorHex(0xf0f0f0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"输入信道1";
                cell.accessoryView = chanelIn01Switch;
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"输入信道2";
                cell.accessoryView = chanelIn02Switch;
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"输入信道3";
                cell.accessoryView = chanelIn03Switch;
            }
                break;
            default:
                break;
        }
        return cell;
    }else if(indexPath.section == 1) {
        static NSString *identify = @"tableTableView";
        SettingOutTableViewCell *cell = (SettingOutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell =
            [[NSBundle mainBundle] loadNibNamed:@"SettingOutTableViewCell" owner:nil options:nil].firstObject;;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        switch (indexPath.row) {
                case 0:
            {
                cell.contentLabel.text = @"输出信道1";
                
                if ([PCMDataSource sharedData].channelOutput01 > 0) {
                    [cell.onSwitch setOn:YES animated:YES];
                }else {
                    cell.onSwitch.on = NO;
                }
                
                
                
                cell.onSwitch.tag = 11;
                cell.onOpenBtn.tag = 21;
                [self setOpenBtnTitle:cell.onOpenBtn];
                [cell.onOpenBtn addTarget:self action:@selector(onOpenInPut:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                case 1:
            {
                cell.contentLabel.text = @"输出信道2";
                if ([PCMDataSource sharedData].channelOutput02 > 0) {
                    [cell.onSwitch setOn:YES animated:YES];
                }else {
                    cell.onSwitch.on = NO;
                }
                cell.onSwitch.tag = 12;
                cell.onOpenBtn.tag = 22;
                [self setOpenBtnTitle:cell.onOpenBtn];
                [cell.onOpenBtn addTarget:self action:@selector(onOpenInPut:) forControlEvents:UIControlEventTouchUpInside];

            }
                break;
                case 2:
            {
                cell.contentLabel.text = @"输出信道3";
                if ([PCMDataSource sharedData].channelOutput03 > 0) {
                    [cell.onSwitch setOn:YES animated:YES];
                }else {
                    cell.onSwitch.on = NO;
                }
                cell.onSwitch.tag = 13;
                cell.onOpenBtn.tag = 23;
                [self setOpenBtnTitle:cell.onOpenBtn];
                [cell.onOpenBtn addTarget:self action:@selector(onOpenInPut:) forControlEvents:UIControlEventTouchUpInside];

            }
                break;
            default:
                break;
        }
        return cell;
    }else {
        static NSString *identify = @"tableTableView3";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorHex(0xf0f0f0);
        }
        return cell;
    }
    
}

- (void)setOpenBtnTitle:(UIButton *)btn
{
    int output = 0;
    switch (btn.tag) {
        case 21:
        {
            output = [PCMDataSource sharedData].channelOutput01;
        }
            break;
        case 22:
        {
            output = [PCMDataSource sharedData].channelOutput02;

        }
            break;
        case 23:
        {
            output = [PCMDataSource sharedData].channelOutput03;
        }
            break;
        default:
            break;
    }
    switch (output) {
        case 0:
        {
            [btn setTitle:@"关闭" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [btn setTitle:@"输入信道1" forState:UIControlStateNormal];

        }
            break;
        case 2:
        {
            [btn setTitle:@"输入信道2" forState:UIControlStateNormal];

        }
            break;
        case 3:
        {
            [btn setTitle:@"输入信道3" forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
}

- (void)onOpenInPut:(UIButton *)btn
{
    NSString *msg = @"";
    switch (btn.tag) {
        case 21:
        {
            msg = @"输出信道1匹配";
        }
            break;
        case 22:
        {
            msg = @"输出信道2匹配";
        }
            break;
        case 23:
        {
            msg = @"输出信道3匹配";
        }
            break;
            
        default:
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (btn.tag) {
            case 21:
            {
                [PCMDataSource sharedData].channelOutput01 = 0;
                UISwitch *onSwitch = [[btn superview] viewWithTag:11];
                [onSwitch setOn:NO animated:YES];
            }
                break;
            case 22:
            {
                [PCMDataSource sharedData].channelOutput02 = 0;
                UISwitch *onSwitch = [[btn superview] viewWithTag:12];
                [onSwitch setOn:NO animated:YES];
            }
                break;
            case 23:
            {
                [PCMDataSource sharedData].channelOutput03 = 0;
                UISwitch *onSwitch = [[btn superview] viewWithTag:13];
                [onSwitch setOn:NO animated:YES];
                
            }
                break;
                
            default:
                break;
        }
        
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
    }];
    
    [alert addAction:cancelAction];
    
    UIAlertAction *in01 = [UIAlertAction actionWithTitle:@"输入信道1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (btn.tag) {
            case 21:
            {
                [PCMDataSource sharedData].channelOutput01 = 1;
                UISwitch *onSwitch = [[btn superview] viewWithTag:11];
                [onSwitch setOn:YES animated:YES];
            }
                break;
            case 22:
            {
                [PCMDataSource sharedData].channelOutput02 = 1;
                UISwitch *onSwitch = [[btn superview] viewWithTag:12];
                [onSwitch setOn:YES animated:YES];
            }
                break;
            case 23:
            {
                [PCMDataSource sharedData].channelOutput03 = 1;
                UISwitch *onSwitch = [[btn superview] viewWithTag:13];
                [onSwitch setOn:YES animated:YES];
            }
                break;
                
            default:
                break;
        }
        [btn setTitle:@"输入信道1" forState:UIControlStateNormal];
    }];
    [alert addAction:in01];
    
    UIAlertAction *in02 = [UIAlertAction actionWithTitle:@"输入信道2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (btn.tag) {
            case 21:
            {
                [PCMDataSource sharedData].channelOutput01 = 2;
                UISwitch *onSwitch = [[btn superview] viewWithTag:11];
                [onSwitch setOn:YES animated:YES];
            }
                break;
            case 22:
            {
                [PCMDataSource sharedData].channelOutput02 = 2;
                UISwitch *onSwitch = [[btn superview] viewWithTag:12];
                [onSwitch setOn:YES animated:YES];
            }
                break;
            case 23:
            {
                [PCMDataSource sharedData].channelOutput03 = 2;
                UISwitch *onSwitch = [[btn superview] viewWithTag:13];
                [onSwitch setOn:YES animated:YES];
            }
                break;
                
            default:
                break;
        }
        [btn setTitle:@"输入信道2" forState:UIControlStateNormal];
    }];
    [alert addAction:in02];
    
    UIAlertAction *in03 = [UIAlertAction actionWithTitle:@"输入信道3" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (btn.tag) {
            case 21:
            {
                [PCMDataSource sharedData].channelOutput01 = 3;
                UISwitch *onSwitch = [[btn superview] viewWithTag:11];
                [onSwitch setOn:YES animated:YES];
            }
                break;
            case 22:
            {
                [PCMDataSource sharedData].channelOutput02 = 3;
                UISwitch *onSwitch = [[btn superview] viewWithTag:12];
                [onSwitch setOn:YES animated:YES];
            }
                break;
            case 23:
            {
                [PCMDataSource sharedData].channelOutput03 = 3;
                UISwitch *onSwitch = [[btn superview] viewWithTag:13];
                [onSwitch setOn:YES animated:YES];
            }
                break;
            default:
                break;
        }
        [btn setTitle:@"输入信道3" forState:UIControlStateNormal];
    }];
    [alert addAction:in03];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 60;
            
        }
            break;
        case 1:
        {
            return 80;
            
        }
            break;
            
        default:
            break;
    }
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// 每个数据的头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, 40)];
    headerView.backgroundColor = UIColorHex(0xebebeb);
    
    //选择后
    switch (section) {
            case 0:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, APPMainViewWidth-10, 40)];
            label.font = [UIFont systemFontOfSize:17];
            label.text = @"输入设置";
            label.textColor = UIColorHex(0x656565);
            [headerView addSubview:label];
        }
            break;
            case 1:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, APPMainViewWidth-10, 40)];
            label.font = [UIFont systemFontOfSize:17];
            label.text = @"输出设置";
            label.textColor = UIColorHex(0x656565);
            [headerView addSubview:label];
        }
            break;
        default:
            break;
    }
    return headerView;
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
