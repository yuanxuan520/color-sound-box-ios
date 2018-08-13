//
//  FileTableViewCell.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/8/4.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "FileTableViewCell.h"

@implementation FileTableViewCell
@synthesize fileNameLabel,fileSizeLabel,createTimeLabel;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        allcontentView = [[UIView alloc] init];
        fileNameLabel = [[UILabel alloc] init];
        createTimeLabel = [[UILabel alloc] init];
        fileSizeLabel = [[UILabel alloc] init];
       
        fileNameLabel.textColor = UIColorHex(0x0a0a0a);
        fileNameLabel.font = SystemFont(16);
        fileNameLabel.numberOfLines = 1;//多行显示，计算高度
        [self.contentView addSubview:fileNameLabel];
        
        fileSizeLabel.textColor = UIColorHex(0xadadad);
        fileSizeLabel.font = SystemFont(12);
        fileSizeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:fileSizeLabel];
        
        createTimeLabel.textColor = UIColorHex(0xadadad);
        createTimeLabel.font = SystemFont(12);
        createTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:createTimeLabel];

        

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    fileNameLabel.frame = CGRectMake(20, 5, APPMainViewWidth-100, 30);
    fileSizeLabel.frame = CGRectMake(20, 35, 100, 20);
    createTimeLabel.frame = CGRectMake(160, 35, 120, 20);
}
@end
