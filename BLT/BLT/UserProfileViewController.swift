//
//  UserProfileViewController.swift
//  BLT
//
//  Created by Student on 1/23/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import UIKit
import Charts
class UserProfileViewController: UIViewController
{
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var userDataChart: BarChartView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    func barChartUpdate(){
        var list: [BarChartDataEntry] = []
        for i in 0 ... 6{
            list.append(BarChartDataEntry(x: Double(i), y: Double(Int.random(in: 0..<10))))
        }
        
        let dataSet = BarChartDataSet(values: list, label: "Tasks completed")
        let data = BarChartData(dataSets: [dataSet])
        
        userDataChart.data = data
        userDataChart.chartDescription?.text = "Tasks completed"
        
        //All other additions to this function will go here
        
        //This must stay at end of function
        userDataChart.notifyDataSetChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading
        //the view, typically from a nib.
        prepareProfile()
        
        barChartUpdate()
        
    }
    
    
    func prepareProfile(){
        //add colors and round corners
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 50
        
        userDataChart.clipsToBounds = true
        userDataChart.layer.cornerRadius = 25
        userDataChart.backgroundColor = .gray
        
        scrollView.layer.cornerRadius = 25
        scrollView.backgroundColor = .lightGray
        
        label.backgroundColor = .blue
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        
        
        userNameLabel.clipsToBounds = true
        userNameLabel.layer.cornerRadius = 5
        userNameLabel.backgroundColor = .blue
        globalData.firstName = "Baku" //placeholder name
        userNameLabel.text = globalData.firstName
        
    }
    
    
    
    
    
    
    
}
