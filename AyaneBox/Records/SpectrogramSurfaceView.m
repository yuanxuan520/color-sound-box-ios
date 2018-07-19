//
//  SpectrogramSurfaceView.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/12.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "SpectrogramSurfaceView.h"

#define xSize 250
#define ySize 1024
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface SpectrogramSurfaceView ()
@property (nonatomic) float *dataArrays;
@property (nonatomic) BOOL isNewData;


@end

@implementation SpectrogramSurfaceView
@synthesize surface;
@synthesize dataArrays,isNewData;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc]initWithFrame:frame];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}
- (void)updateData:(CADisplayLink *)displayLink {
    if (self.isNewData) {
        self.isNewData = NO;
        [self.audioDataSeries updateZValues:SCIGeneric(self.dataArrays) Size:xSize*ySize];
        [surface invalidateElement];
    }
    
}
-(void) initializeSurfaceData {
    self.audioWaveformRenderableSeries = [[SCIFastUniformHeatmapRenderableSeries alloc] init];
    self.audioDataSeries = [[SCIUniformHeatmapDataSeries alloc] initWithTypeX:SCIDataType_Int32
                                                                            Y:SCIDataType_Int32
                                                                            Z:SCIDataType_Float
                                                                        SizeX:1024
                                                                            Y:250
                                                                       StartX:SCIGeneric(0)
                                                                        StepX:SCIGeneric(1)
                                                                       StartY:SCIGeneric(0)
                                                                        StepY:SCIGeneric(1)];
    surface.bottomAxisAreaSize = 0.0;
    surface.topAxisAreaSize = 0.0;
    surface.leftAxisAreaSize = 0.0;
    surface.rightAxisAreaSize = 0.0;
    self.dataArrays = malloc(sizeof(int)*xSize*ySize);;
    isNewData = NO;
    memset(dataArrays, 0, sizeof(int)*xSize*ySize);
    self.updateDataSeries = ^(float *data){
        float* pointerInt32 = data;
        if (pointerInt32) {
//            memmove(self.dataArrays,
//                    self.dataArrays.advanced(by: Int(HeatmapSettings.ySize)),
//                    Int((HeatmapSettings.xSize-1)*HeatmapSettings.ySize)*MemoryLayout<Float>.size)
//            memcpy(self.dataArrays.advanced(by: Int(HeatmapSettings.ySize*(HeatmapSettings.xSize-1))),
//                   pointerInt32, Int(HeatmapSettings.ySize)*MemoryLayout<Float>.size)
            
            memmove(self.dataArrays,sizeof(float)*ySize,sizeof(float)*(xSize-1)*ySize);
            memcpy(self.dataArrays,sizeof(float)*(xSize-1)*ySize,sizeof(float)*ySize);
            self.isNewData = YES;
        }
    };
    
    float grad[] = {0.0, 0.3, 0.5, 0.7, 0.9, 1.0};
    uint colors[] = {0xFF000000, 0xFF520306, 0xFF8F2325, 0xFF68E615, 0xFF6FB9CC, 0xFF1128e6};
    
    self.audioWaveformRenderableSeries = [SCIFastUniformHeatmapRenderableSeries new];
    self.audioWaveformRenderableSeries.style.colorMap = [[SCITextureOpenGL alloc] initWithGradientCoords:grad Colors:colors Count:6];
    
    [surface.renderableSeries add:self.audioWaveformRenderableSeries];

    SCIAxisStyle *axisStyle = [[SCIAxisStyle alloc] init];
    axisStyle.drawLabels = YES;
    axisStyle.drawMajorBands = YES;
    axisStyle.drawMinorTicks = YES;
    axisStyle.drawMajorTicks = YES;
    axisStyle.drawMajorGridLines = YES;
    axisStyle.drawMinorGridLines = YES;
    
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    xAxis.style = axisStyle;
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    yAxis.style = axisStyle;
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.flipCoordinates = YES;
    yAxis.axisAlignment = SCIAxisAlignment_Bottom;
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    
    [surface invalidateElement];
}


@end
