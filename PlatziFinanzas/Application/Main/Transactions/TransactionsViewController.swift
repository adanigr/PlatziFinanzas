//
//  TransactionsViewController.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 1/31/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    
    fileprivate(set) lazy var emptyStateView: UIView = {
        guard let view = Bundle.main.loadNibNamed("EmptyState", owner: nil, options: [:])?.first as? UIView  else {
            return UIView()
        }
        return view
    }()
    
    //get instance of model data
    private var viewModel = TransactionViewModel()
    private var Actions = TransactionActions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self

        // Do any additional setup after loading the view.
        //Esta con codigo podemos enlazar el delegado o de forma grafica como lo es en este ejemplo
//        tableView?.delegate = self
//        tableView?.dataSource = self

        //detail video 35 BudgetView
//        Hicimos que nuestra tabla de Transactions fuera reutilizable volviéndola un .xib, usando después de creado el .xib tanto para el Budget como para Transactions, ya que ambas vistas contienen el mismo tipo de tabla.
        
        let cell = UINib(nibName: "TransactionCell", bundle: Bundle.main)
        tableView?.register(cell, forCellReuseIdentifier: "cell")
        
    }
    
    func animateTable(TableView: UITableView) {
        //TableView.reloadData()
        
        let cells = TableView.visibleCells
        let tableHeight: CGFloat = (TableView.bounds.size.height)
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionFlipFromLeft, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.animateTable(TableView: self.tableView!)
        
        if let index = self.tableView?.indexPathForSelectedRow{
            self.tableView?.deselectRow(at: index, animated: true)
            
            //!.cornerRadius = 27
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.animateTable(TableView: self.tableView!)
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

extension TransactionsViewController: TransactionViewModelDelegate{
    func reloadData() {
        tableView?.reloadData()
        self.animateTable(TableView: self.tableView!)
    }
}

extension TransactionsViewController: UITableViewDelegate {
    //Swipe cell left -> rigth
    //@available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = Actions.completeAction(at: indexPath, viewController: self)
        
        let configuration = UISwipeActionsConfiguration(actions: [complete])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
//        if editingStyle == .delete {
//            viewModel.remove(at: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: tableView.frame.size.height))
        backView.backgroundColor = UIColor(red: 239/255.0, green: 34/255.0, blue: 91/255.0, alpha: 1.0)
        
        let frame = tableView.rectForRow(at: indexPath)
        
        
        let myImage = UIImageView(frame: CGRect(x: 20, y: frame.size.height/2-20, width: 36, height: 36))
        myImage.image = UIImage(named: "Trash")!
        backView.addSubview(myImage)
        
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { [weak self] /* [weak self] for memory management */(action, index) in
            self?.viewModel.remove(at: index)
            tableView.deleteRows(at: [index], with: UITableView.RowAnimation.fade)
        }
        
        //deleteAction.backgroundColor = UIColor(patternImage: newImage)
        //deleteAction.backgroundColor = UIColor(patternImage: UIImage(named: "Google")!)
        
        return [deleteAction]
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let count = 0
        //Get number of rows for dataRows
        let count = viewModel.numberOfItems
        tableView.backgroundView = count == 0 ? emptyStateView : nil
        tableView.separatorStyle = count == 0 ? .none : .singleLine
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellTableViewCell else {
            return UITableViewCell()
        }
        
        //Add icon for row
        //cell.accessoryType = .detailButton
        
        //cell.layer.cornerRadius = 20
        //cell.backgroundColor = UIColor.gray
        //cell.clipsToBounds = true
        //cell.swipeBackgroundColor = UIColor.gray
        
        cell.cellViewModel = viewModel.item(at: indexPath)

        
        return cell
    }
 }
