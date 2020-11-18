//
//  CellViewModel.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/19/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import Foundation
import PlatziFinanzasCore

class CellViewModel {
    
    private var cell: PlatziFinanzasCore.Transaction
    
    var name: String{
        return cell.name
    }
    
    var description: String{
        return cell.description
    }
    
    var value: String{
        return cell.value.toCurrency()
    }
    
    var date: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: cell.date)
    }
    
    var time: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: cell.date)
    }
    
    init(cellInfo: PlatziFinanzasCore.Transaction) {
        self.cell = cellInfo
    }
}
