//
//  ETTClassPerformanceVCTR.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
/**
 * 课堂表现
*/
#import "ETTManageViewController.h"
#import "ETTClassPerformanceModel.h"
#import "ETTCurrentClassPerformanceView.h"
#import "ETTAccumulativePerformanceView.h"
@interface ETTClassPerformanceVCTR : ETTManageViewController
@property (nonatomic,retain)ETTCurrentClassPerformanceView  * EVCurrentPerView;
@property (nonatomic,retain)ETTAccumulativePerformanceView  * EVAccumulativePerView;
@property (nonatomic,retain)UIButton                        * EVBackButton;
@property  (nonatomic,retain)ETTClassPerformanceModel * EVModel;
-(void)initData;
-(void)createTitleView;
-(void)createPagesView;
-(void)requestNetWork;
-(void)creatBackBtn;
-(NSInteger )getPageIndex;

-(void)changeToView:(NSInteger )index;
@end
