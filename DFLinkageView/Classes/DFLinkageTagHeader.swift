//
//  DFLinkageTagHeader.swift
//  DFLinkageScrollView
//
//  Created by 王飞 on 2020/8/1.
//  Copyright © 2020 王飞. All rights reserved.
//

import UIKit

protocol DFLinkageTagHeaderDelegate: NSObjectProtocol{
     func headerButtonClick(index:Int)
}

let DFScreenHeight =  UIScreen.main.bounds.size.height
let DFScreenWidth =  UIScreen.main.bounds.size.width
let DFButtonMargin = 32

class DFLinkageTagHeader: UIScrollView {
    
    weak var headerDelegate: DFLinkageTagHeaderDelegate?

    var titleData: Array<String>?
    
    var selectedIndex = 0 {
        didSet {
           let lastSelectBtn = buttonArr[oldValue]
            _diselectBtn(btn: lastSelectBtn)
            let selectBtn = buttonArr[selectedIndex]
            _selectBtn(btn: selectBtn)
        
        }
    }
    
    lazy var cursorLine = UIView()
    
    lazy var buttonArr = Array<UIButton>()
    
    var buttonWidth: CGFloat?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //入口
    func setData(titleArr: Array<String>) {
        titleData = titleArr
        _setupBtns()
    }
    
    func scrollContent(offsetX: CGFloat) {
        if buttonWidth != nil  {
            let cursorOffsetX =  (buttonWidth! + 24) * offsetX / DFScreenWidth
            let size = cursorLine.frame.size
            let origin = cursorLine.frame.origin
            
            let x = cursorOffsetX + 32 + (buttonWidth! - 25)/2
            cursorLine.frame = CGRect(x: x, y: origin.y, width: size.width, height: size.height)
            
        }
    }
    
    @objc private func btnClickAction(sender: UIButton) {
        selectedIndex = sender.tag - 100
        UIView.animate(withDuration: 0.25) {
            let selectBtn = self.buttonArr[self.selectedIndex]
            let x = selectBtn.frame.origin.x + (selectBtn.frame.size.width - 25)/2
            self.cursorLine.frame = CGRect(x: x, y: 48, width: 25, height: 3)
        }
        
        if let headerDelegate = headerDelegate {
                headerDelegate.headerButtonClick(index: selectedIndex)
        }
    }
    
    private func _setupBtns() {
        if let titleData = titleData {
            
            var btnWidth = (DFScreenWidth - 2*20) / CGFloat(titleData.count)
            
            //自己定的
            let minWidth: CGFloat = 75.0
            
            btnWidth = btnWidth > CGFloat(minWidth) ? btnWidth : minWidth
            buttonWidth = btnWidth - 24
            
            for i in 0...titleData.count-1 {
                let button = UIButton.init()
                button.titleLabel?.textAlignment = .center
                button.tag = i + 100
                
                _diselectBtn(btn: button)
                button.addTarget(self, action: #selector(self.btnClickAction(sender:)), for: .touchUpInside)
                let titleName = titleData[i]
                button.setTitle(titleName, for: .normal)
                button.frame = CGRect(x: CGFloat(i)*btnWidth + 32, y: 13, width: btnWidth - 24, height: 24)
                self.addSubview(button)
                buttonArr.append(button)
                
            }
            cursorLine.backgroundColor = UIColor.yellow
            self.addSubview(cursorLine)
            //默认选中
            btnClickAction(sender: buttonArr.first!)
            
            let allWidth = btnWidth * CGFloat(titleData.count) + 40
            self.contentSize = CGSize(width: allWidth, height: 51)
        }
    }
    
    private func _selectBtn(btn: UIButton) {
        btn.setTitleColor(UIColor.black, for: .normal)
        if #available(iOS 8.2, *) {
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
    }
    
    private func _diselectBtn(btn: UIButton) {
        btn.setTitleColor(UIColor.gray, for: .normal)
        if #available(iOS 8.2, *) {
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
}
