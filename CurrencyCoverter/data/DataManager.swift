//
//  DataManager.swift
//  CurrencyCoverter
//
//  Created by 翰廷 姜 on 2019/5/11.
//  Copyright © 2019 Hanting. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager{
    
    public static let shared = DataManager()
    
    private let OutOfDateTime : Double = 60
    
    let realm = try! Realm()
    
    func loadCurrency(source: String, completionHandler: @escaping ((_ currency : Currency) -> Void)) {
        let c = realm.objects(Currency.self).filter("source == '\(source)'").first
        if c != nil{
            let currency = c!
            print("Found \(source) data in local")
            let now = Date.init()
            let duration = now.timeIntervalSince(Date.init(timeIntervalSince1970: TimeInterval(currency.fetchedTime)))
            if duration > OutOfDateTime{
                print("Out of date")
                try! self.realm.write {
                    self.realm.delete(currency)
                }
            }else{
                print("Good")
                currency.updateQuotes()
                completionHandler(currency)
                return
            }
        }
        CurrencyAPI.shared.fetchCurrency(source: source){
            result in
            result.updateList()
            result.fetchedTime = Date.init().timeIntervalSince1970
            try! self.realm.write {
                self.realm.add(result)
            }
            completionHandler(result)
        }
    }
    
    func loadCurrencyList(completionHandler: @escaping ((_ currencyList : CurrencyList) -> Void)){
        let cList = realm.objects(CurrencyList.self).first
        if cList != nil{
            let currenicesList = cList!
            print("Found CurrenciesList in local")
            let now = Date.init()
            let duration = now.timeIntervalSince(Date.init(timeIntervalSince1970: TimeInterval(currenicesList .fetchedTime)))
            if duration > OutOfDateTime{
                print("Out of date")
                try! self.realm.write {
                    self.realm.delete(currenicesList)
                }
            }else{
                print("Good")
                currenicesList.updateCurrencies()
                completionHandler(currenicesList)
                return
            }
        }
        CurrencyAPI.shared.fetchCurrencyList{
            result in
            result.updateList()
            result.fetchedTime = Date.init().timeIntervalSince1970
            try! self.realm.write {
                self.realm.add(result)
            }
            completionHandler(result)
        }
    }
}
