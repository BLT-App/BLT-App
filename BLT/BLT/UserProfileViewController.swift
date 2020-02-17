//
//  UserProfileViewController.swift
//  BLT
//
//  Created by DLG on 1/23/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import UIKit
import Charts
class UserProfileViewController: UIViewController
{
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var graphShadowView: UIView!
    
    @IBOutlet weak var graphContainerView: UIView!
    
    @IBOutlet weak var tasksCompletedChart: LineChart!
    
    func chartUpdate(){
        var trendData: [CGFloat] = [5, 2, 7, 8, 3, 5]
        tasksCompletedChart.clear()
        tasksCompletedChart.addLine(trendData)
        tasksCompletedChart.y.grid.count = 5
        
//        userDataChart.data = data
//        userDataChart.chartDescription?.text = "Tasks completed"
        
        //All other additions to this function will go here
        
        //This must stay at end of function
//        userDataChart.notifyDataSetChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading
        //the view, typically from a nib.
        prepareProfile()
        
        setupCards()
        
        chartUpdate()
        
    }
    
    func setupCards() {
        roundContainerView(cornerRadius: 20, view: containerView, shadowView: shadowView)
        addShadow(view: shadowView, color: UIColor.gray.cgColor, opacity: 0.2, radius: 10, offset: CGSize(width: 0, height: 5))
        roundContainerView(cornerRadius: 20, view: graphContainerView, shadowView: graphShadowView)
        addShadow(view: graphShadowView, color: UIColor.gray.cgColor, opacity: 0.2, radius: 10, offset: CGSize(width: 0, height: 5))
    }
    
    
    func prepareProfile(){
        //add colors and round corners
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 50
        
//        userDataChart.clipsToBounds = true
//        userDataChart.layer.cornerRadius = 25
//        userDataChart.backgroundColor = .gray
        
//        scrollView.layer.cornerRadius = 25
//        scrollView.backgroundColor = .lightGray
        
        
//        userNameLabel.clipsToBounds = true
//        userNameLabel.layer.cornerRadius = 5
//        userNameLabel.backgroundColor = .blue
        userNameLabel.text = "\(globalData.firstName) \(globalData.lastName)"
    }
}

extension UserProfileViewController {
    /**
     Creates a rounded container view.
     - parameters:
     - cornerRadius: The corner radius of the rounded container.
     - view: The UIView to round.
     - shadowView: The accompanying shadowView of the main view to round.
     */
    func roundContainerView(cornerRadius: Double, view: UIView, shadowView: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
        
        shadowView.layer.cornerRadius = CGFloat(cornerRadius)
        shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    /**
     Creates shadows for a view.
     - parameters:
     - view: The view to add a shadow to.
     - color: The color of the shadow.
     - opacity: The opacity of the shadow.
     - radius: The radius of the shadow.
     - offset: The offset of the shadow.
     */
    func addShadow(view: UIView, color: CGColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        view.layer.shadowColor = color
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
        view.layer.masksToBounds = false
    }
}
