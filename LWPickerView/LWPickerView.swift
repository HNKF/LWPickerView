//
//  LWPickerView.swift
//  LWPickerView
//
//  Created by lailingwei on 16/4/28.
//  Copyright © 2016年 lailingwei. All rights reserved.
//

import UIKit


private let kPickerHeight: CGFloat = 216
private let kToolBarHeight: CGFloat = 44

private let kDismiss_Duration: NSTimeInterval = 0.3
private let kShow_Duration: NSTimeInterval = 0.4

private let kItemColor = UIColor.grayColor()
private let kToolBarColor = UIColor.groupTableViewBackgroundColor()
private let kPickerColor = UIColor.whiteColor()

/**
 当前控件类型
 
 - Alone:    单列Picker
 - DateMode: 系统日期Picker
 - AreaMode: 国内地区Picker
 */
@objc private enum LWPickerType: Int {
    case Alone      = 1
    case DateMode   = 2
    case AreaMode   = 3
}


class LWPickerView: UIView {

    // MARK: - Properties
    
    private var pickerType = LWPickerType.Alone
    
    private var contentView = UIView()
    private var pickerView: UIPickerView!
    
    private var contentBottomConstraint: NSLayoutConstraint!
    private var windowHoriConstraints: [NSLayoutConstraint]?
    private var windowVertConstraints: [NSLayoutConstraint]?
    
    
    /* ********************************************
     @Type: LWPickerType.Alone
     ******************************************** */
    
    private lazy var dataSource: [String] = {
        return [String]()
    }()
    
    
    
    // MARK: - Life cycle
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(NSStringFromClass(LWPickerView.self)).deinit")
    }
    
    // 配置底层遮罩视图
    private func setupMaskView() {
        
        userInteractionEnabled = true
        
        // Add tap gesture to dismiss Self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LWPickerView.dismiss))
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // 配置内容部分底视图
    private func setupContentViewWithTitle(aTitle: String?) {
        
        contentView.backgroundColor = UIColor.whiteColor()
        let toolBar = setupToolBarWithTitle(aTitle)
        pickerView = setupPickerView()
        
        addSubview(contentView)
        contentView.addSubview(toolBar)
        contentView.addSubview(pickerView)
        
        // add constraints
        contentViewAddConstraints()
        addConstraintsWithToolBar(toolBar, pickerView: pickerView)

    }
    
    // 配置工具条
    private func setupToolBarWithTitle(aTitle: String?) -> UIToolbar {
        
        // Cancel Item
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                                       target: self,
                                       action: #selector(LWPickerView.dismiss))
        leftItem.tintColor = kItemColor
        
        // Left Space Item
        let leftSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
                                            target: nil,
                                            action: nil)
        
        // Title Item
        let titleItem = UIBarButtonItem(title: aTitle,
                                        style: UIBarButtonItemStyle.Done,
                                        target: nil,
                                        action: nil)
        titleItem.tintColor = kItemColor
        
        // Right Space Item
        let rightSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
                                             target: nil,
                                             action: nil)
        
        // Done Item
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                        target: self,
                                        action: #selector(LWPickerView.done))
        rightItem.tintColor = kItemColor
        
        
        // ToolBar
        let toolBar = UIToolbar(frame: CGRectZero)
        toolBar.barTintColor = kToolBarColor
        toolBar.items = [leftItem, leftSpaceItem, titleItem, rightSpaceItem, rightItem]
        
        return toolBar
    }
    
    // 配置PickerView
    private func setupPickerView() -> UIPickerView {
    
        var picker: UIPickerView!
        
        switch pickerType {
        case .DateMode:
            print("DateMode")
            break
        default:
            picker = UIPickerView(frame: CGRectZero)
            picker.dataSource = self
            picker.delegate = self
            break
        }
        picker.backgroundColor = kPickerColor
        
        return picker
    }
    
    
    // MARK: - Target actions
    
    func dismiss() {

        UIView.animateWithDuration(kDismiss_Duration, animations: {
            self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
            self.contentBottomConstraint.constant = kToolBarHeight + kPickerHeight
            self.layoutIfNeeded()
            
        }) { (flag:Bool) in
            if flag {
                self.windowRemoveConstraints()
                self.removeFromSuperview()
            }
        }
    }
    
    func done() {
        
        dismiss()
    }
    
    
    // MARK: - Helper for constraints
    
    private func contentViewAddConstraints() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let horiConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|",
                                                                             options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
                                                                             metrics: nil,
                                                                             views: ["contentView" : contentView])
        contentBottomConstraint = NSLayoutConstraint(item: contentView,
                                                     attribute: NSLayoutAttribute.Bottom,
                                                     relatedBy: NSLayoutRelation.Equal,
                                                     toItem: self,
                                                     attribute: NSLayoutAttribute.Bottom,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: contentView,
                                                  attribute: NSLayoutAttribute.Height,
                                                  relatedBy: NSLayoutRelation.Equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutAttribute.NotAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: kPickerHeight + kToolBarHeight)
        
        if #available(iOS 8.0, *) {
            NSLayoutConstraint.activateConstraints(horiConstraints)
            NSLayoutConstraint.activateConstraints([contentBottomConstraint, heightConstraint])
        } else {
            addConstraints(horiConstraints)
            addConstraint(contentBottomConstraint)
            addConstraint(heightConstraint)
        }
    }
    
    private func windowAddConstraints() {
        
        translatesAutoresizingMaskIntoConstraints = false
        windowHoriConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[self]|",
                                                                               options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
                                                                               metrics: nil,
                                                                               views: ["self" : self])
        windowVertConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[self]|",
                                                                               options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
                                                                               metrics: nil,
                                                                               views: ["self" : self])
        if #available(iOS 8.0, *) {
            NSLayoutConstraint.activateConstraints(windowHoriConstraints!)
            NSLayoutConstraint.activateConstraints(windowVertConstraints!)
        } else {
            addConstraints(windowHoriConstraints!)
            addConstraints(windowVertConstraints!)
        }
    }
    
    private func windowRemoveConstraints() {
        
        if let horiConstraints = self.windowHoriConstraints {
            self.removeConstraints(horiConstraints)
        }
        if let vertConstraints = self.windowVertConstraints {
            self.removeConstraints(vertConstraints)
        }
    }
    
    private func addConstraintsWithToolBar(toolBar: UIToolbar, pickerView: UIPickerView) {
        // ToolBar
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let horiForToolBarConstrants = NSLayoutConstraint.constraintsWithVisualFormat("H:|[toolBar]|",
                                                                                      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
                                                                                      metrics: nil,
                                                                                      views: ["toolBar" : toolBar])
        let heightForToolBarConstrant = NSLayoutConstraint(item: toolBar,
                                                           attribute: NSLayoutAttribute.Height,
                                                           relatedBy: NSLayoutRelation.Equal,
                                                           toItem: nil,
                                                           attribute: NSLayoutAttribute.NotAnAttribute,
                                                           multiplier: 1.0,
                                                           constant: kToolBarHeight)
        // PickerView
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let horiForPickerConstrants = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pickerView]|",
                                                                                     options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
                                                                                     metrics: nil,
                                                                                     views: ["pickerView" : pickerView])
        let heightForPickerConstrant = NSLayoutConstraint(item: pickerView,
                                                          attribute: NSLayoutAttribute.Height,
                                                          relatedBy: NSLayoutRelation.Equal,
                                                          toItem: nil,
                                                          attribute: NSLayoutAttribute.NotAnAttribute,
                                                          multiplier: 1.0,
                                                          constant: kPickerHeight)
        
        // Vert
        let vertConstrants = NSLayoutConstraint.constraintsWithVisualFormat("V:|[toolBar][pickerView]|",
                                                                            options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
                                                                            metrics: nil,
                                                                            views: ["toolBar" : toolBar, "pickerView" : pickerView])
        
        contentView.addConstraints(horiForToolBarConstrants)
        contentView.addConstraint(heightForToolBarConstrant)
        
        contentView.addConstraints(horiForPickerConstrants)
        contentView.addConstraint(heightForPickerConstrant)
        contentView.addConstraints(vertConstrants)
    }

}


