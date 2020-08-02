# DFLinkageView

##简介
DFLinkageView是UIScrollVIew的子类，内部包含一个头部（美女图片处），一个切换选项栏，一个用来切换视图的CollectionView，每个CollectionView的cell对应一个自定义的ViewController。DFLinkageView内部实现切换以及两个scrollView的滚动逻辑，外部使用起来非常方便。

##实现效果
![image]( https://img-blog.csdnimg.cn/20200802114744384.gif)

##使用方法
####1.初始化控件

####2.设置headerView (需要设置frame！！)

####3.设置plateTitleArr (悬停部分显示内容)

####4.设置plateControllers (底部collectionView的cell显示内容)需要创建对应的Controller

```
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


```

####5.DemoPageViewController中设置linkageView  --DFLinkageScrollView中设置代理用
linkageView为UIViewController的分类属性

```
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
```
然后command + R ，就好使了！

##图层结构

![image]( https://img-blog.csdnimg.cn/20200802115718686.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzE2ODQ0MDAx,size_16,color_FFFFFF,t_70)

##核心原理

####1..让外层scrollView和内层scrollview同时滚动scroll
DFLinkageScrollView实现UIGestureRecognizerDelegate中gestureRecognizer shouldRecognizeSimultaneouslyWith方法

```
public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }


```
让两个手势都起作用

####2.两个scrollview滚动的时候改变他们的contentoffset

```
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
```
以上逻辑都在DFLinkageScrollView中，如使用控件可做了解。

