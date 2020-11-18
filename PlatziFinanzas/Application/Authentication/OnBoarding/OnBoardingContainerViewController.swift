//
//  OnBoardingContainerViewController.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 1/31/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

class OnBoardingContainerViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        if segue.identifier == "goToSignIn" {
            UserDefaults.standard.set(true, forKey: "WatchedOnboarding")
            UserDefaults.standard.synchronize()
            return
        }
        // Pass the selected object to the new view controller.
        guard segue.identifier == "openOnBoarding",
        let destination = segue.destination as? OnBoardingViewController
        else{
            return
        }
        
        destination.pageControl = pageControl
    }
}
