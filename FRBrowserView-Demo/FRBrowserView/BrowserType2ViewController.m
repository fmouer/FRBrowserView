//
//  BrowserType2ViewController.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "BrowserType2ViewController.h"
#import "FRBrowserView.h"

@interface BrowserType2ViewController ()<FRBrowserViewDelegate>
{
    NSArray     * _dataArray;
}
@end

@implementation BrowserType2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Type2";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _dataArray = @[@"http://img.ihotdo.com/ifs1/M00/65/E4/wKgKq1W3KFCAOTKtAAM0k1rQzQM450_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/FE/18/wKgKq1W3KHKATw8CAAFselYAs9k272_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/3A/59/wKgKqlW4LwaAW8lkAAOAY9Fv55g986_320x250.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/F2/F1/wKgKq1W3KH6AJR9hAARTwFpB3kQ768_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/10/33/wKgKqlW4LwqAfSafAAPkDan9-Xk423_320x250.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/BC/C3/wKgKqlW3JwmAE1DpAA8nDMoTUs0436_320x320.jpg",
                   @"http://img.ihotdo.com/ifs1/M00/D6/F8/wKgKqlW3JwmAS42GABGNMeqS7tc195_320x320.jpg"];
    
    
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
    
}

-(NSString *)imageStringForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem
{
    return _dataArray[pageItem%_dataArray.count];
}

-(NSInteger)numberItemsForFRBrowserView:(FRBrowserView *)browserView
{
    
    return _dataArray.count * 2;
}

- (void)frBrowserView:(FRBrowserView *)browserView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selectedItem is %ld",(long)indexPath.row);
    
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
