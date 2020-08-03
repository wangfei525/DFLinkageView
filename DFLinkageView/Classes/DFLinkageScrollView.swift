//
//  DFLinkageScrollerView.swift
//  DFLinkageScrollView
//
//  Created by 王飞 on 2020/8/1.
//  Copyright © 2020 王飞. All rights reserved.
//

import UIKit

let DFTagHeight: CGFloat = 51.0

public class DFLinkageScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    open var contentHeader: UIView? {
           didSet {
               if let contentHeader = contentHeader {
                   self.addSubview(contentHeader)
                   self.layoutSubviews()
               }
           }
       }
       
    var currentModuleIndex: Int {
        
        get {
            return plateHeader.selectedIndex
        }
    }
       
    open var plateTitleArr: NSArray? {
        didSet {
            plateHeader.setData(titleArr: plateTitleArr as! Array<String>)
        }
    }
    
    open var plateControllers: NSArray? {
        didSet {
            _initCell()
            plateContentView.reloadData()
        }
    }
    
    fileprivate lazy var plateContentView =  { () -> UICollectionView in
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.plateContentViewLayout)
        view.backgroundColor = UIColor.white
        view.allowsSelection = false
        view.isPagingEnabled = true
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        return view
    }()
    
    fileprivate lazy var plateContentViewLayout = { () -> UICollectionViewFlowLayout in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: DFScreenWidth, height: DFScreenHeight)
        return flowLayout
    }()
       
    var plateCells = [UICollectionViewCell]()
    
    //标签
    fileprivate lazy var plateHeader = DFLinkageTagHeader()
    
    fileprivate var canPlateScroll: Bool = false
    
    convenience public init() {
        self.init(frame: CGRect.zero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        _setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        superview?.layoutSubviews()
        
        let width = frame.width
        let height = frame.height
        let y = _headerHeight()
        plateHeader.frame = CGRect(x: 0, y: y, width: width, height: DFTagHeight)
        plateContentView.frame = CGRect(x: 0, y: y+DFTagHeight, width: width, height: height - DFTagHeight)
        plateContentViewLayout.itemSize = CGSize(width: width, height:  height - DFTagHeight)
        self.contentSize = CGSize(width: width, height: height + y)
        
    }
    
    private func _setupView() {
        self.alwaysBounceVertical = true
        plateHeader.headerDelegate = self
        self.addSubview(plateHeader)
        self.insertSubview(plateContentView, belowSubview: (plateHeader))
    }
    
    private func _headerHeight() -> CGFloat {
        if let contentHeader = contentHeader {
            return contentHeader.bounds.size.height
        } else {
            return 0
        }
    }
    
    private func _initCell() {
        plateCells.removeAll()
        for controller in plateControllers! {
            let cell = plateContentView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: IndexPath(item: 0, section: 0))
            cell.contentView.addSubview((controller as! UIViewController).view)
            plateCells.append(cell)
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self {
            contentViewDidScroller(view: scrollView)
        } else if scrollView == plateContentView {
            plateContentViewDidScroll(view: scrollView)
        } else {
            linkageViewDidScroll(view: scrollView)
        }
    }

    func contentViewDidScroller(view: UIScrollView) {
        //标签常悬
        let y = view.contentOffset.y
        let headerY = _headerHeight()
        if canPlateScroll {
            self.contentOffset = CGPoint(x: 0, y: headerY)
        } else if y >= headerY {
            canPlateScroll = true
        }
    }
    
    func linkageViewDidScroll(view: UIScrollView) {
        if !canPlateScroll {
            view.contentOffset = CGPoint.zero
        } else if view.contentOffset.y <= 0 {
            canPlateScroll = false
        }
    }
    
    func plateContentViewDidScroll(view: UIScrollView) {
        let index = Int((view.contentOffset.x + DFScreenWidth/2) / DFScreenWidth)
        plateHeader.selectedIndex = index
        plateHeader.scrollContent(offsetX: view.contentOffset.x)
    }
}


extension DFLinkageScrollView: DFLinkageTagHeaderDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plateCells.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plateCells[indexPath.item]
        if let plateControllers = plateControllers{
            if plateControllers.count > 0 {
                let controller = plateControllers[indexPath.item] as! UIViewController
                controller.view.frame = cell.bounds
                controller.linkageView?.delegate = self
            }
            
        }
        return cell
    }
    
    public func headerButtonClick(index: Int) {
        plateContentView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
        if contentOffset.y > _headerHeight() {
            contentOffset = CGPoint(x: 0, y: _headerHeight())
        }
    }
    
}
