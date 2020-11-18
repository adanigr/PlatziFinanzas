//
//  SignInViewController.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/6/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    

    private var signInViewModel = SignInViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        signInViewModel.authWithAccountKit(sender: self) { (succes, error) in
//
//        }
    }
    
    @IBAction func authWithTextMessage(_ sender: Any){
        signInViewModel.authWithAccountKit(sender: self) { (succes, error) in

        }
    }
    
    @IBAction func authWithTwitter(_ sender: Any){
        SignInViewModel.authWithTwitter { [weak self] (success, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            if success {
                self?.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
    }
    
    @IBAction func authWithGoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.signIn()
        
        SignInViewModel.authWithGoogle() { [weak self] (success, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self?.present(alert, animated: true, completion: nil)
                return
            }

            if success {
                self?.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
    }
    
    @IBAction func authWithFacebook(_ sender: Any) {
        
        SignInViewModel.authWithFacebook(viewController: self) { [weak self] (success, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            if success {
                self?.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
////***********************************************************************
//// valindado y autenticando de la forma corecta  Model View, View Model
////***********************************************************************

        SignInViewModel.signInWith(
            email: emailTextField.text,
            password: passwordTextField.text
        ) { [weak self] (success, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            if success {
                self?.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
        
////***********************************************************************
//// valindado cajas de texto de una forma para principiantes
////***********************************************************************
//        //Validete empty textfield
//        guard let email = emailTextField.text else {
//            return
//        }
//
//        let range = NSRange(location: 0, length: email.count)
//        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: [])
//        let validation = regex?.firstMatch(in: email, options: [], range: range)
//
//        if validation == nil{
//            return
//        }
//
//        //Validete empty textfield
//        guard let password = passwordTextField.text else {
//            return
//        }
//
//        let rangePassword = NSRange(location: 0, length: password.count)
////        ^(?=.[A-Z].[A-Z])(?=.[!@#$&])(?=.[0-9].[0-9])(?=.[a-z].[a-z].[a-z]).{8}$
////        Regex Explanation : -
////        ^ Start anchor
////        (?=.[A-Z].[A-Z]) Ensure string has two uppercase letters.
////        (?=.[!@#$&]) Ensure string has one special case letter.
////        (?=.[0-9].[0-9]) Ensure string has two digits.
////        (?=.[a-z].[a-z].[a-z]) Ensure string has three lowercase letters.
////        .{8} Ensure string is of length 8.
////        $ End anchor.
//        //AA.22aaa
//        let regexPassword = try? NSRegularExpression(pattern: "^(?=.[A-Z].[A-Z])(?=.[!@#$&])(?=.[0-9].[0-9])(?=.[a-z].[a-z].[a-z]).{8}$", options: [])
//        let validationPassword = regexPassword?.firstMatch(in: password, options: [], range: rangePassword)
//
//        if validationPassword == nil{
//            return
//        }
//
//        print(email, password)
        
////***********************************************************************
//// validando y autenticando en el mismo evento
////***********************************************************************
//
//        guard let email = emailTextField.text,
//            validate(text: email, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") else {
//                return
//        }
//        //Pass Platzi23*
//        guard let password = passwordTextField.text,
//            validate(text: password, regex: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$^+=!*()@%&]).{8,}$") else {
//                return
//        }
//        // [weak self] garantisamos que si no existen los datos en memoria no se crase la app
//
////        Auth.auth().signIn(withEmail: <#T##String#>, password: <#T##String#>) { (<#AuthDataResult?#>, <#Error?#>) in
////            <#code#>
////        }
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
//            if let error = error {
//                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                alert.addAction(ok)
//                self?.present(alert, animated: true, completion: nil)
//                return
//            }
//
//            if result != nil {
//                self?.performSegue(withIdentifier: "goToMain", sender: self)
//            }
//        }
    }
//
//    private func validate(text: String, regex: String) -> Bool {
//        let range = NSRange(location: 0, length: text.count)
//        let regex = try? NSRegularExpression(pattern: regex)
//        return regex?.firstMatch(in: text, options: [], range: range) != nil
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
