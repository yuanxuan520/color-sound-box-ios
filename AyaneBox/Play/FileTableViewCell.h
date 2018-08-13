//
//  FileTableViewCell.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/8/4.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel *fileNameLabel;     // 文件名
@property(nonatomic,strong) UILabel *fileSizeLabel;    // 文件大小
@property(nonatomic,strong) UILabel *createTimeLabel;   // 创建时间
@end
