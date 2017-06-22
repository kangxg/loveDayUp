//
//  ETTClassListView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"
#import "ETTStudentManageViewModel.h"
@interface ETTClassListView : ETTView
@property (nonatomic,retain)ETTStudentManageViewModel  * EVModel;

-(ETTClassificationModel  * )getCurrentViewModel;

-(void)setRollCallSelected:(BOOL)isSeleted;

-(void)setResponderSelected:(BOOL)isSeleted;


-(void)serLockScreenSelected:(BOOL)isSeleted;
@end
