//
//  FocusCardCell.swift
//  BLT
//
//  Created by Jiahua Chen on 2/29/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import UIKit
import VerticalCardSwiper

/// Card in focus mode stacks. 
class FocusCardCell: CardCell {
    /// Label of the class.
    @IBOutlet weak var classLabel: UILabel!
    /// Label of the assignment.
    @IBOutlet weak var assignmentLabel: UILabel!
    /// Label of the description
    @IBOutlet weak var descriptionLabel: UILabel!
    /// Background color of the class label.
    @IBOutlet weak var classBackground: UIView!

    /// Lays out the subviews.
    override func layoutSubviews() {
        classBackground.layer.cornerRadius = 15
        classBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addShadow(view: self, color: UIColor.gray.cgColor, opacity: 0.2, radius: 10, offset: CGSize(width: 0, height: 5))
        self.layer.cornerRadius = 15
        super.layoutSubviews()
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

    /// Sets up the card according to a ToDoitem.
    /// - Parameter item: ToDoItem to set up card from.
    func setupCard(fromItem item: ToDoItem) {
        classLabel.text = item.className
        assignmentLabel.text = item.title
        descriptionLabel.text = item.description
        if let subjectColor = globalData.subjects[item.className]?.uiColor {
            classBackground.backgroundColor = subjectColor
        }
    }
    
}
