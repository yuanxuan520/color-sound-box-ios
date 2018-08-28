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
@interface AudioWaveformSurfaceView()
@property (nonatomic, strong) SCIFastLineRenderableSeries *audioWaveformRenderableSeries;
@property (nonatomic, strong) SCIXyDataSeries *audioDataSeries;
@property (nonatomic, assign) int seriesCounter;
@property (nonatomic, assign) int fifoSize;
@end

@implementation AudioWaveformSurfaceView
@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc] initWithFrame:frame];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    return self;
}
- (void)initializeSurfaceData {
//   创建一个快速变换的线型图
    self.audioWaveformRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
//    x y 数据展示
    self.audioDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int16];
    self.seriesCounter = 0;
    self.fifoSize = 500000;
    
    surface.bottomAxisAreaSize = 0.0;
    surface.topAxisAreaSize = 0.0;
    surface.leftAxisAreaSize = 0.0;
    surface.rightAxisAreaSize = 0.0;
    
    self.audioDataSeries.fifoCapacity = self.fifoSize;
    self.audioWaveformRenderableSeries.dataSeries = self.audioDataSeries;
//    //        fillFifoToMax()
    [surface.renderableSeries add:self.audioWaveformRenderableSeries];
    
    SCIAxisStyle *axisStyle = [[SCIAxisStyle alloc] init];
    axisStyle.drawLabels = YES;
    axisStyle.drawMajorBands = YES;
    axisStyle.drawMinorTicks = YES;
    axisStyle.drawMajorTicks = YES;
    axisStyle.drawMajorGridLines = YES;
    axisStyle.drawMinorGridLines = YES;
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.style = axisStyle;
    xAxis.autoRange = SCIAutoRange_Always;
    xAxis.visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0) Max:SCIGeneric(INT32_MAX)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.style = axisStyle;
    yAxis.visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(INT16_MIN) Max:SCIGeneric(INT16_MAX)];
//    yAxis.autoRange = SCIAutoRange_Never;
    
    xAxis.labelProvider = [[ThousandsLabelProvider alloc] init];
    yAxis.labelProvider = [[BillionsLabelProvider alloc] init];
//
    [surface.yAxes add:yAxis];
    [surface.xAxes add:xAxis];
    
//    NSArray *xArray = @[@1, @2, @3, @4, @5];
//    NSArray *yArray = @[@100, @200, @10000, @(-10000), @20000];
    
//    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
//        [self.audioDataSeries appendRangeX:xArray Y:yArray];

//        [surface invalidateElement];
//    }];
//    __weak typeof(self) weakSelf = self;
//    AudioWaveformSurfaceView *strongSelf = weakSelf;
//    self.updateDataSeries = ^(short *dataSeries){
//        int capacity = 2048 + strongSelf->sizeOfBuffer;
//        short *newBufferTemp;
//
//        short *bf = strongSelf->newBuffer;
//
//        short *data = dataSeries;
//
//        if (bf) {
//            newBufferTemp = malloc(sizeof(short)*capacity);
//            memset(newBufferTemp, 0, sizeof(short)*capacity);
//            memmove(newBufferTemp, bf, strongSelf->sizeOfBuffer);
//            newBufferTemp = newBufferTemp + strongSelf->sizeOfBuffer;
//            memmove(newBufferTemp, dataSeries, 2048);
//            free(bf);
//            strongSelf->sizeOfBuffer = capacity;
//        }else if (data) {
//            newBufferTemp = malloc(sizeof(int16_t)*capacity);
//            memset(newBufferTemp, 0, sizeof(int16_t)*capacity);
//            memmove(newBufferTemp, data, capacity);
//            strongSelf->newBuffer = newBufferTemp;
//            strongSelf->sizeOfBuffer = capacity;
//        }
//    };
}


- (void)updateDataSeries:(NSData *)dataSeries
{
    NSUInteger length = [dataSeries length];
    NSMutableArray *xArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *yArray = [NSMutableArray arrayWithCapacity:0];
    short *out03 = (short *)[dataSeries bytes];
    int i = 0;
    while(i < (length/2)) {
        [xArray addObject:@(self.seriesCounter)];
        [yArray addObject:@(out03[self.seriesCounter])];
        self.seriesCounter += 1;
        i += 1;
    }
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [self.audioDataSeries appendRangeX:xArray Y:yArray];
//        [surface invalidateElement];
    }];
}

