//
//  ActivityTableViewCell.swift
//  
//
//  Created by LorentzenN on 5/14/20.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var event: DatabaseEvent? {
        didSet {
            lblDescription.text = event?.eventText
            let numHour = (event?.date.currentCalendar.components.hour ?? 0) % 12
            let numMin = event?.date.currentCalendar.components.minute ?? 0
            var textMin = "\(numMin)"
            if numMin < 10 {
                textMin = "0\(numMin)"
            }
            var indicator = "am"
            if event?.date.currentCalendar.components.hour ?? 0 >= 12 {
                indicator = "pm"
            }
            lblTime.text = "\(numHour):\(textMin) \(indicator)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        event = DatabaseEvent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
