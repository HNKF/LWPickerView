# LWPickerView
日期选择器、单列选择器、地区选择器。

Deployment Target iOS 7.0

一、单列数据选择器：

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


二、日期选择器：

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
![(logo)](http://code4app.com/data/attachment/forum/201607/06/192327u4vcdzujbccbjgbu.png)


三、城市地区选择器：

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

![(logo)](http://code4app.com/data/attachment/forum/201607/06/192309t9mfaf9n4ktmntfs.png)


