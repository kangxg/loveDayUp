//
//  AXPColorSelectedViewController.m
//  test
//
//  Created by Li Kaining on 16/9/20.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPColorSelectedViewController.h"
#import "AXPWhiteboardColorCell.h"
#import "UIColor+RGBColor.h"
#import "AXPWhiteboardToolbarManager.h"
@interface AXPColorSelectedViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic ,strong) NSMutableArray *colors;

@end


@implementation AXPColorSelectedViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.scrollEnabled = YES;
    
    [self loadSourceData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 保存白板配置
    [self.defalutConfig saveConfiguration];
}


-(void)loadSourceData
{
    if ([[[AXPWhiteboardToolbarManager sharedManager] getUserType] isEqualToString:@"teacher"])
    {
        NSArray *colorNames = [NSArray arrayWithObjects:@"灰色",@"黑色",@"紫色",@"蓝色",@"蓝绿色",@"绿色",@"黄色",@"红色", nil];
        NSArray *colors = [NSArray arrayWithObjects:kAXPMAINCOLORc7,kAXPCOLORblack,kAXPMAINCOLORc8,kAXPMAINCOLORc9,kAXPMAINCOLORc10,kAXPMAINCOLORc11,kAXPMAINCOLORc12,kAXPMAINCOLORc13, nil];
        
        for (int i = 0; i < colorNames.count; i++)
        {
            NSDictionary *dict = @{kColorName:colorNames[i],kColor:colors[i]};
            [self.dataSources addObject:dict];
        }
    }
    else
    {
        NSArray *colorNames = [NSArray arrayWithObjects:@"黑色",@"蓝色",@"绿色",@"黄色",nil];
        NSArray *colors = [NSArray arrayWithObjects:kAXPCOLORblack,kAXPMAINCOLORc9,kAXPMAINCOLORc11,kAXPMAINCOLORc12, nil];
        
        for (int i = 0; i < colorNames.count; i++)
        {
            
            NSDictionary *dict = @{kColorName:colorNames[i],kColor:colors[i]};
            [self.dataSources addObject:dict];
            
        }
    }
  
    
  
}

-(NSMutableArray *)colors
{
    if (!_colors) {
     
        if ([[[AXPWhiteboardToolbarManager sharedManager] getUserType] isEqualToString:@"teacher"])
        {
             _colors = [NSMutableArray arrayWithObjects:@"gray",@"black",@"purple",@"blue",@"cyan",@"green",@"orange",@"red", nil];
        }
        else
        {
            _colors = [NSMutableArray arrayWithObjects:@"black",@"blue",@"green",@"orange", nil];
        }
       
    }
    return _colors;
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


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSources.count) {
        static NSString *whiteboardColorCell = @"AXPWhiteboardColorCell";
        
        AXPWhiteboardColorCell *cell = [tableView dequeueReusableCellWithIdentifier:whiteboardColorCell];
        
        if (!cell) {
            cell = [[AXPWhiteboardColorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:whiteboardColorCell];
        }
        
        NSDictionary *dict = self.dataSources[indexPath.row];
        UIColor *color = dict[kColor];
        
        cell.imageView.backgroundColor = color;
        cell.colorLabel.text = dict[kColorName];
        
        switch (self.whiteboardManager) {
            case AXPWhiteboardBrush:
            
                if ([color isEqual:self.defalutConfig.brushColor]) {
                    cell.selectedImageView.hidden = NO;
                }else
                {
                    cell.selectedImageView.hidden = YES;
                }
                
                break;
                
//            case AXPWhiteboardBucket:
//            
//                if ([color isEqual:self.defalutConfig.bucketColor]) {
//                    cell.selectedImageView.hidden = NO;
//                }else
//                {
//                    cell.selectedImageView.hidden = YES;
//                }
//                
//                break;
                
            case AXPWhiteboardText:
            
                if ([color isEqual:self.defalutConfig.textColor]) {
                    cell.selectedImageView.hidden = NO;
                }else
                {
                    cell.selectedImageView.hidden = YES;
                }
                
                break;
                
            default:
                break;
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
    NSDictionary *dict = self.dataSources[indexPath.row];
    UIColor *color = dict[kColor];
    
    switch (self.whiteboardManager) {
    
        case AXPWhiteboardBrush:
        
            self.defalutConfig.brushColor = color;
            self.defalutConfig.brushColorStr = self.colors[indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AXPWhiteboardManagerViewChangeBrushIcon" object:self.colors[indexPath.row]];
            break;
            
//        case AXPWhiteboardBucket:
//        
//            self.defalutConfig.bucketColor = color;
//            self.defalutConfig.bucketColorStr = self.colors[indexPath.row];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"AXPWhiteboardManagerViewChangeBucketIcon" object:self.colors[indexPath.row]];
//            break;
            
        case AXPWhiteboardText:
        
            self.defalutConfig.textColor = color;
            break;
            
        default:
            break;
    }
    
    [tableView reloadData];
}

@end
