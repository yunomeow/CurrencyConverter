//
//  CurrencyAPI.swift
//  CurrencyCoverter
//
//  Created by 翰廷 姜 on 2019/5/11.
//  Copyright © 2019 Hanting. All rights reserved.
//

import Foundation
import Alamofire

class CurrencyAPI{
    let API_HOST = "https://apilayer.net/api/"
    let API_KEY = ""
    
    public static let shared = CurrencyAPI()
    
    func fetchCurrency(source: String, completionHandler: @escaping ((_ currency : Currency) -> Void)){
        print("Fetch Currency \(source)")
        let urlStr = API_HOST + "live"
        let parameters: Parameters = [
            "access_key": API_KEY,
            "source" : source
        ]
        Alamofire.request(urlStr, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                if let data = response.data {
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(Currency.self, from: data)
                    result.updateList()
                    completionHandler(result)
                }
        }
    }
    
    func fetchCurrencyList(completionHandler: @escaping ((_ currencyList : CurrencyList) -> Void)){
        print("Fetch Currency List")
        let urlStr = API_HOST + "list"
        let parameters: Parameters = [
            "access_key": API_KEY
        ]
        Alamofire.request(urlStr, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                if let data = response.data {
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(CurrencyList.self, from: data)
                    completionHandler(result)
                }
        }
    }
}
