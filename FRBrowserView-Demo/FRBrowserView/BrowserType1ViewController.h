//
//  BrowserType1ViewController.h
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/29.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRBrowserView.h"

@interface BrowserType1ViewController : UIViewController

@property (nonatomic, assign)NSInteger showFirstItem;
@property (nonatomic, copy)NSArray * dataArray;

@property (nonatomic, assign)NSInteger  page;

/**
 *返回当前浏览的cell
 */
- (FRCollectionViewCell *)getSelectCell;

/**
 *返回浏览到某个Item的值
 */
- (NSInteger )getBrowserAtIndexPathRow;

@end
