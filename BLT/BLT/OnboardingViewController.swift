//
//  OnboardingViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 4/20/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    var screens: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        for idx in 1...8 {
            screens.append(getPage("page\(idx)"))
        }
        
        setViewControllers([screens[0]], direction: .forward, animated: false, completion: nil)


        // Do any additional setup after loading the view.
    }
    
    func getPage(_ identifier: String) -> UIViewController {
        return storyboard!.instantiateViewController(withIdentifier: identifier)
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

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = screens.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard screens.count > previousIndex else {
            return nil
        }
        
        return screens[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = screens.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = vcIndex + 1
        
        guard screens.count > nextIndex else {
            return nil
        }
        
        return screens[nextIndex]

    }
    
    
}
