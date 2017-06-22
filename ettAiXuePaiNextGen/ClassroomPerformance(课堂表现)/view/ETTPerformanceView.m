//
//  ETTPerformanceView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTPerformanceView.h"
#import "MJRefresh.h"
@implementation ETTPerformanceView

@dynamic EVHeadView;
@synthesize EVTableView = _EVTableView;
@synthesize EVModel     = _EVModel;
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor =[UIColor colorWithHexString:@"#fafafa"];
        [self createHeadView];
        [self createTalbeView];
    }
    return self;
}
-(void)createHeadView
{
   }
-(void)reloadView
{
    [_EVTableView reloadData];
}

-(void)reloadTalbleView
{
    
}
-(void)createTalbeView
{
    if (_EVTableView == nil)
    {
        _EVTableView = [[UITableView alloc]initWithFrame:CGRectMake(96, self.EVHeadView.height , self.width-192, self.height-96)style:UITableViewStylePlain];
         _EVTableView.delegate = self;
         _EVTableView.dataSource = self;
         _EVTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
         _EVTableView.showsVerticalScrollIndicator = NO;
        _EVTableView.backgroundColor =[UIColor colorWithHexString:@"#fafafa"];
        [self addSubview: _EVTableView];
        [self createRefreshView];
       

    }
}
////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.20 11:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1241
 problem  : 教师账号互挤后，学生账号切换学生账号后，学生的课堂表现数据为空
 describe :  加入下拉刷新功能
 */
/////////////////////////////////////////////////////
-(void)createRefreshView
{
    
    MJRefreshNormalHeader *header                                           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    header.lastUpdatedTimeLabel.hidden                                      = YES;
    
    //设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateFinish];
    
    //设置字体
    header.stateLabel.font                                                  = [UIFont systemFontOfSize:13.0];
    header.stateLabel.textColor                                             = kF2_COLOR;
    
    //马上进入刷新状态
    
    //设置刷新控件
    _EVTableView.mj_header                                     = header;
}
-(void)endRefreshView
{
    if (_EVTableView.mj_header)
    {
        [_EVTableView.mj_header endRefreshing];
    }
}
-(void)refreshView
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenHandler:withCommandType:)])
    {
        [self.EVDelegate pEvenHandler:self withCommandType:ETTTEACHERMOMMANDENDREFRESHVIEW];
    }
}
-(void)setEVModel:(ETTClassPerformanceModel *)EVModel{
    if (EVModel)
    {
        _EVModel = EVModel;
        [_EVTableView reloadData];
        [self endRefreshView];
    }
}

#pragma mark --- table view delegate  -------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    return 64;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    
    
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
