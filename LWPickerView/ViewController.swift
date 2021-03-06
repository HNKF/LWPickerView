//
//  ViewController.swift
//  LWPickerView
//
//  Created by lailingwei on 16/4/28.
//  Copyright © 2016年 lailingwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    // MARK: - AlonePicker

    private let alonePicker: LWPickerView = {
        var dataSource = [String]()
        for i in 0..<20 {
            dataSource.append("\(i)")
        }
        return LWPickerView(aDataSource: dataSource, aTitle: "AlonePicker")
    }()
    
    @IBAction func showAlonePicker(sender: UIButton) {
        
        alonePicker.show()
        alonePicker.showSelectedRow(3, animated: true)
        alonePicker.didClickDoneForTypeAloneHandler { (selectedRow, result) in
            print("selectedRow:\(selectedRow)")
            print("result:\(result)")
        }
        alonePicker.didClickCancelHandler { 
            print("dismiss")
        }
    }
    
    
    // MARK: - DateModePicker
    
    private let datePicker: LWPickerView = {
        return LWPickerView(aDatePickerMode: .Date, aTitle: "DatePicker")
    }()
    
    @IBAction func showDatePicker(sender: UIButton) {
        
        datePicker.show()
        datePicker.setDate(NSDate(), animated: true)
        datePicker.didClickDoneForTypeDateWithFormat("yy年MM月dd日 HH:mm:ss") { (selectedDate, dateString) in
            print("selectedDate:\(selectedDate)")
            print("dateString:\(dateString)")
        }
        datePicker.didClickCancelHandler {
            print("dismiss")
        }
    }
    
    
    // MARK: - AreaPicker
    
    private let areaPicker: LWPickerView = {
        return LWPickerView(anAreaType: .ProvinceCityDistrict, aTitle: "AreaPicker")
    }()
    
    @IBAction func showAreaPicker(sender: UIButton) {
        
        areaPicker.show()
        areaPicker.didClickDoneForTypeAreaHandler { (province, city, district) in
            print("province:\(province)")
            print("city:\(city)")
            print("district:\(district)")
        }
        areaPicker.didClickCancelHandler {
            print("dismiss")
        }
    }
    
}

