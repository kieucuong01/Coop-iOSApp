//
//  DayAxisValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    var firstYear : UInt16  = 0

    init(firstYear: UInt16){
        self.firstYear = firstYear
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var month : Int = Int(value) % 12
        var year : UInt16 = firstYear + UInt16(value/12.0)
        if  month == 0 {
            month = 12
            year -= 1
        }

        if month == 1 {
            return "T\(month)\n\(year)"
        }
        return "T\(month)\n"
    }
}
