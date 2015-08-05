//
//  BrowserType3ViewController.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "BrowserType3ViewController.h"
#import "FRShowImageView.h"
#import "AppDelegate.h"
#import "BrowserDetailView.h"
#import "FadeShowControllerTransitioning.h"

@interface BrowserType3ViewController ()<FRBrowserViewDelegate>
{
    NSArray     * _dataArray;
    FRBrowserView   * _browserView;
    
    NSInteger     _page;
}
@end

@implementation BrowserType3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Type3";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _dataArray = @[@"http://img.ihotdo.com/ifs1/M00/65/E4/wKgKq1W3KFCAOTKtAAM0k1rQzQM450_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/FE/18/wKgKq1W3KHKATw8CAAFselYAs9k272_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/3A/59/wKgKqlW4LwaAW8lkAAOAY9Fv55g986_320x250.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/F2/F1/wKgKq1W3KH6AJR9hAARTwFpB3kQ768_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/10/33/wKgKqlW4LwqAfSafAAPkDan9-Xk423_320x250.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/BC/C3/wKgKqlW3JwmAE1DpAA8nDMoTUs0436_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/D6/F8/wKgKqlW3JwmAS42GABGNMeqS7tc195_320x320.jpg"];
    
    //测试
    _page = 10;
    
    
    CGRect rect = self.view.bounds;
    
    /**
     *！！！！ 上拉加载和下拉刷新需要注意；
     *
     *用的第三方上拉加载和下拉刷新，不过当下拉刷新加载请求未完成时还可以上拉加载，这样就会有BUG。
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

    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_browserView == nil) {
    }
}
-(NSString *)imageStringForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem
{
    return _dataArray[pageItem%_dataArray.count];
}

-(NSInteger)numberItemsForFRBrowserView:(FRBrowserView *)browserView
{
    
    return _dataArray.count * _page;
}

- (void)frBrowserView:(FRBrowserView *)browserView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selectedItem is %ld",(long)indexPath.row);
    
    FRCollectionViewCell * cell = (FRCollectionViewCell *)[browserView.collectionView cellForItemAtIndexPath:indexPath];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGRect rect = [cell.superview convertRect:cell.frame toView :appDelegate.window];
    
    FRShowImageView  * view = [[FRShowImageView alloc] initWithFrame:rect];
    [appDelegate.window addSubview:view];

    CGSize windowSize = appDelegate.window.frame.size;
    float width = appDelegate.window.frame.size.width;
    __weak FRShowImageView * wView = view;
    
    NSString * imageUrl = [[cell.imageUrl stringByReplacingOccurrencesOfString:@"_300x250" withString:@""] stringByReplacingOccurrencesOfString:@"_320x320" withString:@""];
    
    [view setImageUrlString:imageUrl placeholderImage:cell.imageView.image imageSizeBlock:^(CGSize size) {
        float height = size.height / size.width * width;
        [wView showToFrame: CGRectMake(0, windowSize.height/2 - height/2, windowSize.width, height) finished:^{
            BrowserDetailView * detailView = [[BrowserDetailView alloc] initWithFrame:appDelegate.window.bounds];
            detailView.page = _page;
            detailView.wController = self;
            detailView.dataArray = _dataArray;
            detailView.showFirstItem = indexPath.row;
            [appDelegate.window addSubview:detailView];
            [detailView awakeFromNib];
        }];
    }];
   
    
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

-(void)frBrowserViewLoading:(FRBrowserView *)browserView
{
    NSMutableArray * indexPaths = [[NSMutableArray alloc] initWithCapacity:_dataArray.count];
    for (NSInteger i = _dataArray.count * _page ; i < _dataArray.count * (_page + 1); i ++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    _page ++;
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [browserView insertIndexPaths:indexPaths refresh:NO];
        if (_page == 12) {
            //上拉加载结束
            browserView.collectionView.showsInfiniteScrolling = NO;
        }
    });
}

-(void)frBrowserViewRefresh:(FRBrowserView *)browserView
{
    _page ++;
    NSMutableArray * indexPaths = [[NSMutableArray alloc] initWithCapacity:_dataArray.count];
    for (int i = 0; i < _dataArray.count; i ++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [browserView insertIndexPaths:indexPaths refresh:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
