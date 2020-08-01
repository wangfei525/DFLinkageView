//
//  DemoPageViewController.swift
//  DFLinkageView_Example
//
//  Created by 王飞 on 2020/8/1.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class DemoPageViewController: UIViewController {
    
    
    lazy var contentView = UIScrollView.init(frame: CGRect.zero)
    
    lazy var colorView = UIView.init()
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
        
    func setupView() {
        self.linkageView = contentView
        self.contentView.frame = CGRect(x: 0, y: 0, width: DFScreenWidth, height: DFScreenHeight - 51 - DFHeaderMargin )
        self.view.addSubview(contentView)
        colorView.frame = CGRect(x: 0, y: 25, width: DFScreenWidth, height: 100)
        colorView.backgroundColor = randomColor()
        
        self.contentView.addSubview(self.colorView)
        
        for i in 0..<4 {
            let imageView = UIImageView.init()
            imageView.image = UIImage(named: imageName ?? "jialing.jpeg")
            imageView.frame = CGRect(x: 0, y: 150 + i*200, width: Int(DFScreenWidth), height: 200)
            self.contentView.addSubview(imageView)
        }
        
        self.contentView.contentSize = CGSize(width: DFScreenWidth, height: 950)
        
    }
    
    
    func randomColor() -> UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
         
       }
}
