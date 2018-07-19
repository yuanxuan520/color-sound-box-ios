//
//  SettingTableViewCell.m
//  ParkProject
//
//  Created by yuanxuan on 16/8/1.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

@synthesize allcontentView,iConView,settingTitleLabel;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iConView = [[UIImageView alloc] init];
        self.allcontentView = [[UIView alloc] init];
        self.settingTitleLabel = [[UILabel alloc] init];
        
        self.allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.allcontentView];
        
        // 头像
        [self.allcontentView addSubview:self.iConView];
        
        // 内容
        self.settingTitleLabel.textColor = UIColorHex(0x0a0a0a);
        //    CGSize wdtitleSize = [fileTitleLabel.text boundingRectWithSize:CGSizeMake(mainViewWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
        self.settingTitleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
        self.settingTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.allcontentView addSubview:self.settingTitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.iConView.frame = CGRectMake(25, 15, 20, 20);
    self.settingTitleLabel.frame = CGRectMake(70, 0, self.frame.size.width-50, 50);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
