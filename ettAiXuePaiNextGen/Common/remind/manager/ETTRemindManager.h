//
//  ETTRemindManager.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTRemindViewInterface.h"
#import "ETTRemindHeader.h"
@interface ETTRemindManager : NSObject
+(instancetype)shareRemindManager;
//传入动画类型 父视图自动创建
-(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType ;
//传入动画类型 父视图自动创建  count 为动画显示的动画计数 主要用于 奖励动画
-(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType withCount:(NSInteger )count;
//传入动画类型 superView：父视图 参数
-(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType withSuperView:(UIView *)superView;
//传入动画类型 superView：父视图 参数  count

/**
 Description 创建动画 构造函数

 @param ViewType 动画类型
 @param superView 父视图
 @param count 动画计数
 @return 根据动画类型产生的动画
 */
-(id<ETTRemindViewInterface>)createRemindView:(ETTRemindViewType)ViewType withSuperView:(UIView *)superView withCount:(NSInteger )count;

/**
 Description  获取当前正在运行的 动画视图 与 构造函数的类型参数对应

 @return 动画视图
 */
-(id<ETTRemindViewInterface>)getRemindView;

/**
 Description  移除动画视图
 */
-(void)removeRemindView;


/**
 Description  解除锁屏 
 */
-(void)deblockingRemindView;


/**
 Description  结束抢答
 */
-(void)removeResponderRemindView;

/**
 Description  移除点名
 */
-(void)removeRollCallRemindView;




@end
