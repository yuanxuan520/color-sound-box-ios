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
{
    float *dataArrays;
}
@property (nonatomic) BOOL isNewData;


@end

@implementation SpectrogramSurfaceView
@synthesize surface;
@synthesize isNewData;
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
- (void)updateData {
    if (self.isNewData) {
        self.isNewData = NO;
        [self.audioDataSeries updateZValues:SCIGeneric(dataArrays) Size:xSize*ySize];
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
    dataArrays = calloc(1,xSize*ySize);;
    surface.bottomAxisAreaSize = 0.0;
    surface.topAxisAreaSize = 0.0;
    surface.leftAxisAreaSize = 0.0;
    surface.rightAxisAreaSize = 0.0;
    self.isNewData = NO;
    memset(dataArrays, 0.0, xSize*ySize);
    float grad[] = {0.0, 0.3, 0.5, 0.7, 0.9, 1.0};
    uint colors[] = {0xFF000000, 0xFF520306, 0xFF8F2325, 0xFF68E615, 0xFF6FB9CC, 0xFF1128e6};
    self.audioWaveformRenderableSeries.dataSeries = self.audioDataSeries;
    self.audioWaveformRenderableSeries.style.minimum = SCIGeneric(0.0);
    self.audioWaveformRenderableSeries.style.maximum = SCIGeneric(60.0);
    self.audioWaveformRenderableSeries.style.colorMap = [[SCITextureOpenGL alloc] initWithGradientCoords:grad Colors:colors Count:6];
    
    [surface.renderableSeries add:self.audioWaveformRenderableSeries];

    SCIAxisStyle *axisStyle = [SCIAxisStyle new];
    axisStyle.drawLabels = YES;
    axisStyle.drawMajorBands = YES;
    axisStyle.drawMinorTicks = YES;
    axisStyle.drawMajorTicks = YES;
    axisStyle.drawMajorGridLines = YES;
    axisStyle.drawMinorGridLines = YES;
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.style = axisStyle;
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.style = axisStyle;
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.flipCoordinates = YES;
    yAxis.axisAlignment = SCIAxisAlignment_Bottom;
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    
//    [surface invalidateElement];

}


- (void)updateDataSeries:(float *)fftArray
{
    if (fftArray) {
        memmove(dataArrays,dataArrays+ySize,sizeof(float)*(xSize-1)*ySize);
        memcpy(dataArrays+((xSize-1)*ySize),fftArray,sizeof(int)*ySize);
        self.isNewData = YES;
    }
}

@end
