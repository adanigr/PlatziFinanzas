//
//  OnBoardingViewController.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 1/31/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

struct OnBoardingItem{
    let title: String
    let description: String
    let imageName: String
}



class OnBoardingViewController: UIPageViewController {
    
    var pageControl: UIPageControl?
    
    fileprivate(set) lazy var items: [OnBoardingItem] = {
        return [
            OnBoardingItem(
                title: "Save money and reduce debit",
                description: "Press the start button",
                imageName: "OnBoarding1"
            ),
            OnBoardingItem(
                title: "You're finished onboarding",
                description: "Press the start button",
                imageName: "OnBoarding2"
            )
        ]
    }()
    
    
    fileprivate(set) lazy var contentViewController: [UIViewController] = {
      var items = [UIViewController]()
        for i in 0 ..< self.items.count{
            items.append(self.instantiateViewController(i))
        }
        
        return items
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        dataSource = self
        
        pageControl?.numberOfPages = items.count
        updateContainerView(stepNumber: 0)
    }
    
//    func updateContainerView(stepNumber index: Int) {
//        setViewControllers(contentViewController[index], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
//    }
    
    func updateContainerView(stepNumber index: Int) {
        setViewControllers([contentViewController[index]], direction: .forward, animated: true, completion: nil)
    }
    
    func instantiateViewController(_ index:Int) ->  UIViewController {
        guard let viewController = UIStoryboard(name: "OnBoarding", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnBoardingSteps") as? OnBoardingStepsViewController else {
            return UIViewController()
        }
        
        viewController.item = items[index]
        return viewController
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

extension OnBoardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = contentViewController.firstIndex(of: viewController)
        if index == 0 {
            return nil
        }
        return contentViewController[index! + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = contentViewController.firstIndex(of: viewController)
        if index == contentViewController.count - 1 {
            return nil
        }
        return contentViewController[index! + 1]
    }
}

extension OnBoardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        
        guard let index = contentViewController.firstIndex(of: viewControllers!.first!) else {
            return
        }
        
        pageControl?.currentPage = index
    }
}
