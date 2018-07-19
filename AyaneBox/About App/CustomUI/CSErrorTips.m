//
//  CSErrorTips.m
//  SellHouseManager
//
//  Created by luoyan on 16/5/17.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "CSErrorTips.h"

@interface CSErrorTips()
{
    UIImageView *imageView;
    UILabel *labelTips;
    UILabel *labelSubTips;
    UILabel *labelLoading;
    UIButton *repeatActionButton;
    NSTimer *timer;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation CSErrorTips

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView
{
    self.backgroundColor = UIColorHex(0xf7f7f7);
    
    imageView = [UIImageView new];
    [self addSubview:imageView];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self addSubview:activityIndicatorView];
    
    labelTips = [UILabel new];
    labelTips.font = kFontSize(14);
    labelTips.textColor = kColor_Text_Black;
    labelTips.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelTips];
    
    labelLoading = [UILabel new];
    labelLoading.text = @"...";
    labelLoading.font = kFontSize(14);
    labelLoading.textColor = labelTips.textColor;
    [self addSubview:labelLoading];
    
    labelSubTips = [UILabel new];
    labelSubTips.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelSubTips];
    
    repeatActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repeatActionButton.layer.cornerRadius = 5;
//    repeatActionButton.layer.borderColor = kSplitLineColor.CGColor;
//    repeatActionButton.layer.borderWidth = 1;
    repeatActionButton.layer.masksToBounds = YES;
    [repeatActionButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0x00a0e9)] forState:UIControlStateNormal];
    [repeatActionButton setTitle:@"点击刷新" forState:UIControlStateNormal];
    [repeatActionButton setTitleColor:kColorWhite forState:UIControlStateNormal];
    repeatActionButton.titleLabel.font = kFontSize(13);
    [repeatActionButton addTarget:self action:@selector(repearLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:repeatActionButton];
    
//    CGFloat imageWidth = 100*kScreenMutiple6;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-50);
    }];
    
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-50);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
    }];
    
    [labelLoading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelTips.mas_right);
        make.centerY.mas_equalTo(labelTips.mas_centerY);
        make.height.mas_equalTo(labelTips.mas_height);
        make.width.mas_equalTo(40);
    }];
    
    [labelSubTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(25);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(labelTips.mas_bottom).mas_offset(5);
    }];
    
    [repeatActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(labelSubTips.hidden?labelSubTips.mas_bottom:labelTips.mas_bottom).mas_offset(15);
    }];
}

- (void)reloadTips:(NSString*)tips subTips:(NSString*)subTips withType:(ErrorTipsType)type
{
    [self reloadTips:tips subTips:subTips withType:type imageName:nil];
}

- (void)reloadTips:(NSString*)tips subTips:(NSString*)subTips withType:(ErrorTipsType)type imageName:(NSString*)imageName
{
    imageView.hidden = NO;
    labelTips.textColor = kColor_Text_Black;
    [self stopTimer];
    [activityIndicatorView stopAnimating];
    if (type == ErrorTipsType_BadNetWork || type == ErrorTipsType_ServerError) {
        labelTips.text = tips;
        labelSubTips.text = subTips;
        labelSubTips.hidden = !subTips;
        repeatActionButton.hidden = NO;
        if (type == ErrorTipsType_BadNetWork) {
            UIImage *image = [UIImage imageNamed:@"common_badnetwork"];
            [repeatActionButton setTitle:@"点击重试" forState:UIControlStateNormal];
            imageView.image = image;
        } else {
            imageView.image = [UIImage imageNamed:@"icon_servererror"];
            [repeatActionButton setTitle:@"点击刷新" forState:UIControlStateNormal];
        }
        
        
        [labelTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
        }];
        
        [labelSubTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labelTips.mas_bottom).mas_offset(0);
        }];
        
        [repeatActionButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labelSubTips.mas_bottom).mas_offset(15);
        }];
    } else if (type == ErrorTipsType_NoData) {
        labelSubTips.hidden = YES;
        repeatActionButton.hidden = YES;
        labelTips.text = tips;
        imageView.image = [UIImage imageNamed:@"icon_nodata"];
        
//        CGFloat imageWidth = 100*kScreenMutiple6;
        
//        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
//        }];
        
        [labelTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
        }];
    } else if (type == ErrorTipsType_Loading) {
        [activityIndicatorView startAnimating];
        labelSubTips.hidden = YES;
        repeatActionButton.hidden = YES;
        labelLoading.hidden = NO;
        labelTips.text = @"加载中";
        labelTips.textColor = kColor_Text_LightBlack;
        labelLoading.textColor = labelTips.textColor;
        imageView.hidden = YES;
        if (!timer) {
            timer = [NSTimer timerWithTimeInterval:0.4
                                            target:self
                                          selector:@selector(timerTick:)
                                          userInfo:nil
                                           repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
        [timer fire];
    }
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)hideTipsView
{
    self.hidden = YES;
    [self stopTimer];
}

- (void)stopTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    labelLoading.hidden = YES;
}

- (void)timerTick:(NSTimer*)timer
{
    if ([labelLoading.text isEqualToString:@"."]) {
        labelLoading.text = @"..";
    } else if ([labelLoading.text isEqualToString:@".."]) {
        labelLoading.text = @"...";
    } else if ([labelLoading.text isEqualToString:@"..."]) {
        labelLoading.text = @".";
    }
}

- (void)repearLoadAction:(UIButton*)button
{
    if (self.repeatLoadBlock) {
        self.repeatLoadBlock();
    }
}

- (void)dealloc
{
    NSLog(@"dealloc %@ ",[self class]);
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
