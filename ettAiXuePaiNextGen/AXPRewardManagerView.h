//
//  AXPRewardManagerView.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"

@interface AXPRewardManagerView : ETTView
@property(nonatomic ) BOOL isShow;
@property(nonatomic ,copy) void(^pushImageSuccessHandle)();
@property(nonatomic ,copy) void(^pushImageFailHandle)();

-(instancetype)initWithButtonType:(NSArray *)buttonType;

-(void)pushImageToStudentHandle:(void(^)())pushHandle endPushImageToStudentHandle:(void(^)())endPushHandle;

-(void)rewardStudent:(void(^)())rewardHandle;

- (void)hiddenRewardManagerView;

@end
