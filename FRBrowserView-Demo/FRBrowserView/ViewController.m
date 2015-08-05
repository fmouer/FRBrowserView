//
//  ViewController.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/29.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "ViewController.h"
#import "FadeShowControllerTransitioning.h"

@interface ViewController ()<UINavigationControllerDelegate>
{
    NSArray     * _titleArray;
}

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"FRBrowserView";
    
    _titleArray = [NSArray arrayWithObjects:
  @{@"title":@"1",@"class":@"BrowserType1ViewController"},
  @{@"title":@"2",@"class":@"BrowserType2ViewController"},
  @{@"title":@"3",@"class":@"BrowserType3ViewController"},
  @{@"title":@"4",@"class":@"BrowserType4ViewController"},
  @{@"title":@"5",@"class":@"BrowserType5ViewController"},nil];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"titleCell"];
    if (self.navigationController.delegate == self) {
        
    }
    self.navigationController.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    NSDictionary * info = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [info objectForKey:@"title"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * info = [_titleArray objectAtIndex:indexPath.row];
    NSString * classString = [info objectForKey:@"class"];
    UIViewController * controller = [[NSClassFromString(classString) alloc] init];
//    self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];

    [self.navigationController pushViewController:controller animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
