//
//  AddTransactionsViewModel.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/17/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import Foundation
import FirebaseFirestore
import PlatziFinanzasCore
import FirebaseAuth

class AddTransactionsViewModel{
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    func add(name: String, description: String, value: NSNumber) {
        
//        guard let floatValue = Float(truncating: value) else {
//            return
//        }
        // get Id owner a db
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let transaction = PlatziFinanzasCore.Transaction(
            value: Float(truncating: value),
            category: .expend,
            name: name,
            description: description,
            date: Date()
        )
        
        guard var data = transaction.data() else {
            return
        }
        
        // set Id owner a db
        data["ownerId"] = uid
        db.collection("transactions").addDocument(data: data) { (error) in
            print(error?.localizedDescription ?? "Object added")
            NotificationCenter.default.post(name: Notification.Name("AddedNewData"), object: nil)
        }
    }
}
