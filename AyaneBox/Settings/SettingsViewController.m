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
@end

@implementation SettingsViewController
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                cell.accessoryView = [[UISwitch alloc] init];
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"输入信道2";
                cell.accessoryView = [[UISwitch alloc] init];
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"输入信道3";
                cell.accessoryView = [[UISwitch alloc] init];
            }
                break;
            default:
                break;
        }
        return cell;
    }else if(indexPath.section == 1) {
        static NSString *identify = @"tableTableView1";
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
            }
                break;
                case 1:
            {
                cell.contentLabel.text = @"输出信道1";
            }
                break;
                case 2:
            {
                cell.contentLabel.text = @"输出信道3";
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 60;
            
        }
            break;
        case 1:
        {
            return 100;
            
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
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, 60)];
    headerView.backgroundColor = UIColorHex(0xebebeb);
    
    //选择后
    switch (section) {
            case 0:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, APPMainViewWidth-10, 60)];
            label.font = [UIFont systemFontOfSize:17];
            label.text = @"输入设置";
            label.textColor = UIColorHex(0x656565);
            [headerView addSubview:label];
        }
            break;
            case 1:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, APPMainViewWidth-10, 60)];
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
