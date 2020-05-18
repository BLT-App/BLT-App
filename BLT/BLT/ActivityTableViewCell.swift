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
    
    var eventID: String? {
        didSet {
            let realm = realmManager.realm
            event = realm.object(ofType: DatabaseEvent.self, forPrimaryKey: eventID)
        }
    }
    
    var event: DatabaseEvent? {
        didSet {
            if event != nil {
                lblDescription.text = event?.eventText
                var numHour = (event?.date.currentCalendar.components.hour ?? 0) % 12
                let numMin = event?.date.currentCalendar.components.minute ?? 0
                var textMin = "\(numMin)"
                if numMin < 10 {
                    textMin = "0\(numMin)"
                }
                var indicator = "am"
                if event?.date.currentCalendar.components.hour ?? 0 >= 12 {
                    indicator = "pm"
                }
                if numHour == 0 {
                    numHour = 12
                }
                lblTime.text = "\(numHour):\(textMin) \(indicator)"
            }
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
