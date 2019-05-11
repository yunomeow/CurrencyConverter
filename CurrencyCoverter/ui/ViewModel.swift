//
//  ViewModel.swift
//  CurrencyCoverter
//
//  Created by 翰廷 姜 on 2019/5/10.
//  Copyright © 2019 Hanting. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel{
    let dataManager = DataManager.shared
    var currencyList = BehaviorRelay<[String]>(value: [])
    var quotes = BehaviorRelay<[(String, Double)]>(value : [])
    var currentValue = 0.0
    
    init(){
        loadCurrencyList()
    }

    func loadCurrencyList(){
        DataManager.shared.loadCurrencyList(){
            result in
            self.currencyList.accept(Array(result.currencies.keys).sorted())
            if self.quotes.value.count == 0{
                guard self.currencyList.value.first != nil else{
                    return
                }
                self.loadRate(source: self.currencyList.value.first!)
            }
        }
    }
    
    func loadRate(source : String){
        self.dataManager.loadCurrency(source: source, completionHandler: {
            result in
            if result.success{
                self.quotes.accept(result.quotes.sorted(by: <))
            }
        })
    }
    
}
