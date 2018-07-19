//
//  SettingOutTableViewCell.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/4.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingOutTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UISwitch *onSwitch;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIButton *onOpenBtn;
@property (nonatomic, strong) IBOutlet UIButton *arithmeticBtn;

@end
