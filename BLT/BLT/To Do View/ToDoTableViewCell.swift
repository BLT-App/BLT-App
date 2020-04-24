//
//  ToDoTableViewCell.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit
import gooey_cell

/// TableView Cell for individual to-do items.
class ToDoTableViewCell: GooeyEffectTableViewCell {

	/// Label of the class.
	@IBOutlet weak var classLabel: UILabel!

	/// Label of the name of the assignment.
	@IBOutlet weak var assignmentLabel: UILabel!

	/// Label of the description.
	@IBOutlet weak var descLabel: UILabel!

	/// Label of the due date.
	@IBOutlet weak var dueLabel: UILabel!

	/// View of the item.
	@IBOutlet weak var itemView: UIView!

	/// Wrapper to enable a blur.
	@IBOutlet weak var blurEffectView: UIView!

	/// When cell is being drawn.
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code

		classLabel.sizeThatFits(CGSize(width: classLabel.frame.size.width, height: 30))
		classLabel.layer.cornerRadius = 11.0
		classLabel.clipsToBounds = true

		itemView.layer.cornerRadius = 20.0
		itemView.layer.shadowColor = UIColor.gray.cgColor
		itemView.layer.shadowOpacity = 0.2
		itemView.layer.shadowOffset = CGSize(width: 0, height: 4)
		itemView.layer.shadowRadius = 5.0
		itemView.layer.masksToBounds = false
	}

	/// Changes the view when selected.
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

	/**
	 Configures the ToDoTableViewCell to a specific ToDoItem.
	 - parameters:
		- item: The ToDoItem that this TableViewCell will be representing.
	 */
	func setItem(item: ToDoItem) {
		classLabel.text = item.className
		if let classColor = globalData.subjects[item.className]?.uiColor {
			classLabel.backgroundColor = classColor
		}
		assignmentLabel.text = item.title
		descLabel.text = item.assignmentDescription
        dueLabel.text = item.getDueString()
	}
}

/// A type of label that is inset so there is additional space to the sides of the text. Allows for rounded background. 
class InsetLabel: UILabel {
	/// Top inset.
	let topInset = CGFloat(3.5)
	/// Bottom inset.
	let bottomInset = CGFloat(3.5)
	/// Left inset.
	let leftInset = CGFloat(7)
	/// Right inset.
	let rightInset = CGFloat(7)

	/// Draws text within the label.
	override func drawText(in rect: CGRect) {
		let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
		super.drawText(in: rect.inset(by: insets))
	}

	/// Changes intrinsic content size to include the insets.
	override public var intrinsicContentSize: CGSize {
		var intrinsicSuperViewContentSize = super.intrinsicContentSize
		intrinsicSuperViewContentSize.height += topInset + bottomInset
		intrinsicSuperViewContentSize.width += leftInset + rightInset
		return intrinsicSuperViewContentSize
	}
}

/// Blurs background of view.
class BlurView: UIView {
	/// Creates a blur layer on top of a view.
	override func awakeFromNib() {
		super.awakeFromNib()
		self.layer.cornerRadius = 20.0
		self.layer.masksToBounds = true

		let blurEffect = UIBlurEffect(style: .extraLight)
		let blurView = CustomIntensityVisualEffectView(effect: blurEffect, intensity: 0.3)
		blurView.frame = self.bounds
		blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		blurView.layer.masksToBounds = false
		self.insertSubview(blurView, at: 0)
	}
}