// MARK: - UIGesture delegate

extension LWPickerView: UIGestureRecognizerDelegate {

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        // 确保点击dismiss时，手势区域在有效区域
        guard let touchView = touch.view else {
            return false
        }
        return touchView.isKindOfClass(LWPickerView.self)
    }
}


// MARK: - UIPicker dataSource / delegate

extension LWPickerView: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}


// MARK: - Public methods

extension LWPickerView {

    /**
     显示LWPickerView
     */
    func show() {
        
        guard let window = UIApplication.sharedApplication().keyWindow else {
            print("当前Window为空")
            return
        }
        
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        window.addSubview(self)
        windowAddConstraints()
        contentBottomConstraint.constant = kPickerHeight + kToolBarHeight
        layoutIfNeeded()
        
        UIView.animateWithDuration(kShow_Duration,
                                   delay: 0.1,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: { 
                                    
                                    self.contentBottomConstraint.constant = 0
                                    self.layoutIfNeeded()
                                    
            }, completion: nil)
    }

}


// MARK: - LWPickerType.Alone

extension LWPickerView {

    /**
     初始化一个单列数据的Picker
     
     - parameter dataSource: 数据源
     - parameter title:      标题
     */
    convenience init(aDataSource: [String], aTitle: String?) {
        self.init(frame: CGRectZero)
        
        if aDataSource.count == 0 {
            print("\(NSStringFromClass(LWPickerView.self))数据源数量不应为空")
        }
        
        pickerType = LWPickerType.Alone
        dataSource = aDataSource
        
        setupMaskView()
        setupContentViewWithTitle(aTitle)
    }
    
    /**
     滚动到对应的行
     
     - parameter aRow:     对应的行
     - parameter animated: 是否动画滚动
     */
    func showSelectedRow(aRow: Int, animated: Bool) {
        guard pickerType == LWPickerType.Alone else {
            print("当前LWPickerType不为Alone")
            return
        }
        guard dataSource.count > 0 else {
            print("数据源数量不应为空")
            return
        }
        guard aRow >= 0 && aRow < dataSource.count else {
            print("目标row不在数据源数量范围内")
            return
        }
        
        pickerView.selectRow(aRow, inComponent: 0, animated: animated)
    }
    
}



























