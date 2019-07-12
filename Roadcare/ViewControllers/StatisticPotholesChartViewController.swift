//
//  StatisticPotholesChartViewController.swift
//  Roadcare
//
//  Created by macbook on 7/12/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import Charts

class StatisticPotholesChartViewController: DemoBaseViewController {

    @IBOutlet weak var chartView: BarChartView!
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        return formatter
    }()
    
    var groupedPrrts = [GroupedPRRTPotholes]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Stacked Bar Chart"
        self.options = [.toggleValues,
                        .toggleIcons,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData,
                        .toggleBarBorders]
        
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.maxVisibleCount = 40
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.highlightFullBarEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.labelRotationAngle = 270.0
        xAxis.valueFormatter = CityAxisValueFormatter(chart: chartView, prrts: groupedPrrts)
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 4
        l.xEntrySpace = 6
        //        chartView.legend = l
        
        self.updateChartData()
    }

    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setChartData(count: groupedPrrts.count-1, range: 200)
    }
    
    func setChartData(count: Int, range: UInt32) {
        let start = 1

        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let val1 = Double(groupedPrrts[i-1].reported_count)
            let val2 = Double(groupedPrrts[i-1].filled_count)
            
            return BarChartDataEntry(x: Double(i), yValues: [val1, val2])
        }
        
        let set = BarChartDataSet(values: yVals, label: "Statistics Vienna 2014")
        set.drawIconsEnabled = false
        set.colors = [NSUIColor(red: 46/255.0, green: 91/255.0, blue: 255/255.0, alpha: 1.0),
                      NSUIColor(red: 45/255.0, green: 158/255.0, blue: 52/255.0, alpha: 1.0)]
//        set.stackLabels = ["Births", "Divorces", "Marriages"]
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(.white)
        
        chartView.fitBars = true
        chartView.data = data
    }
}
