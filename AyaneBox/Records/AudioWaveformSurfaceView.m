//
//  AudioWaveformSurfaceView.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/12.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "AudioWaveformSurfaceView.h"

@interface ThousandsLabelProvider : SCINumericLabelProvider
@end
@implementation ThousandsLabelProvider
- (NSString *)formatLabel:(SCIGenericType)dataValue
{
    return [super formatLabel:(SCIGeneric(SCIGenericDouble(dataValue) / 10000))];
}
@end

@interface BillionsLabelProvider : SCINumericLabelProvider
@end
@implementation BillionsLabelProvider
- (NSString *)formatLabel:(SCIGenericType)dataValue
{
    return [super formatLabel:(SCIGeneric(SCIGenericDouble(dataValue) / 10000))];
}
@end
@interface AudioWaveformSurfaceView(){
    SCIFastLineRenderableSeries *audioWaveformRenderableSeries;
    SCIXyDataSeries *audioDataSeries;
    int32_t seriesCounter;
    double lastTimestamp;
    double *newBuffer;
//var newBuffer : UnsafeMutablePointer<Int32>?
    double sizeOfBuffer;
    double fifoSize;
}
@end

@implementation AudioWaveformSurfaceView
@synthesize surface;

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


-(void) initializeSurfaceData {
    audioWaveformRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    audioDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];
    seriesCounter = 0;
    lastTimestamp = 0.0;
    newBuffer = malloc(sizeof(int32_t));
    free(newBuffer);
    sizeOfBuffer = 0;
    fifoSize = 500000;
    
    surface.bottomAxisAreaSize = 0.0;
    surface.topAxisAreaSize = 0.0;
    surface.leftAxisAreaSize = 0.0;
    surface.rightAxisAreaSize = 0.0;
    
//    updateDataSeries = ^(int *a){
//        __unsafe_unretained id this = self;
//        double capacity = 2048 + sizeOfBuffer;
//        double newBuffer = malloc(sizeof(int32_t));
        //
        //        if let bf = self.newBuffer {
        //            newBuffer = UnsafeMutablePointer<Int32>.allocate(capacity: capacity)
        //            newBuffer.initialize(to: 0)
        //            newBuffer.moveAssign(from: bf, count: self.sizeOfBuffer)
        //            newBuffer.advanced(by: self.sizeOfBuffer).moveAssign(from: dataSeries!, count: 2048)
        //            self.newBuffer = newBuffer
        //            bf.deallocate(capacity: self.sizeOfBuffer)
        //            self.sizeOfBuffer = capacity
        //        }
        //        else if let data = dataSeries {
        //            newBuffer = UnsafeMutablePointer<Int32>.allocate(capacity: capacity)
        //            newBuffer.initialize(to: 0)
        //            newBuffer.moveAssign(from: data, count: capacity)
        //            self.newBuffer = newBuffer
        //            self.sizeOfBuffer = capacity
        //        }
//    };
    
    
    audioDataSeries.fifoCapacity = (int)fifoSize;
    audioWaveformRenderableSeries.dataSeries = audioDataSeries;
//    //        fillFifoToMax()
    [surface.renderableSeries add:audioWaveformRenderableSeries];
    
    SCIAxisStyle *axisStyle = [[SCIAxisStyle alloc] init];
    axisStyle.drawLabels = YES;
    axisStyle.drawMajorBands = YES;
    axisStyle.drawMinorTicks = YES;
    axisStyle.drawMajorTicks = YES;
    axisStyle.drawMajorGridLines = YES;
    axisStyle.drawMinorGridLines = YES;
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.style = axisStyle;
    xAxis.visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0) Max:SCIGeneric(INT32_MAX)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.style = axisStyle;
    yAxis.visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(INT32_MIN) Max:SCIGeneric(INT32_MAX)];
    yAxis.autoRange = SCIAutoRange_Never;
    
    xAxis.labelProvider = [[ThousandsLabelProvider alloc] init];
    yAxis.labelProvider = [[BillionsLabelProvider alloc] init];
   
    [surface.yAxes add:yAxis];
    [surface.xAxes add:xAxis];
}


- (void)updateData:(CADisplayLink *)displayLink {
    
    NSTimeInterval diffTimeStamp = displayLink.timestamp - lastTimestamp;
    if (lastTimestamp == 0) {
        diffTimeStamp = displayLink.duration;
    }
    
    int sizeOfBlock = (int)(diffTimeStamp * 44100);
    
    sizeOfBlock = sizeOfBlock >= sizeOfBuffer ? sizeOfBuffer : sizeOfBlock;
    
//    let xValues = UnsafeMutablePointer<Int32>.allocate(capacity: sizeOfBlock)
    double *xValues = malloc(sizeof(sizeOfBlock));
    
//    xValues.initialize(to: 0)
    int i = 0;
    while(i < sizeOfBlock) {
        xValues[i] = seriesCounter;
        seriesCounter += 1;
        i += 1;
    }
    double *buffer = newBuffer;
    if (buffer) {
        [audioDataSeries appendRangeX:SCIGeneric(xValues) Y:SCIGeneric(buffer) Count:sizeOfBlock];
        double newSizeBuffer = sizeOfBuffer - sizeOfBlock;
        double *delocBuffer = malloc(sizeof(double));
        delocBuffer = malloc(sizeof(newSizeBuffer));
//        delocBuffer.moveAssign(from: buffer.advanced(by: sizeOfBlock), count: newSizeBuffer)
        newBuffer = delocBuffer;
//        buffer.deallocate(capacity: sizeOfBuffer)
        sizeOfBuffer = newSizeBuffer;
        free(delocBuffer);
    }
    
//    xValues.deinitialize()
//    xValues.deallocate(capacity: sizeOfBlock)
    
    lastTimestamp = displayLink.timestamp;
    [surface zoomExtentsX];
    [surface invalidateElement];
    free(xValues);
}


@end
