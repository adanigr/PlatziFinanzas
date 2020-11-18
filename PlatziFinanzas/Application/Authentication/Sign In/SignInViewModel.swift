//
//  SignInViewModel.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/6/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit

import Foundation
import FirebaseAuth
import FBSDKLoginKit
import TwitterKit
import GoogleSignIn
import AccountKit

typealias SignInHandler = ( (_ success: Bool, _ error: Error?) -> Void )

class SignInViewModel: NSObject {
    
//    init(googleCredentials : AuthCredential) {
//        self.googleCredentials = googleCredentials
//    }
    enum ErrorKind: Error {
        case internalError
    }
    
    private var handler: SignInHandler?
    
    static var Credentials : AuthCredential?
    
    static func signInWith(email: String?, password: String?, handler: SignInHandler?) {
        guard let email = email,
            validateRegularExpression(text: email, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") else {
                return
        }
        
        guard let password = password,
            validateRegularExpression(text: password, regex: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$^+=!*()@%&]).{8,}$") else {
                return
        }
        //Firebase authentication
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                handler?(false, error)
            }
            
            if result != nil {
                handler?(true, nil)
            }
        }
        
    }
    
    static private func validateRegularExpression(text: String, regex: String) -> Bool {
        let range = NSRange(location: 0, length: text.count)
        let regex = try? NSRegularExpression(pattern: regex)
        return regex?.firstMatch(in: text, options: [], range: range) != nil
    }
    
    static func authWithGoogle(handler: SignInHandler?){
        
        if SignInViewModel.Credentials != nil{
            //Firebase authentication
            Auth.auth().signInAndRetrieveData(with: SignInViewModel.Credentials!, completion: { (authResult, error) in
                
                if let error = error {
                    handler?(false, error)
                }
                
                handler?(true, nil)
            })
        }
        else{
        //handler?(false, ErrorKind.internalError)
        return
        }
        
    }
    
    static func authWithTwitter(handler: SignInHandler?) {
        
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            guard let session = session else{
                handler?(false,error)
                return
            }
            
            let authToken = session.authToken
            let authTokenSecret = session.authTokenSecret
            let credentials = TwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
            //Firebase authentication
            Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authResult, error) in
                
                if let error = error {
                    handler?(false, error)
                }
                
                handler?(true, nil)
            })
        }
    }
    
//    static func authWithFirebase(credentials: AuthCredential, handler: SignInHandler?){
//        //Firebase authentication
//        //Auth.auth().signInAndRetrieveData(with: <#T##AuthCredential#>, completion: <#T##AuthDataResultCallback?##AuthDataResultCallback?##(AuthDataResult?, Error?) -> Void#>)
//        Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authResult, error) in
//            if let error = error {
//                handler?(false, error)
//            }
//
//            if authResult != nil {
//                handler?(true, nil)
//            }
//        })
//    }
    
    static func authWithFacebook(viewController: UIViewController, handler: SignInHandler?) {
        //1.
        let loginManager = LoginManager()
        
        //2.
        let permissions = ["email"]
        //let permissions = ["public_profile"]
        //3.
        let handler = { (result: LoginManagerLoginResult!, error: Error?) in
            if let error = error {
                //3.1
                print("error = \(error.localizedDescription)")
            } else if result.isCancelled {
                //3.2
                print("user tapped on Cancel button")
            } else {
                //3.3
                print("authenticate successfully")
                //self.goToHomeViewController()
                //guard let accessToken = AccessToken.current?.tokenString else
                //guard let accessToken = AccessToken.current?.tokenString else { return }
                guard let accessToken = AccessToken.current?.tokenString else { return }
                let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken)
                //Firebase authentication
                Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authResult, error) in
                    if let error = error {
                        handler?(false, error)
                    }
                    
                    if authResult != nil {
                        handler?(true, nil)
                    }
                })
            }
        }
        
        //4.
        loginManager.logIn(permissions: permissions, from: viewController, handler: handler)
        
    }
//    static func facebookLogin(viewController: UIViewController, handler: SignInHandler?) {
//        LoginManager().logIn(withReadPermissions: ["email"], from: viewController) { (result, error) in
//            if let error = error {
//                handler?(false, error)
//                return
//            }
//
//            guard let token = FBSDKAccessToken.current()?.tokenString else { return }
//            let credentials = FacebookAuthProvider.credential(withAccessToken: token)
//            Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authResult, error) in
//
//                handler?(true, nil)
//            })
//        }
//    }
    
    func authWithAccountKit(sender: UIViewController, handler: SignInHandler?){
        let viewController = AccountKitManager(responseType: .accessToken).viewControllerForPhoneLogin() as AKFViewController
        
        self.handler = handler
        viewController.delegate = self
        
        guard let nomalViewController = viewController as? UIViewController else {
            return
        }
        
        sender.present(nomalViewController, animated: true, completion: nil)
    }
}

extension SignInViewModel: AKFViewControllerDelegate{
    func viewController(_ viewController: (UIViewController & AKFViewController), didCompleteLoginWith accessToken: AKFAccessToken, state: String) {
        
        let token = accessToken.tokenString
        
        //let baseUrl = URL(string: "http://localhost:5000/platzi-finanzas-c77f4/us-central1/")
        let baseUrl = URL(string: "https://us-central1-platzi-finanzas-c77f4.cloudfunctions.net/")
        
        //concatenamos baseurl con token
        guard let url = URL(string: "accountkit?access_token=\(token)", relativeTo: baseUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            
            if let error = error {
                self?.handler?(false, error)
                return
            }
            
            guard let data = data else { return }
            
            guard let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String : Any]??) else { return }
            
            guard let jsonToken = json?["token"] as? String else { return }
            
            //Firebase authentication
            Auth.auth().signIn(withCustomToken: jsonToken, completion: { (authResult, error) in
                if let error = error {
                    self?.handler?(false, error)
                }
                
                if authResult != nil {
                    self?.handler?(true, nil)
                }
            })
        }
        task.resume()
        /*//autenticasion por sms con account kit de facebook
        let accountKit = AKFAccountKit(responseType: .accessToken)
        
        accountKit.requestAccount { [weak self] (account, error) in
            
            if let error = error {
                self?.handler?(false, error)
                return
            }
            
            guard let phoneNumberUser = account?.phoneNumber?.phoneNumber
                else { return }
            print("mi telefono", phoneNumberUser)
            self?.handler?(true, nil)
         
 
        }*/
    }
}
