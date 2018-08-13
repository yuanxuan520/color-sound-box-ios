//
//  PlayControlViewController.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AyaneBox-Swift.h"
#import <SciChart/SciChart.h>

@interface PlayControlViewController : UIViewController
@property (nonatomic, strong) IBOutlet SCIChartSurface *audioWaveView;
@property (nonatomic, strong) IBOutlet SCIChartSurface *spectogramView;
@end
