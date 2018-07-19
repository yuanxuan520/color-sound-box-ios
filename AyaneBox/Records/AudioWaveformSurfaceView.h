//
//  AudioWaveformSurfaceView.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/12.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciChartBaseViewProtocol.h"
#import <SciChart/SciChart.h>
#import "AudioRecorder.h"

@interface AudioWaveformSurfaceView : UIView<SciChartBaseViewProtocol>
@property (nonatomic, copy) samplesToEngine updateDataSeries;

@end
