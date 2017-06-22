//
//  ETTAccumulativePerformanceView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTAccumulativePerformanceView.h"
#import "ETTReformanceCell.h"
@implementation ETTAccumulativePerformanceView
@synthesize EVHeadView = _EVHeadView;
-(void)createHeadView
{
    [super createHeadView];
    [self addSubview:self.EVHeadView];
}

-(ETTPerformanceHeadView *)EVHeadView
{
    if (_EVHeadView  == nil)
    {
        NSArray * arr = @[@"奖励得分",@"抢答",@"被点名",@"提醒"];
        _EVHeadView = [[ETTPerformanceHeadView alloc]initWithFrame:CGRectMake(0, 0, self.width, 46) withTitle:arr];
        
    }
    return _EVHeadView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pGetDataSource:)])
    {
        NSArray * arr = [self.EVDelegate pGetDataSource:self];
        return arr.count;
    }
    
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pGetDataSource:)])
    {
        NSArray * arr = [self.EVDelegate pGetDataSource:self];
        NSArray * carr = arr[section];
        return carr.count;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 64;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETTReformanceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReformanceCell"];
    if (cell == nil)
    {
        cell = [[ETTReformanceCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReformanceCell"];
        
    }
    
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pGetDataSource:)])
    {
        NSArray * arr =[self.EVDelegate pGetDataSource:self];
        NSArray * carr = arr[indexPath.section];
        
        [cell updateCellViews:  carr[indexPath.row] withScore:self.EVModel.EDAccumuScoreModel withIndex:indexPath responderCount:0 rollcallCount:0];
   
    }
    
    return cell;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