//- (void)updateDataSeries:(NSData *)dataSeries
//{
//    NSData *newDataSeries = [NSData dataWithData:dataSeries];
//    int capacity = 2048 + sizeOfBuffer;
//    int16_t *newBufferTemp;
//
//    int16_t *bf = newBuffer;
//
//    int16_t *data = (int16_t *)[newDataSeries bytes];
//
//    if (bf) {
//        newBufferTemp = calloc(1, capacity);
//        memmove(newBufferTemp, bf, sizeOfBuffer);
//        memmove(newBufferTemp+(sizeOfBuffer/2), data, 2048);
//        newBuffer = newBufferTemp;
//        //       释放上次的内存
//        free(bf);
//        sizeOfBuffer = capacity;
//
//    }else if (data) {
//        newBufferTemp = calloc(1 ,capacity);
//        memmove(newBufferTemp, data, capacity);
//        newBuffer = newBufferTemp;
//        sizeOfBuffer = capacity;
//    }
//}
//- (void)updateDataSeries:(NSData *)dataSeries
//{
////    NSData *newDataSeries = [NSData dataWithData:dataSeries];
//    int capacity = 2048 + sizeOfBuffer;
//    NSMutableData *newBufferTemp;
//
//    NSMutableData *bf = newBufferData;
//
////    int16_t *data = (int16_t *)[newDataSeries bytes];
//
//    if (bf) {
//        newBufferTemp = [NSMutableData dataWithLength:capacity];
//        [newBufferTemp replaceBytesInRange:NSMakeRange(0, sizeOfBuffer) withBytes:[bf bytes] length:sizeOfBuffer];
//        [newBufferTemp replaceBytesInRange:NSMakeRange(sizeOfBuffer, dataSeries.length) withBytes:[dataSeries bytes] length:dataSeries.length];
//        newBufferData = newBufferTemp;
//    }else if (dataSeries) {
//        newBufferTemp =  [NSMutableData dataWithLength:capacity];
//        [newBufferTemp replaceBytesInRange:NSMakeRange(0, capacity) withBytes:[dataSeries bytes] length:capacity];
//        newBufferData = newBufferTemp;
//        sizeOfBuffer = capacity;
//    }
//}

//- (void)updateData:(CADisplayLink *)displayLink {
//
//    NSTimeInterval diffTimeStamp = displayLink.timestamp - lastTimestamp;
//    if (lastTimestamp == 0) {
//        diffTimeStamp = displayLink.duration;
//    }
//
//    int16_t sizeOfBlock = (int16_t)(diffTimeStamp * 44100);
//
//    sizeOfBlock = sizeOfBlock >= sizeOfBuffer ? sizeOfBuffer : sizeOfBlock;
//
//    int16_t *xValues = calloc(1,sizeOfBlock);
//
//    int i = 0;
//    while(i < sizeOfBlock) {
//        xValues[i] = seriesCounter;
//        seriesCounter += 1;
//        i += 1;
//    }
//    NSMutableData *bufferData = [NSMutableData dataWithData:newBufferData];
//    int16_t *buffer = (int16_t *)[bufferData bytes];
//    if (buffer) {
//        [audioDataSeries appendRangeX:SCIGeneric(xValues) Y:SCIGeneric(buffer) Count:sizeOfBlock];
//        int16_t newSizeBuffer = sizeOfBuffer - sizeOfBlock;
//        NSData *subData = [bufferData subdataWithRange:NSMakeRange(sizeOfBlock, newSizeBuffer)];
//        NSMutableData *delocBuffer = [NSMutableData dataWithLength:newSizeBuffer];
//        [delocBuffer replaceBytesInRange:NSMakeRange(sizeOfBlock, newSizeBuffer) withBytes:[subData bytes] length:newSizeBuffer];
//        newBufferData = delocBuffer;
//        sizeOfBuffer = newSizeBuffer;
//    }
//    free(xValues);
//    lastTimestamp = displayLink.timestamp;
//    [surface zoomExtentsX];
//    [surface invalidateElement];
//}

//- (void)updateData:(CADisplayLink *)displayLink {
//
//    NSTimeInterval diffTimeStamp = displayLink.timestamp - lastTimestamp;
//    if (lastTimestamp == 0) {
//        diffTimeStamp = displayLink.duration;
//    }
////(int)(diffTimeStamp * 44100)
//    int sizeOfBlock = 2048;
//
//    sizeOfBlock = sizeOfBlock >= sizeOfBuffer ? sizeOfBuffer : sizeOfBlock;
//
//    int *xValues = calloc(1,sizeOfBlock);
//
//    int i = 0;
//    while(i < sizeOfBlock) {
//        xValues[i] = seriesCounter;
//        seriesCounter += 1;
//        i += 1;
//    }
//    int16_t *buffer = newBuffer;
//    if (buffer) {
//        [audioDataSeries appendRangeX:SCIGeneric(xValues) Y:SCIGeneric(buffer) Count:sizeOfBlock];
//        int newSizeBuffer = sizeOfBuffer - sizeOfBlock;
//        int16_t *delocBuffer = calloc(1, newSizeBuffer);
//        int16_t *curBuffer = &buffer[sizeOfBlock];
//        memmove(delocBuffer,curBuffer,newSizeBuffer);
//        newBuffer = delocBuffer;
//        sizeOfBuffer = newSizeBuffer;
//    }
//    free(buffer);
//    free(xValues);
//    lastTimestamp = displayLink.timestamp;
//    [surface zoomExtentsX];
//    [surface invalidateElement];
//}


@end
