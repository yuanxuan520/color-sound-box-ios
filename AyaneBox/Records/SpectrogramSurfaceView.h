//
//  SpectrogramSurfaceView.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/12.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SciChart/SciChart.h>
#import "AudioRecorder.h"
#import "SciChartBaseViewProtocol.h"
@interface SpectrogramSurfaceView : UIView<SciChartBaseViewProtocol>
@property (nonatomic, strong) SCIFastUniformHeatmapRenderableSeries *audioWaveformRenderableSeries;
@property (nonatomic, strong) SCIUniformHeatmapDataSeries *audioDataSeries;
@property (nonatomic, copy) samplesToEngineFloat updateDataSeries;
- (void)updateData:(CADisplayLink *)displayLink;

@end
