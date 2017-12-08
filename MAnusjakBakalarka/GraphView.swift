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
    
    open var timer: Timer!
    
    fileprivate var modelName: String!
    fileprivate var graphData: [[Double]]!
    
    fileprivate var chartView = LineChartView()
    
    init(modelName: String) {
        super.init(frame: .zero)
        self.modelName = modelName
        
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
        
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
        
        chartView.borderColor = .gray
        
        chartView.xAxis.axisMinimum = 0
        
    }
    
    func setData() {
        
        let dataSets = (1..<graphData.count).map { i -> LineChartDataSet in
            
            let values = (0..<graphData[i].count).map { (j) -> ChartDataEntry in
                return ChartDataEntry(x: graphData[0][j], y: graphData[i][j], icon: nil)
            }
            
            let set = LineChartDataSet(values: values, label: nil)
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
        
        chartView.setVisibleXRangeMaximum(2)
        chartView.moveViewToX(Double(graphData[0].count - 3))
    }
    
    open func setupDataTimer(){
        
        graphData = [[Double]]()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
    }
    
    @objc func getData() {
        
        let data = MatlabService.sharedClient.getGraphData(modelName)
        
        for i in 0..<data.count {
            if graphData.indices.contains(i) {
                graphData[i].append(contentsOf: data[i])
            }
            else {
                graphData.append(data[i])
            }
        }
        
        setData()
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

