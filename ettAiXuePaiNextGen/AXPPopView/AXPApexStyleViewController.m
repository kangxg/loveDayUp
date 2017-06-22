//
//  AXPApexStyleViewController.m
//  test
//
//  Created by Li Kaining on 16/9/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPApexStyleViewController.h"
#import "AXPWhiteboardColorCell.h"
#import "AXPSetPopViewController.h"

@interface AXPApexStyleViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AXPApexStyleViewController

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self loadDataSource];
}

-(void)loadDataSource
{
    NSArray *apexNames = [NSArray arrayWithObjects:@"无",@"圆",@"正方形", nil];
    NSArray *apexStyles = [NSArray arrayWithObjects:@"white",@"circleApexBlack",@"squareApexBlack",nil];
    
    for (int i = 0; i < apexStyles.count; i++) {
        
        NSDictionary *dict = @{kApexName:apexNames[i],kApexStyle:apexStyles[i]};
        
        [self.dataSources addObject:dict];
    }
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
        static NSString *whiteboardApexStyleCell = @"AXPWhiteboardApexStyleCell";
        
        AXPWhiteboardColorCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardApexStyleCell];
        
        if (!cell) {
            cell = [[AXPWhiteboardColorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardApexStyleCell];
        }
        
        NSDictionary *dict = self.dataSources[indexPath.row];
        NSString *apexStyleName = dict[kApexStyle];
        
        if ([apexStyleName isEqualToString:self.defalutConfig.apexStyle]) {
            cell.selectedImageView.hidden = NO;
        }else
        {
            cell.selectedImageView.hidden = YES;
        }
    
        cell.imageView.image = [UIImage imageNamed:apexStyleName];
        cell.colorLabel.text = dict[kApexName];
        
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
    
    NSDictionary *dict      = self.dataSources[indexPath.row];
    NSString *apexStyleName = dict[kApexStyle];

    self.defalutConfig.apexStyle = apexStyleName;
    
    [[AXPWhiteboardConfiguration sharedConfiguration] saveConfiguration];
    
    [[AXPWhiteboardToolbarManager sharedManager] checkoutSelectedButton];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeWhiteboardToolbarAndWhiteboardView" object:nil];
    
    [tableView reloadData];
}


@end
