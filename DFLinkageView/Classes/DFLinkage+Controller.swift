//
//  UIViewController+DFLinkage.swift
//  DFLinkageScrollView
//
//  Created by 王飞 on 2020/8/1.
//  Copyright © 2020 王飞. All rights reserved.
//

import UIKit

private var key: Void?
extension UIViewController {
    open var linkageView: UIScrollView?{
        get {
            return objc_getAssociatedObject(self, &key) as? UIScrollView
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
           //当contentSize小于frame.size也可以滚动
            newValue?.alwaysBounceVertical = true
            newValue?.showsVerticalScrollIndicator = false
        }
    }

}
