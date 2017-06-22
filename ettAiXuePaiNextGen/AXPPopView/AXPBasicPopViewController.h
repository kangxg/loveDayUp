//
//  AXPBasicPopViewController.h
//  test
//
//  Created by Li Kaining on 16/9/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXPWhiteboardConfiguration.h"
#import "AXPWhiteboardToolbarManager.h"

@interface AXPBasicPopViewController : UIViewController

@property(nonatomic ,strong) AXPWhiteboardConfiguration *defalutConfig;

@property(nonatomic ,strong) UITableView *tableView;

@property(nonatomic ,strong) NSMutableArray *dataSources;

@property(nonatomic) AXPWhiteboardManager whiteboardManager;

@property(nonatomic ) BOOL isPush;

@end
