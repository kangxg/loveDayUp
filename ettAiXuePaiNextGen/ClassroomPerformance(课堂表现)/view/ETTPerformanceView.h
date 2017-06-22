//
//  ETTPerformanceView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"
#import "ETTPerformanceHeadView.h"
#import "ETTClassPerformanceModel.h"
@interface ETTPerformanceView : ETTView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)ETTPerformanceHeadView * EVHeadView;
@property (nonatomic,retain)UITableView            * EVTableView;
@property (nonatomic,weak)ETTClassPerformanceModel * EVModel;

-(void)createHeadView;
-(void)createTalbeView;

-(void)createRefreshView;

-(void)endRefreshView;
@end
