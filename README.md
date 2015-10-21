# FRBrowserView
图片浏览
===
方便快捷的提供常用的图片浏览方式。<br>
* [图片浏览，可支持手势放大，点击放大查看图片；](#type1)
* [图片横向浏览；](#type2)
* [图片方格模式浏览，支持上拉加载和下拉刷新；](#type3)
* [图片横向浏览，可设置某一位置，当图片滑动到该位置时图片逐渐放大。](#type4)

===
##<a name="type1"/>大图浏览
```Object-c
    /**
     ** 图片可双击放大和手势放大
     */
    _browserView = [[FRBrowserView alloc] initWithFrame:self.view.bounds];
    _browserView.delegagte = self;
    
    //图片间距
    _browserView.minimumLineSpacing = 5;
    //需在minimumLineSpacing 后赋值
    _browserView.cellLeftSpace = 0;
    //第一次展示第3张图
    _browserView.showFirstItem = 0;
    //图片比例显示，NO则填充显示
    _browserView.imageAdaptSizeType = YES;
    //双击放大
    _browserView.doubleZoomInType = YES;
    //手势放大
    _browserView.gestureZoomInType = YES;
    //首次展示第几张
    _browserView.showFirstItem = _showFirstItem;
    
    //UIScrollView pagingEnable
    _browserView.pagingEnabled = YES;
    _browserView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:_browserView];
  ```
  ![screenshot1](https://github.com/fmouer/FRBrowserView/raw/master/Screenshot/Screenshot_1.gif)<br>
  
##<a name="type2"/>图片横向浏览
  ```Object-c
      FRBrowserView   * browserView = [[FRBrowserView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width,60)];
    browserView.backgroundColor = [UIColor lightGrayColor];
    browserView.delegagte = self;
    
    //不按照图片的比例显示，按照cell的比例显示
    browserView.imageAdaptSizeType = NO;
    //图片大小
    browserView.itemImageSize = CGSizeMake(50, 50);
    //图片圆角
    browserView.cellCornerRadius = 5;
    //图片左右间距
    browserView.minimumLineSpacing = 10;
    //横向滚动
    browserView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:browserView];
```
  ![screenshot1](https://github.com/fmouer/FRBrowserView/raw/master/Screenshot/Screenshot_2.png)<br>
  
##<a name="type3"/>图片方格模式浏览，支持上拉加载和下拉刷新
  ```Object-c
    /**
     *！！！！ 上拉加载和下拉刷新需要注意；
     *
     *用的第三方上拉加载和下拉刷新，不过当下拉刷新加载请求未完成时还可以上拉加载，这样就会有点BUG。
     *用到实际项目中的话需要进一步优化这一块
     */
    _browserView = [[FRBrowserView alloc] initWithFrame:(CGRect){0,64,rect.size.width,rect.size.height - 64}];
    _browserView.delegagte = self;
    //不按照图片的比例显示，按照cell的比例显示
    _browserView.imageAdaptSizeType = NO;
    //图片圆角
    _browserView.cellCornerRadius = 5;
    //图片上下左右的间距
    _browserView.minimumLineSpacing = 7;
    //第一行和最后一行 相对 collectionView的间距
    _browserView.minimumInteritemSpacing = 5;
    //一行显示的个数
    _browserView.rowNumber = 5;
    //点击动画
    _browserView.cellSelectedAnimation = YES;
    _browserView.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置上拉加载和下拉刷新
    _browserView.refreshType = FRBrowserRefreshTypeRefreshAndLoading;
    [self.view addSubview:_browserView];
```
![screenshot1](https://github.com/fmouer/FRBrowserView/raw/master/Screenshot/Screenshot_3.gif)<br>
![screenshot1](https://github.com/fmouer/FRBrowserView/raw/master/Screenshot/Screenshot_4.png)<br>

##<a name="type4"/>图片横向浏览，可设置某一位置，当图片滑动到该位置时图片逐渐放大
```Object-c
    FRBrowserView   * browserView = [[FRBrowserView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width,60)];
    browserView.backgroundColor = [UIColor lightGrayColor];
    browserView.delegagte = self;
    
    //不按照图片的比例显示，按照cell的比例显示
    browserView.imageAdaptSizeType = NO;
    //图片大小
    browserView.itemImageSize = CGSizeMake(50, 50);
    //图片圆角
    browserView.cellCornerRadius = 5;
    //图片左右间距
    browserView.minimumLineSpacing = 10;
    //横向滚动
    browserView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //cell在中间位置放大
    browserView.zoomCenterScale = 0.5;
    
    browserView.cellLeftSpace = browserView.zoomCenterScale * browserView.frame.size.width - browserView.itemImageSize.width/2;
    browserView.cellRightSpace = browserView.frame.size.width - browserView.cellLeftSpace - browserView.itemImageSize.width;
    //cell放大倍数
    browserView.zoomFactor = 0.2;
    [self.view addSubview:browserView];
```
![screenshot1](https://github.com/fmouer/FRBrowserView/raw/master/Screenshot/Screenshot_5.gif)<br>

