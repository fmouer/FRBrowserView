//
//  BrowserType1ViewController.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/29.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "BrowserType1ViewController.h"
#import "FadeBackControllerTransitioning.h"
#import "BrowserType4ViewController.h"
#import "SDImageCache.h"

@interface BrowserType1ViewController ()<FRBrowserViewDelegate,UINavigationControllerDelegate>
{
    FRBrowserView   * _browserView;
}
@end

@implementation BrowserType1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Type1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
    if (_dataArray == nil) {
        _dataArray = @[@"http://img.ihotdo.com/ifs1/M00/65/E4/wKgKq1W3KFCAOTKtAAM0k1rQzQM450.jpg",
                       @"http://img.ihotdo.com/ifs1/M00/FE/18/wKgKq1W3KHKATw8CAAFselYAs9k272.jpg",
                       @"http://img.ihotdo.com/ifs1/M00/3A/59/wKgKqlW4LwaAW8lkAAOAY9Fv55g986.jpg",
                       @"http://img.ihotdo.com/ifs1/M00/F2/F1/wKgKq1W3KH6AJR9hAARTwFpB3kQ768.jpg",
                       @"http://img.ihotdo.com/ifs1/M00/10/33/wKgKqlW4LwqAfSafAAPkDan9-Xk423.jpg",
                       @"http://img.ihotdo.com/ifs1/M00/BC/C3/wKgKqlW3JwmAE1DpAA8nDMoTUs0436.jpg",
                       @"http://img.ihotdo.com/ifs1/M00/D6/F8/wKgKqlW3JwmAS42GABGNMeqS7tc195.jpg"];
    }
    if (_page == 0) {
        _page = 1;
    }
    
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
    //图片比例显示
    _browserView.imageAdaptSizeType = YES;
    //双击放大
    _browserView.doubleZoomInType = YES;
    //手势放大
    _browserView.gestureZoomInType = YES;
    //展示第几张
    _browserView.showFirstItem = _showFirstItem;
    
    //UIScrollView pagingEnable
    _browserView.pagingEnabled = YES;
    _browserView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:_browserView];
}

#pragma mark - FRBrowserViewDelegate
-(NSString *)imageStringForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem
{
    NSString * imagUrl1 = _dataArray[pageItem%_dataArray.count];
    NSString * imageUrl = [[imagUrl1 stringByReplacingOccurrencesOfString:@"_300x250" withString:@""] stringByReplacingOccurrencesOfString:@"_320x320" withString:@""];
    return imageUrl;
}
- (UIImage *)placeholderImageForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem
{
    NSString * urlString = _dataArray[pageItem%_dataArray.count];
    UIImage *image =[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:urlString];
    return image;
}

-(NSInteger)numberItemsForFRBrowserView:(FRBrowserView *)browserView
{
    
    return _dataArray.count * _page;
}

-(void)frBrowserView:(FRBrowserView *)browserView centerItem:(NSInteger)centerItem
{
    NSLog(@"centerItem is %ld",(long)centerItem);
}
- (void)frBrowserView:(FRBrowserView *)browserView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selectedItem is %ld",(long)indexPath.row);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 切换动画需要的数据及方法
/**
 *返回当前浏览的cell
 */
- (FRCollectionViewCell *)getSelectCell
{
    FRCollectionViewCell * cell = (FRCollectionViewCell *)[_browserView.collectionView cellForItemAtIndexPath:_browserView.flowLayout.centerIndexPath];
    return cell;
    
}
/**
 *返回浏览到某个Item的值
 */
-(NSInteger)getBrowserAtIndexPathRow
{
    return _browserView.flowLayout.centerIndexPath.row;
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.delegate != self) {
        self.navigationController.delegate = self;
    }
}

#pragma mark UINavigationControllerDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[BrowserType4ViewController class]]) {
        return [[FadeBackControllerTransitioning alloc] init];
    }
    else {
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
