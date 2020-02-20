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
    
    @IBOutlet weak var streakLabel: UILabel!
    
    @IBOutlet weak var completedLabel: UILabel!
    
    @IBOutlet weak var focusLabel: UILabel!
    
    func chartUpdate() {
        var trendData: [CGFloat] = []
        
        var previousDayTotal: Int = 0
        for day in 1...7 {
            var numEventsCompletedOnDay = 0
            numEventsCompletedOnDay += globalTaskDatabase.getNumEventsOfTypeInLast(numDays: day, eventType: .markedCompletedInListView)
            numEventsCompletedOnDay += globalTaskDatabase.getNumEventsOfTypeInLast(numDays: day, eventType: .markedCompletedInFocusMode)
            numEventsCompletedOnDay -= globalTaskDatabase.getNumEventsOfTypeInLast(numDays: day, eventType: .unmarkedComplete)
            print("Tasks completed on day \(day): \(numEventsCompletedOnDay - previousDayTotal)")
            trendData.append(CGFloat(numEventsCompletedOnDay - previousDayTotal))
            previousDayTotal = numEventsCompletedOnDay
        }
        
        // Example data for the trend. 
        //trendData = [5, 2, 7, 8, 3, 5, 6]
        
        tasksCompletedChart.clear()
        tasksCompletedChart.addLine(trendData)
        tasksCompletedChart.y.grid.count = 7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading
        //the view, typically from a nib.
        prepareProfile()
        chartUpdate()
        setupCards()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
