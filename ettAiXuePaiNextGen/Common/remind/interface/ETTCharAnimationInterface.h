//
//  ETTCharAnimationInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTRemindHeader.h"
#import "ETTRemindDelegate.h"

@protocol ETTCharAnimationInterface <NSObject>
@optional
@property (nonatomic,assign)NSInteger      EVAnimationCount;
@property (nonatomic,assign)NSInteger      EVType;

@property (nonatomic,assign)id<ETTRemindDelegate>  EVDelegate;


+(id<ETTCharAnimationInterface>)createAnimationView:(ETTCharAnimationViewType)ViewType withSuperView:(UIView *)superView info:(id)info;
-(instancetype)initAnimationView:(UIView *)superView info:(id)info;
-(instancetype)initAnimationView:(UIView *)superView withFrame:(CGRect)frame info:(id)info;


-(void)animatedAgain:(NSArray *)name;
//移除
-(void)removeAnimationView;
//解锁
@end
