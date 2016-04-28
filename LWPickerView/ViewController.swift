//
//  ViewController.swift
//  LWPickerView
//
//  Created by lailingwei on 16/4/28.
//  Copyright © 2016年 lailingwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let picker = LWPickerView(aDataSource: ["3", "2", "1", "23", "3", "2", "1", "23"], aTitle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        picker.show()
        picker.showSelectedRow(3, animated: true)
    }
    
    
}

