//
//  UserProfileViewController.swift
//  BLT
//
//  Created by Student on 1/23/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import UIKit
 
class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBOutlet weak var GraphView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading
        //the view, typically from a nib.
        UserImage.clipsToBounds = true;
        UserImage.layer.cornerRadius = 100;
        
    }
    
    
    
    
}
