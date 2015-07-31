//
//  BrowserType4ViewController.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "BrowserType4ViewController.h"
#import "FRBrowserView.h"
#import "FRShowImageView.h"
#import "AppDelegate.h"
#import "BrowserDetailView.h"
#import "BrowserType1ViewController.h"
#import "FadeShowControllerTransitioning.h"

@interface BrowserType4ViewController ()<FRBrowserViewDelegate,UINavigationControllerDelegate>
{
    NSArray     * _dataArray;
    FRBrowserView   * _browserView;
}
@end

@implementation BrowserType4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Type4";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = @[@"http://img.ihotdo.com/ifs1/M00/65/E4/wKgKq1W3KFCAOTKtAAM0k1rQzQM450_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/FE/18/wKgKq1W3KHKATw8CAAFselYAs9k272_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/3A/59/wKgKqlW4LwaAW8lkAAOAY9Fv55g986_320x250.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/F2/F1/wKgKq1W3KH6AJR9hAARTwFpB3kQ768_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/10/33/wKgKqlW4LwqAfSafAAPkDan9-Xk423_320x250.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/BC/C3/wKgKqlW3JwmAE1DpAA8nDMoTUs0436_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/D6/F8/wKgKqlW3JwmAS42GABGNMeqS7tc195_320x320.jpg"];
    
    
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

    if (_browserView == nil) {
        CGRect rect = self.view.bounds;
        
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
        _browserView.rowNumber = 4;
        
        //点击动画
        _browserView.cellSelectedAnimation = YES;
        
        _browserView.scrollDirection = UICollectionViewScrollDirectionVertical;
        [self.view addSubview:_browserView];
    }
}

#pragma mark - FRBrowserViewDelegate
-(NSString *)imageStringForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem
{
    return _dataArray[pageItem%_dataArray.count];
}

-(NSInteger)numberItemsForFRBrowserView:(FRBrowserView *)browserView
{
    
    return _dataArray.count * 10;
}

- (void)frBrowserView:(FRBrowserView *)browserView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selectedItem is %ld",(long)indexPath.row);
    
    BrowserType1ViewController * viewController = [[BrowserType1ViewController alloc] init];
    viewController.dataArray = _dataArray;
    viewController.showFirstItem = indexPath.row;
    viewController.page = 10;
    [self.navigationController pushViewController:viewController animated:YES];
    
}



#pragma mark - 点击切换时动画需要的方法


- (FRCollectionViewCell *)getSelectCell:(NSIndexPath *)indexPath
{
    FRCollectionViewCell * cell = (FRCollectionViewCell *)[_browserView.collectionView cellForItemAtIndexPath:indexPath];
    return cell;

}

/**
 *返回图片详细浏览到某个图片的cell所在的CGRect
 *返回时需要找到浏览的小图片的位置
 */
- (CGRect)getBrowserItemRectWith:(NSIndexPath *)indexPath
{
    FRCollectionViewCell * cell = (FRCollectionViewCell *)[_browserView.collectionView cellForItemAtIndexPath:indexPath];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGRect rect = [cell.superview convertRect:cell.frame toView :appDelegate.window];
    return rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UINavigationControllerDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[BrowserType1ViewController class]]) {
        return [[FadeShowControllerTransitioning alloc] init];
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
