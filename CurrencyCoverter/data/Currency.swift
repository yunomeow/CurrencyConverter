//
//  Currency.swift
//  CurrencyCoverter
//
//  Created by 翰廷 姜 on 2019/5/11.
//  Copyright © 2019 Hanting. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers class Currency: Object, Codable {
    dynamic var success: Bool = false
    dynamic var terms : String = ""
    dynamic var privacy: String = ""
    dynamic var timestamp: Int = 0
    dynamic var source: String = ""
    dynamic var fetchedTime : Double = 0.0
    var quotes : [String : Double] = [:]
    var quotesList: RealmSwift.List<CurrencyRate> = List<CurrencyRate>()
    
    private enum CodingKeys: String, CodingKey {
        case success
        case terms
        case privacy
        case timestamp
        case source
        case quotes
    }
    override static func ignoredProperties() -> [String] {
        return ["quotes"]
    }
    func updateList(){
        quotesList.removeAll()
        quotes.forEach { item in quotesList.append(CurrencyRate.init(name: item.key,rate: item.value)) }
    }
    func updateQuotes(){
        guard quotesList.count != 0 else{
            return
        }
        quotes.removeAll()
        quotesList.forEach{ item in quotes[item.name] = item.rate}
    }
}

@objcMembers class CurrencyRate : Object, Codable{
    dynamic var name : String = ""
    dynamic var rate : Double = 0.0
    convenience init(name : String, rate : Double){
        self.init()
        self.name = name
        self.rate = rate
    }
}

