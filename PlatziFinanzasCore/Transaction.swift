//
//  Transaction.swift
//  PlatziFinanzasCore
//
//  Created by Adan Reséndiz on 2/7/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import Foundation

public enum TransactionCategory: Int {
    case earn, expend
}

extension TransactionCategory: Codable { }

public class Transaction: Codable {

    public var firebaseId: String?
    public var uuid = UUID()
    public var value: Float
    public var category: TransactionCategory
    public var name: String
    public var description: String
    public var date: Date
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid" //esto es igual a hacer refrencia a las propiedaes puede o no ir
        case value
        case category
        case name
        case description
        case date
    }
    
    public init(value: Float, category: TransactionCategory, name: String, description: String, date: Date) {
        self.value = value
        self.category = category
        self.name = name
        self.description = description
        self.date = date
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        uuid = try container.decode(UUID.self, forKey: .uuid)
        value = try container.decode(Float.self, forKey: .value)
        category = try container.decode(TransactionCategory.self, forKey: .category)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    public func data() -> [String: Any]?{
        let jsonEncoder = JSONEncoder()
        
        guard let data = try? jsonEncoder.encode(self) else {
            return nil
        }
        
        guard let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String : Any]??) else {
            return nil
        }
        
        return json
    }
}

extension Transaction: Hashable {
    public static func == (lhs: Transaction, rhs: Transaction) -> Bool{
        return lhs.uuid == rhs.uuid
    }
    
//    in swift 4.2
//    public var hashValue: Int {
//        return uuid.hashValue
//    }
    
//    in swift 5
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid.hashValue)
    }
}
