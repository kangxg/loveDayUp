//
//  ETTRemindViewInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTRemindHeader.h"
#import "ETTRemindDelegate.h"
@protocol ETTRemindViewInterface <NSObject>
@optional
@property (nonatomic,assign)NSInteger    YVType;
@property (nonatomic,assign)id<ETTRemindDelegate>  YVDelegate;
+(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType withSuperView:(UIView *)superView;

-(instancetype)initRemindView:(UIView *)superView ;

-(instancetype)initRemindView:(UIView *)superView withFrame:(CGRect)frame;

-(void)animatedAgain;
//移除
-(void)removeRemindview;
//解锁
-(void)deblockingRemindView;

@end
