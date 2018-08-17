//
//  AudioWaveformSurfaceController.swift
//  SciChartShowcaseDemo
//
//  Created by Yaroslav Pelyukh on 2/26/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart


// Formats labels as K when larger than 1x10E3, e.g. 2,000 becomes 2k
class ThousandsLabelProvider: SCINumericLabelProvider {
    override func formatLabel(_ dataValue: SCIGenericType) -> Swift.String! {
        return super.formatLabel(SCIGeneric(SCIGenericDouble(dataValue) / 10000))
        //            + "s"
    }
}

// Formats labels as B symbol when larger than 1x10E9, e.g. 2,000,000 becomes 2B
class BillionsLabelProvider: SCINumericLabelProvider { //pow(10, 9)
    override func formatLabel(_ dataValue: SCIGenericType) -> Swift.String! {
        return super.formatLabel(SCIGeneric(SCIGenericDouble(dataValue) / 10000 ))
        //            + "dB"
    }
}

class AudioWaveformSurfaceController: BaseChartSurfaceController {
    
    var audioWaveformRenderableSeries: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
    var audioDataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .int32, yType: .int16)
    @objc var updateDataSeries: samplesToEngine!
    var seriesCounter : Int32 = 0
    var lastTimestamp : Double = 0.0
    var newBuffer : UnsafeMutablePointer<Int16>?
    var sizeOfBuffer = 0
    var fifoSize = 500000
    
    @objc public func updateData(displayLink: CADisplayLink) {
        
        var diffTimeStamp = displayLink.timestamp - lastTimestamp
        
        if lastTimestamp == 0 {
            diffTimeStamp = displayLink.duration
        }
        
        var sizeOfBlock = Int(diffTimeStamp * 44100)
        
        sizeOfBlock = sizeOfBlock >= sizeOfBuffer ? sizeOfBuffer : sizeOfBlock
        
        let xValues = UnsafeMutablePointer<Int32>.allocate(capacity: sizeOfBlock)
        xValues.initialize(to: 0)
        var i = 0
        while i < sizeOfBlock {
            xValues[i] = seriesCounter
            seriesCounter += 1
            i += 1
        }
        
        if let buffer = newBuffer {
            audioDataSeries.appendRangeX(SCIGeneric(xValues), y: SCIGeneric(buffer), count: Int32(sizeOfBlock))
            let newSizeBuffer = sizeOfBuffer - sizeOfBlock
            let delocBuffer = UnsafeMutablePointer<Int16>.allocate(capacity: newSizeBuffer)
            delocBuffer.initialize(to: 0)
            delocBuffer.moveAssign(from: buffer.advanced(by: sizeOfBlock), count: newSizeBuffer)
            newBuffer = delocBuffer
            buffer.deallocate() //capacity: sizeOfBuffer
            sizeOfBuffer = newSizeBuffer
        }
        
        xValues.deinitialize(count: sizeOfBlock) //
        xValues.deallocate() //capacity: sizeOfBlock
        
        lastTimestamp = displayLink.timestamp
        chartSurface.zoomExtentsX()
        chartSurface.invalidateElement()
        
    }
    
    @objc override init(_ view: SCIChartSurface) {
        super.init(view)
        
        chartSurface.bottomAxisAreaSize = 0.0
        chartSurface.topAxisAreaSize = 0.0
        chartSurface.leftAxisAreaSize = 0.0
        chartSurface.rightAxisAreaSize = 0.0
        
        self.updateDataSeries = { [unowned self] dataSeries in
            let capacity = 2048 + self.sizeOfBuffer
            let newBuffer : UnsafeMutablePointer<Int16>
            
            if let bf = self.newBuffer {
                newBuffer = UnsafeMutablePointer<Int16>.allocate(capacity: capacity)
                newBuffer.initialize(to: 0)
                newBuffer.moveAssign(from: bf, count: self.sizeOfBuffer)
                newBuffer.advanced(by: self.sizeOfBuffer).moveAssign(from: dataSeries!, count: 2048)
                self.newBuffer = newBuffer
                bf.deallocate() //capacity: self.sizeOfBuffer
                self.sizeOfBuffer = capacity
            }
            else if let data = dataSeries {
                newBuffer = UnsafeMutablePointer<Int16>.allocate(capacity: capacity)
                newBuffer.initialize(to: 0)
                newBuffer.moveAssign(from: data, count: capacity)
                self.newBuffer = newBuffer
                self.sizeOfBuffer = capacity
            }
        }
        
        audioDataSeries.fifoCapacity = Int32(fifoSize)
        audioWaveformRenderableSeries.dataSeries = audioDataSeries
        //        fillFifoToMax()
        chartSurface.renderableSeries.add(audioWaveformRenderableSeries)
        
        let axisStyle = SCIAxisStyle()
        axisStyle.drawLabels = true
        axisStyle.drawMajorBands = true
        axisStyle.drawMinorTicks = true
        axisStyle.drawMajorTicks = true
        axisStyle.drawMajorGridLines = true
        axisStyle.drawMinorGridLines = true
        
        let xAxis = SCINumericAxis()
        xAxis.style = axisStyle
        xAxis.visibleRange = SCIIntegerRange(min: SCIGeneric(0), max: SCIGeneric(Int32.max))
        
        let yAxis = SCINumericAxis()
        yAxis.style = axisStyle
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(Int16.min), max: SCIGeneric(Int16.max))
        yAxis.autoRange = .never
        
        xAxis.labelProvider = ThousandsLabelProvider()
        yAxis.labelProvider = BillionsLabelProvider()
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        
    }
    
    @objc func resetData() {
        if let bf = self.newBuffer {
            bf.deallocate()
            self.newBuffer = nil;
//            self.sizeOfBuffer = 0;
//            self.seriesCounter = 0
//            self.lastTimestamp = 0.0
//            self.fifoSize = 500000
        }
        
//        chartSurface.yAxes.clear();
//        chartSurface.xAxes.clear();
//        chartSurface.renderableSeries.clear()
//
//        chartSurface.bottomAxisAreaSize = 0.0
//        chartSurface.topAxisAreaSize = 0.0
//        chartSurface.leftAxisAreaSize = 0.0
//        chartSurface.rightAxisAreaSize = 0.0
//
//        self.audioDataSeries = SCIXyDataSeries(xType: .int32, yType: .int16)
//        self.audioWaveformRenderableSeries = SCIFastLineRenderableSeries()
//
//        audioWaveformRenderableSeries.dataSeries = audioDataSeries
//        //        fillFifoToMax()
//        chartSurface.renderableSeries.add(audioWaveformRenderableSeries)
//
//        let axisStyle = SCIAxisStyle()
//        axisStyle.drawLabels = true
//        axisStyle.drawMajorBands = true
//        axisStyle.drawMinorTicks = true
//        axisStyle.drawMajorTicks = true
//        axisStyle.drawMajorGridLines = true
//        axisStyle.drawMinorGridLines = true
//
//        let xAxis = SCINumericAxis()
//        xAxis.style = axisStyle
//        xAxis.visibleRange = SCIIntegerRange(min: SCIGeneric(0), max: SCIGeneric(Int32.max))
//
//        let yAxis = SCINumericAxis()
//        yAxis.style = axisStyle
//        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(Int16.min), max: SCIGeneric(Int16.max))
//        yAxis.autoRange = .never
//
//        xAxis.labelProvider = ThousandsLabelProvider()
//        yAxis.labelProvider = BillionsLabelProvider()
//
//        chartSurface.yAxes.add(yAxis)
//        chartSurface.xAxes.add(xAxis)
        
//        fillFifoToMax()
        
//
        
//
//        let axisStyle = SCIAxisStyle()
//        axisStyle.drawLabels = true
//        axisStyle.drawMajorBands = true
//        axisStyle.drawMinorTicks = true
//        axisStyle.drawMajorTicks = true
//        axisStyle.drawMajorGridLines = true
//        axisStyle.drawMinorGridLines = true
//
//        let xAxis = SCINumericAxis()
//        xAxis.style = axisStyle
//        xAxis.visibleRange = SCIIntegerRange(min: SCIGeneric(0), max: SCIGeneric(Int32.max))
//
//        let yAxis = SCINumericAxis()
//        yAxis.style = axisStyle
//        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(Int16.min), max: SCIGeneric(Int16.max))
//        yAxis.autoRange = .never
//
//        xAxis.labelProvider = ThousandsLabelProvider()
//        yAxis.labelProvider = BillionsLabelProvider()
//
//        chartSurface.yAxes.add(yAxis)
//        chartSurface.xAxes.add(xAxis)
    }
    
//    func fillFifoToMax() {
//        let xValues = UnsafeMutablePointer<Int32>.allocate(capacity: fifoSize)
//        xValues.initialize(to: 0)
//
//        for i in 0..<fifoSize {
//            xValues[i] = seriesCounter
//            seriesCounter += 1
//        }
//
//        let yValues = UnsafeMutablePointer<Int32>.allocate(capacity: fifoSize)
//        yValues.initialize(to: 0)
//
//        audioDataSeries.appendRangeX(SCIGeneric(xValues),
//                                     y: SCIGeneric(yValues),
//                                     count: Int32(fifoSize))
//        xValues.deinitialize()
//        xValues.deallocate(capacity: fifoSize)
//        yValues.deinitialize()
//        yValues.deallocate(capacity: fifoSize)
//
//    }
    
}
