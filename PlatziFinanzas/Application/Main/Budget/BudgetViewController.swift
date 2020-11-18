//
//  BudgetViewController.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/2/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var animationButtons: [UIButton]!
    @IBOutlet weak var animatonLayout: NSLayoutConstraint!
    
    fileprivate(set) lazy var emptyStateView: UIView = {
        guard let view = Bundle.main.loadNibNamed("EmptyStateBudget", owner: nil, options: [:])?.first as? UIView  else {
            return UIView()
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cell = UINib(nibName: "TransactionsCell", bundle: Bundle.main)
        tableView?.register(cell, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func animateHeader(sender: UIButton){
        
        animatonLayout.constant = sender.frame.origin.x
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            let test  = sender.frame.width
            print("test",test)
        }) { (completed) in
            self.animationButtons.forEach{
                $0.setTitleColor(UIColor(named: "TextColor"), for: .normal)
                sender.setTitleColor(UIColor.white, for: .normal)
            }
        }
        
        //UIView.animate(withDuration: 0.5, animations: <#T##() -> Void#>)
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

extension BudgetViewController: UITableViewDelegate {
    
}

extension BudgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = 10
        tableView.backgroundView = count == 0 ? emptyStateView : nil
//        tableView.separatorStyle = count == 0 ? .none : .singleLine
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}
