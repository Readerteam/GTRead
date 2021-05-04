//
//  SwiftUIView.swift
//  GTRead
//
//  Created by Dev on 2021/4/23.
//

import SwiftUI
import Charts

struct GTAnalyseView: View {
    var body: some View {
        VStack(spacing: 30.0) {
            VStack(alignment: .center, spacing: 20.0) {
                HStack(alignment: .bottom) {
                    Text("3")
                        .font(.system(size: 120, weight: .light, design: .serif))
                        .foregroundColor(Color.white)
                    Text("小时")
                        .font(.system(size: 30, weight: .light, design: .serif))
                        .foregroundColor(Color.white)
                }
                .frame(height: 200)
                
                BarChart(entries: [
                    BarChartDataEntry(x: 0, y: 1),
                    BarChartDataEntry(x: 1, y: 2),
                    BarChartDataEntry(x: 2, y: 3),
                    BarChartDataEntry(x: 3, y: 4),
                    BarChartDataEntry(x: 4, y: 5),
                    BarChartDataEntry(x: 5, y: 6),
                    BarChartDataEntry(x: 6, y: 7),
                    BarChartDataEntry(x: 7, y: 8),
                    BarChartDataEntry(x: 8, y: 9),
                    BarChartDataEntry(x: 9, y: 10)
                ])
                .frame(height: 150.0)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(20)
            
            Section(header: Text("阅读速度")) {
                LineChart (entries: [
                    ChartDataEntry(x: 1, y: 1),
                    ChartDataEntry(x: 2, y: 4),
                    ChartDataEntry(x: 3, y: 7),
                    ChartDataEntry(x: 4, y: 2),
                    ChartDataEntry(x: 5, y: 9),
                    ChartDataEntry(x: 6, y: 2.3),
                    ChartDataEntry(x: 7, y: 4.2),
                    ChartDataEntry(x: 8, y: 2),
                    ChartDataEntry(x: 9, y: 5),
                    ChartDataEntry(x: 10, y: 6)
                ])
                .frame(height: 300)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20.0)
    }
}

// 柱状图
struct BarChart : UIViewRepresentable {
    typealias UIViewType = BarChartView
    
    //Bar chart accepts data as array of BarChartDataEntry objects
    var entries : [BarChartDataEntry]
    let xValues = ["00:00", "06:00", "12:00", "18:00", "23:59"]
    // this func is required to conform to UIViewRepresentable protocol
    func makeUIView(context: Context) -> BarChartView {
        //crate new chart
        let chart = BarChartView()
        //it is convenient to form chart data in a separate func
        chart.data = addData()
        // 不绘制网格线
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        // x轴的位置
        chart.xAxis.labelPosition = .bottom
        //不绘制右边轴
        chart.rightAxis.enabled = false
        // 自定义x轴刻度
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        // 不显示y轴和x轴
        chart.xAxis.enabled = false
        chart.leftAxis.enabled = false
        // 不显示图例说明
        chart.legend.enabled = false
        
        return chart
    }
    
    // this func is required to conform to UIViewRepresentable protocol
    func updateUIView(_ uiView: BarChartView, context: Context) {
        //when data changes chartd.data update is required
        uiView.data = addData()
    }
    
    func addData() -> BarChartData{
        let data = BarChartData()
        //BarChartDataSet is an object that contains information about your data, styling and more
        let dataSet = BarChartDataSet(entries: entries)
        // change bars color to green
        dataSet.colors = [NSUIColor.green]
        //change data label
        dataSet.label = "My Data"
        data.addDataSet(dataSet)
        
        return data
    }
}

// 折线图
struct LineChart : UIViewRepresentable {
    typealias UIViewType = LineChartView
    
    var entries : [ChartDataEntry]
    
    func makeUIView(context: Context) -> LineChartView {
        //crate new chart
        let chart = LineChartView()
        //it is convenient to form chart data in a separate func
        chart.data = addData()
        // 不绘制网格线
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        // x轴的位置
        chart.xAxis.labelPosition = .bottom
        //不绘制右边轴
        chart.rightAxis.enabled = false
        
        return chart
    }
    
    // this func is required to conform to UIViewRepresentable protocol
    func updateUIView(_ uiView: LineChartView, context: Context) {
        //when data changes chartd.data update is required
        uiView.data = addData()
    }
    
    func addData() -> LineChartData{
        let data = LineChartData()
        
        let dataSet = LineChartDataSet(entries: entries)
        // change bars color to green
        dataSet.colors = [NSUIColor.green]
        //change data label
        dataSet.label = "My Data"
        data.addDataSet(dataSet)
        
        return data
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GTAnalyseView()
    }
}
