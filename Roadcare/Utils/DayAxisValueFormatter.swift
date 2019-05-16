//
//  CityAxisValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class CityAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    private var groupedPrrts = [GroupedPRRTPotholes]()

    init(chart: BarLineChartViewBase, prrts: [GroupedPRRTPotholes]) {
        self.chart = chart
        self.groupedPrrts = prrts
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let days = Int(value) - 1
        let city = groupedPrrts[days].city
        let country = groupedPrrts[days].country
        
        return city + "\n" + country
    }
}
