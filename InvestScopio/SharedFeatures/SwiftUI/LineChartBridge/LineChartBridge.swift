//
//  LineChart.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 24/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import Charts

extension View {
    public func setChartDataBase(_ data: ChartDataBaseBridge = ChartDataBaseBridge()) -> some View {
        return self
            .environmentObject(data)
    }
    
    public func setChartDataSet(_ data: LineChartDataSetBaseBridge = LineChartDataSetBaseBridge()) -> some View {
        return self
            .environmentObject(data)
    }
}

extension LineChartView {
    
}

struct LineChart: UIViewRepresentable {
    var entries: [ChartDataEntry]
    var lastMonths: Int = 0
    var months: Int
    @Binding var hideHighlight: Bool
    @Binding var indexSelected: Int
    @Binding var positionXSelected: CGFloat
    @State var shouldAnimate: Bool = true
    
    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        
        setLeftAxys(chartView: chartView)
        setXAxys(chartView: chartView)
        setInterativeCharts(chartView: chartView)
        setChartsInfo(chartView: chartView)
        setChartsEntries(chartView: chartView)
        setMarker(chartView: chartView)
        chartView.delegate = context.coordinator
        let gesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleGesture(_:)))
        gesture.minimumPressDuration = 0.2
        gesture.allowableMovement = 50
        chartView.addGestureRecognizer(gesture)
        return chartView
    }
    
    func setInterativeCharts(chartView: LineChartView) {
        chartView.dragEnabled = false
        chartView.autoScaleMinMaxEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.legend.enabled = false
    }
    
    func setChartsInfo(chartView: LineChartView) {
        chartView.chartDescription?.enabled = false
        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.drawGridBackgroundEnabled = false
        
    }
    
    private func setMarker(chartView: LineChartView) {
        chartView.marker = ChartMarkerView.init(color: .JEWBackground(), chartView: chartView)
        chartView.drawMarkers = true
        chartView.viewPortHandler.setMaximumScaleX(1)
        chartView.viewPortHandler.setMaximumScaleY(1)
    }
    
    func setChartsEntries(chartView: LineChartView) {
        let set = LineChartDataSet(entries: entries, label: nil)
        set.setColor(.JEWDefault())
        set.lineWidth = 2
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.highlightLineWidth = 2
        set.highlightColor = .JEWDarkDefault()
        set.highlightEnabled = true
        set.drawVerticalHighlightIndicatorEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSets: [set])
        chartView.data = data
        chartView.data?.calcMinMax()
        chartView.animate(xAxisDuration: shouldAnimate ? 0.5 : .zero, yAxisDuration: shouldAnimate ? 0.5 : .zero)
    }
    
    func setLeftAxys(chartView: LineChartView) {
        chartView.leftAxis.enabled = true
        chartView.leftAxis.drawZeroLineEnabled = true
        chartView.leftAxis.zeroLineColor = UIColor.label
        chartView.leftAxis.zeroLineWidth = 1
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.spaceBottom = 0.01
        chartView.leftAxis.spaceTop = 0.01
    }
    
    func setXAxys(chartView: LineChartView) {
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.enabled = false
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        setLeftAxys(chartView: uiView)
        setXAxys(chartView: uiView)
        setInterativeCharts(chartView: uiView)
        setChartsInfo(chartView: uiView)
        setChartsEntries(chartView: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(shouldAnimate: $shouldAnimate, hideHighlight: $hideHighlight, indexSelected: $indexSelected, positionXSelected: $positionXSelected)
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        private let selectionFeedback = UISelectionFeedbackGenerator()
        private var lastIndexHighlighted: Double?
        @Binding var shouldAnimate: Bool
        @Binding var hideHighlight: Bool
        @Binding var indexSelected: Int
        @Binding var positionXSelected: CGFloat
        
        
        init(shouldAnimate: Binding<Bool>, hideHighlight: Binding<Bool>, indexSelected: Binding<Int>, positionXSelected: Binding<CGFloat>) {
            _shouldAnimate = shouldAnimate
            _hideHighlight = hideHighlight
            _indexSelected = indexSelected
            _positionXSelected = positionXSelected
        }
        
        @objc func handleGesture(_ gesture: UIGestureRecognizer) {
            if let chartView = gesture.view as? LineChartView {
                if gesture.state == .ended || gesture.state == .cancelled {
                    chartView.highlightValue(x: 0.0, dataSetIndex: -1)
                } else {
                    let position = gesture.location(in: chartView)
                    let highlight = chartView.getHighlightByTouchPoint(position)
                    
                    chartView.highlightValue(highlight, callDelegate: true)
                }
            }
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            if self.lastIndexHighlighted != entry.x {
                
                self.selectionFeedback.selectionChanged()
                DispatchQueue.main.async {
                    self.shouldAnimate = false
                    self.hideHighlight = false
                    self.indexSelected = Int(entry.x)
                    self.positionXSelected = chartView.convert(CGPoint(x: highlight.xPx, y: 0), to: chartView.superview).x
                    self.lastIndexHighlighted = entry.x
                }
            }
        }

        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            self.hideHighlight = true
            self.lastIndexHighlighted = nil
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        return LineChart(entries: [ChartDataEntry(x: 0, y: 0)], months: 10, hideHighlight: .constant(true), indexSelected: .constant(0), positionXSelected: .constant(.zero))
    }
}
