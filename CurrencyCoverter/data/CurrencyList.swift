//
//  CurrencyList.swift
//  CurrencyCoverter
//
//  Created by 翰廷 姜 on 2019/5/11.
//  Copyright © 2019 Hanting. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers class CurrencyList: Object, Codable {
    dynamic var success: Bool = true
    dynamic var terms : String = ""
    dynamic var privacy: String = ""
    dynamic var fetchedTime : Double = 0.0
    var currencies: [String: String] = [:]
    var currenciesList : RealmSwift.List<CurrencyType> = List<CurrencyType>()
    
    private enum CodingKeys: String, CodingKey {
        case success
        case terms
        case privacy
        case currencies
    }
    override static func ignoredProperties() -> [String] {
        return ["currencies"]
    }
    func updateList(){
        currenciesList.removeAll()
        currencies.forEach { item in currenciesList.append(CurrencyType.init(name: item.key,fullname: item.value)) }
    }
    func updateCurrencies(){
        guard currenciesList.count != 0 else{
            return
        }
        currencies.removeAll()
        currenciesList.forEach{ item in currencies[item.name] = item.fullname}
    }
}

@objcMembers class CurrencyType : Object , Codable{
    dynamic var name : String = ""
    dynamic var fullname : String = ""
    
    convenience init(name : String, fullname: String){
        self.init()
        self.name = name
        self.fullname = fullname
    }
}
