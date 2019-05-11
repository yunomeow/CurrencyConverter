//
//  ViewController.swift
//  CurrencyCoverter
//
//  Created by 翰廷 姜 on 2019/5/10.
//  Copyright © 2019 Hanting. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var InputTextField: UITextField!
    @IBOutlet weak var CurrencyPickerView: UIPickerView!
    @IBOutlet weak var ResultTableView: UITableView!
    
    let viewModel = ViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataBinding()
    }

    private func setupDataBinding(){
        bindPickerView()
        bindTextField()
        bindTableView()
    }
    
    private func bindPickerView(){
        viewModel.currencyList.asObservable().bind(to: CurrencyPickerView.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        CurrencyPickerView.rx.modelSelected(String.self)
            .subscribe(onNext: { models in
                self.viewModel.loadRate(source: models[0])
            }).disposed(by: disposeBag)
    }
    
    private func bindTextField(){
        InputTextField.rx.text.asObservable().filter{$0 != nil && $0 != ""}
            .subscribe(onNext: {
                text in
                guard let inputValue = Double(text!) else {
                    return
                }
                self.viewModel.currentValue = inputValue
                self.ResultTableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        viewModel.quotes.asObservable()
            .bind(to: ResultTableView.rx.items(cellIdentifier: "DataCell")){ row, element, cell in
                let formattedValue = String(format: "%.3f", element.1 * self.viewModel.currentValue)
                cell.textLabel?.text = "\(element.0.suffix(3)) |Rate: \(element.1)| Value:\(formattedValue)"
            }
            .disposed(by: disposeBag)
    }

}

