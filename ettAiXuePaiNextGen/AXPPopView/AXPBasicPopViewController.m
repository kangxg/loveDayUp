//
//  AXPBasicPopViewController.m
//  test
//
//  Created by Li Kaining on 16/9/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPBasicPopViewController.h"
#import "AXPWhiteboardToolbarManager.h"

@interface AXPBasicPopViewController ()

@end

@implementation AXPBasicPopViewController

-(instancetype)init
{
    self = [super init];
    
    self.defalutConfig = [AXPWhiteboardConfiguration sharedConfiguration];
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.scrollEnabled = NO;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, kAXPPopWidth, kAXPPopHeight);
}

-(NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}


@end
