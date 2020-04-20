//
//  BeginViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 4/20/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit

class BeginViewController: UIViewController {

    @IBOutlet weak var beginButton: UIButton!
    
    weak var delegate: OnboardingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beginButton.layer.cornerRadius = 25.0
        beginButton.layer.shadowOpacity = 0.2
        beginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        beginButton.layer.shadowRadius = 5.0
        beginButton.layer.shadowColor = UIColor.gray.cgColor
        beginButton.layer.masksToBounds = false
        beginButton.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    func passDelegate(_ delegate: OnboardingViewController) {
        self.delegate = delegate
    }
    
    @IBAction func begin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
