//
//  ETTStudentClassSelectView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"
#import "ETTClassPerformanceModel.h"
@interface ETTStudentClassSelectView : ETTView
@property (nonatomic,weak)ETTClassPerformanceModel * EVModel;
@property (nonatomic,assign)NSInteger                EVSelectIndex;
@property (nonatomic,assign) BOOL                    EVShowList;
-(void)reloadView;
-(void)show;
-(void)hidenView;
@end
