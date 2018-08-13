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

@interface AudioWaveformSurfaceView : UIView<SciChartBaseViewProtocol>
- (void)updateDataSeriesOld:(NSData *)dataSeries;
- (void)updateDataSeries:(NSData *)dataSeries;
- (void)updateData:(CADisplayLink *)displayLink;
@end
