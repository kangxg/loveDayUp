//
//  AXPWhiteboardToolbarViewController.m
//  test
//
//  Created by Li Kaining on 16/9/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPToolbarViewController.h"
#import "AXPWhiteboardSelectedToolbarCell.h"
#import "AXPSetPopViewController.h"

@interface AXPToolbarViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AXPToolbarViewController

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.isPush = YES;
    }
    
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadDataSources];
}

-(void)loadDataSources
{
    [self.dataSources addObjectsFromArray:@[@"左侧",@"右侧"]];
}


#pragma mark -- UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kAXPPopViewCellDefalutCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSources.count) {
        
        static NSString *whiteboardSelectedToolbarCell = @"AXPWhiteboardSelectedToolbarCell";
        
        AXPWhiteboardSelectedToolbarCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardSelectedToolbarCell];
        
        if (!cell) {
            cell = [[AXPWhiteboardSelectedToolbarCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardSelectedToolbarCell];
        }
        
        NSString *toolbarStr = self.dataSources[indexPath.row];
        cell.titleLable.text = toolbarStr;
        
        if ([toolbarStr isEqualToString:self.defalutConfig.toolbar]) {
            cell.selectedImageView.hidden = NO;
        }else
        {
            cell.selectedImageView.hidden = YES;
        }
        
        return cell;
        
    }else
    {        
        return [[AXPPopViewBasicCell alloc] init];
    }
}


#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.dataSources.count-1) {
        return;
    }
    
    NSString *toolbarStr = self.dataSources[indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:toolbarStr forKey:@"toolbar"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.defalutConfig.toolbar = toolbarStr;
    
    [[AXPWhiteboardConfiguration sharedConfiguration] saveConfiguration];
    
    [[AXPWhiteboardToolbarManager sharedManager] checkoutSelectedButton];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeWhiteboardToolbarAndWhiteboardView" object:[NSDictionary dictionaryWithObject:@"YES" forKey:@"disappear"]];
    
    [tableView reloadData];
}

@end
