//
//  ChartsViewController.swift
//  Expense Manager
//
//  Created by Muskan on 21/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let categories = DBManager.shared.loadExpenseCat()
                
                var expenseArray = [Int32]()
                var catArray = [String]()
                
                for i in 1...(categories?.count)! {
                    
                    let totalCatExpense = DBManager.shared.returnCatSum(id: Int32(i))
                    
                    expenseArray.append(totalCatExpense)
                    
                
                    let cat = DBManager.shared.returnCat(for: Int32(i))
                    catArray.append(cat)
                
                }
                
                customizeChart(dataPoints: catArray, values: expenseArray.map{ Double($0) })
        
        
        
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
    
        // 1. Set ChartDataEntry
          var dataEntries: [ChartDataEntry] = []
          for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
          }
          // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
          pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
          // 3. Set ChartData
          let pieChartData = PieChartData(dataSet: pieChartDataSet)
          let format = NumberFormatter()
          format.numberStyle = .none
          let formatter = DefaultValueFormatter(formatter: format)
          pieChartData.setValueFormatter(formatter)
          // 4. Assign it to the chart’s data
          pieChart.data = pieChartData

    
    
    
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
}
