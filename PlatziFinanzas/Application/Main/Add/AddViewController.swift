//
//  AddViewController.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/17/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var transactionNameLabel: UITextField!
    @IBOutlet weak var transactionDescriptionLabel: UITextField!
//    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var amt: Int = 0
    var isFirstTime = true
    //Get intance model for view
    private var viewModel = AddTransactionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround() 
        //focus
        //valueTextField.becomeFirstResponder()
        
        valueTextField.delegate = self //as? UITextFieldDelegate
        //valueTextField.placeholder = updateAmount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        transactionNameLabel.text = ""
        transactionDescriptionLabel.text = ""
        valueTextField.text = ""
        amt = 0
        //valueTextField.delegate = self as? UITextFieldDelegate
        valueTextField.placeholder = updateAmount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose  of any resources than can be recreated
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        isFirstTime = false
//        if textField.text == "0" {
//            textField.text = ""
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text!.isEmpty {
//            textField.text = "0"
//            isFirstTime = true
//        }
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let digit = Int(string){
            amt = amt * 10 + digit
            valueTextField.text = updateAmount()
        }
        
        if string == ""{
            amt = amt / 10
            valueTextField.text = updateAmount()
        }
        
        return false
    }
    
    func updateAmount() -> String? {
        let formatter = NumberFormatter()
        
        formatter.locale = Locale.current
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencySymbol = Locale.current.currencySymbol//"$"
        formatter.decimalSeparator = Locale.current.decimalSeparator//","
        
        let amount = Double(amt / 100) + Double(amt % 100) / 100
        return formatter.string(from: NSNumber(value: amount))
    }
    
    func removeFormatAmount(string:String) -> NSNumber{
        let formatter = NumberFormatter()
        // specify a locale where the decimalSeparator is a comma
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.currencySymbol = Locale.current.currencySymbol//"$"
        formatter.decimalSeparator = Locale.current.decimalSeparator//","
        return formatter.number(from: string) ?? 0
    }
    
    @IBAction func addTransaction(_ sender: UIButton) {
        
        viewModel.add(
            name: transactionNameLabel.text ?? "new add",
            description: transactionDescriptionLabel.text ?? "",
            value: removeFormatAmount(string: valueTextField.text ?? "0.00")
        )
        
        valueTextField.resignFirstResponder()
        tabBarController?.selectedIndex = 0
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
