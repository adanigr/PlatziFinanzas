//
//  TransactionViewModel.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/14/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import Foundation
import FirebaseFirestore
import PlatziFinanzasCore
import FirebaseAuth

protocol TransactionViewModelDelegate {
    func reloadData()
}   

class TransactionViewModel {
    private var items: [PlatziFinanzasCore.Transaction] = []
    private var db:  Firestore{
        let db = Firestore.firestore()
        let settings = db.settings
        //para guardar fecha y hora de modificaciones
        //settings.areTimestampsInSnapshotsEnabled = true
        settings.areTimestampsInSnapshotsEnabled = true
        //Para poder guardar cache y mostrar info antes de traerla de internet
        settings.isPersistenceEnabled = true
        // set new db settings
        db.settings = settings
        
        return db
    }
    
    // set count items
    var numberOfItems : Int{
        return items.count
    }
    
    var delegate: TransactionViewModelDelegate?
    
    init() {
        getData()
        NotificationCenter.default.addObserver(self /* place where the observer will be */, selector: #selector(getData), name: Notification.Name("AddedNewData"), object: nil)
    }
    
    @objc private func getData() {
        // get Id owner a db
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Get documents from table transactions in db firebase firestore
        //db.collection("transactions").getDocuments { [weak self] (snapshot, error) in
        //Firestore cuenta con realtime y es bastante fácil de implementar, solamente debemos cambiar el método de getDocuments por addSnapshotListener. and sort
        db.collection("transactions")
            .whereField("ownerId", isEqualTo: uid)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] (snapshot, error) in
                
                //We verify that the class to be instantiated is still in memory
                guard let self = self else { return }
                
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                self.items.removeAll()
                
                ((try? snapshot?.documents.forEach({ (snapshot) in
                    let json = snapshot.data()
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    guard let transaction = try? JSONDecoder().decode(PlatziFinanzasCore.Transaction.self, from: jsonData) else{
                        return
                    }
                    
                    transaction.firebaseId = snapshot.documentID
                    
                    self.items.append(transaction)
                })) as ()??)
                self.delegate?.reloadData()
        }
    }
    
    func item(at indexPath: IndexPath) -> CellViewModel {
        return CellViewModel(cellInfo: items[indexPath.row])
    }
    
    func remove(at indexPath: IndexPath) {
        //delete item for items collection
        let item = self.items.remove(at: indexPath.row)
        //get db id
        guard let firebaseId = item.firebaseId else {
            return
        }
        db.collection("transactions").document(firebaseId).delete()
        
        // reload info in case not connected a database
        //delegate?.reloadData()
    }
}
