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
import RealmSwift

/// View controller class for the User Profile page.
class UserProfileViewController: UIViewController
{
    /// Label for the name of the user.
    @IBOutlet weak var userNameLabel: UILabel!
    /// UIImageView for the image of the user.
    @IBOutlet weak var userImage: UIImageView!
    /// Shadow view of the main card.
    @IBOutlet weak var shadowView: UIView!
    /// Container for the main card.
    @IBOutlet weak var containerView: UIView!
    /// Shadow view for the graph.
    @IBOutlet weak var graphShadowView: UIView!
    /// Container for the graph.
    @IBOutlet weak var graphContainerView: UIView!
    /// Chart that lists number of tasks completed.
    @IBOutlet weak var tasksCompletedChart: LineChart!
    /// Label for streak counter.
    @IBOutlet weak var streakLabel: UILabel!
    /// Label for number of completed item counter.
    @IBOutlet weak var completedLabel: UILabel!
    /// Label for number of hours focused.
    @IBOutlet weak var focusLabel: UILabel!
    
    var totalFocusHours: Double {
        var minutes = 0.0
        for item in myToDoList.allToDoItems {
            minutes += item.timeSpentInFocusMode
        }
        
        var hours: Double = (minutes / 6).rounded() / 10
        if hours > 10 {
            hours = hours.rounded()
        }
        return hours
    }

	/// Updates the chart from the globalTaskDatabase.
    func chartUpdate() {
        var trendData: [CGFloat] = []
        
        var previousDayTotal: Int = 0
        for day in 1...7 {
            var numEventsCompletedOnDay = 0
            print("This Method Is Broken")
            print("Tasks completed on day \(day): \(numEventsCompletedOnDay - previousDayTotal)")
            trendData.append(CGFloat(numEventsCompletedOnDay - previousDayTotal))
            previousDayTotal = numEventsCompletedOnDay
        }
        
        // Example data for the trend. 
        trendData = [5, 2, 7, 8, 3, 5, 6]
        
        tasksCompletedChart.clear()
        tasksCompletedChart.addLine(trendData)
        tasksCompletedChart.y.grid.count = 7
    }

    /// Runs when the view did finish loading.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading
        //the view, typically from a nib.
        prepareProfile()
        chartUpdate()
        setupCards()
        updateUserStats()
        
    }

	  /// Runs when the view has appeared.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartUpdate()
        
    }
    
    ///Updates The User Stats Bar By Calculating From Databases
    func updateUserStats(){
        ///TODO: Calculate Stats Dynamically
        
        focusLabel.text = String(totalFocusHours)
        
        completedLabel.text = String(myToDoList.completedList.count)
    }
  
    /// Sets up UI appearance of cards.
    func setupCards() {
        roundContainerView(cornerRadius: 20, view: containerView, shadowView: shadowView)
        addShadow(view: shadowView, color: UIColor.gray.cgColor, opacity: 0.2, radius: 10, offset: CGSize(width: 0, height: 5))
        roundContainerView(cornerRadius: 20, view: graphContainerView, shadowView: graphShadowView)
        addShadow(view: graphShadowView, color: UIColor.gray.cgColor, opacity: 0.2, radius: 10, offset: CGSize(width: 0, height: 5))
    }
    
    /// Prepares profile name text and image.
    func prepareProfile(){
        //add colors and round corners
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 50
        
        userNameLabel.text = "\(globalData.firstName) \(globalData.lastName)"
    }
}

/// Extension that contains the graphical functions.
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
