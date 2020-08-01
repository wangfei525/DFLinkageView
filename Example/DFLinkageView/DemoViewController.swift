//
//  ViewController.swift
//  DFLinkageView
//
//  Created by wangfeifei0525@163.com on 08/01/2020.
//  Copyright (c) 2020 wangfeifei0525@163.com. All rights reserved.
//

import UIKit
import DFLinkageView

let DFScreenHeight =  UIScreen.main.bounds.size.height
let DFScreenWidth =  UIScreen.main.bounds.size.width
let DFHeaderMargin: CGFloat = 60.0
let DFHeaderHeight: CGFloat = 200.0

class DemoViewController: UIViewController {
    
    lazy var contentView = DFLinkageScrollView.init()
    
    lazy var imageHeader = { () -> UIImageView in
        let image = UIImage(named: "beauty.jpg")
        let imageView = UIImageView(image: image)
       return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        contentView.frame = CGRect(x: 0, y: DFHeaderMargin, width: DFScreenWidth, height: DFScreenHeight - DFHeaderMargin);
        self.view.addSubview(contentView)
        
        imageHeader.frame = CGRect(x: 0, y: 0, width: DFScreenWidth, height: DFHeaderHeight);
        self.contentView.contentHeader = imageHeader
        
        let titleArr = ["精选","图片","汽车","科技","美女"]
        
        contentView.plateTitleArr = titleArr as NSArray
        
        let imageArr = ["boutique.jpg","picture.jpg","car.jpg","science.jpg","jialing.jpeg"]
        
        var controllerArr = Array<Any>()
        for i in 0..<titleArr.count {
            let controller = DemoPageViewController.init()
            controller.imageName = imageArr[i]
            controllerArr.append(controller)
        }
        
        contentView.plateControllers = controllerArr as NSArray
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

