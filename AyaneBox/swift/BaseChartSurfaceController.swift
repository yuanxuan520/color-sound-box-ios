//
//  BaseChartSurfaceController.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 2/23/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart
import UIKit

@objc class BaseChartSurfaceController : NSObject {
    
     let chartSurface : SCIChartSurface

     init(_ view: SCIChartSurface) {
        
        chartSurface = view
        
    }
    
}

