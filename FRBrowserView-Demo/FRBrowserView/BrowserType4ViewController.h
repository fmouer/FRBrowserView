//
//  BrowserType4ViewController.h
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRBrowserView.h"

@interface BrowserType4ViewController : UIViewController

- (FRCollectionViewCell *)getSelectCell:(NSIndexPath *)indexPath;
- (CGRect)getBrowserItemRectWith:(NSIndexPath *)indexPath;

@end
