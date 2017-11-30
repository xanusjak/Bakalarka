//
//  GraphView.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 27/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit
import Charts

class GraphView: UIView {
    
    fileprivate var modelName: String!
    fileprivate var graphData = [[Double]]()
    fileprivate var animation: Bool!
    fileprivate var pointsNumber: Int = 0
    
    fileprivate var chartView = LineChartView()
    
    init(modelName: String, withAnimation: Bool) {
        super.init(frame: .zero)
        self.modelName = modelName
        self.animation = withAnimation
        
        self.graphData = MatlabService.sharedClient.getGraphData(modelName)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        createGraph()
        
        self.addSubview(chartView)
    }
    
    func setupConstraints() {
        chartView.autoPinEdgesToSuperviewEdges()
    }
    
    fileprivate func createGraph() {
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        chartView.minOffset = 2
        chartView.borderColor = .gray
        
        setData()
    }
    
    func setData() {
        
        let dataSets = (1..<graphData.count).map { i -> LineChartDataSet in
            
            let values = (0..<graphData[i].count).map { (j) -> ChartDataEntry in
                return ChartDataEntry(x: graphData[0][j], y: graphData[i][j], icon: nil)
            }
            
            let set = LineChartDataSet(values: values, label: "DataSet \(i)")
            set.lineWidth = 1.5
            set.circleRadius = 0
            set.circleHoleRadius = 0
            
            set.setColor(UIColor.getRandomColor(index: i))
            set.setCircleColor(UIColor.getRandomColor(index: i))
            
            return set
        }
        
        
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
    }

}

extension GraphView : ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}

