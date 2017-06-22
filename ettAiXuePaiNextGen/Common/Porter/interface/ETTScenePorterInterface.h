//
//  ETTScenePorterInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/5.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTScenePorterDelegate.h"
#import "ETTGuradBattalionChiefModel.h"
#import "ETTSideNavigationViewControllerDelegate.h"
@protocol ETTScenePorterInterface <NSObject>
@optional

/**
 Description 门卫管理着
 */
@property (nonatomic,retain)ETTGuradBattalionChiefModel  *   EVGuradManager;
/**
 Description 门卫系统代理
 */
@property (nonatomic,weak)id<ETTScenePorterDelegate>         EVPorterDelegate;

/**
 Description  
 */
@property (nonatomic,copy)NSString                       *   EVPortkeys;
/**
 Description 类方法 获取单例对象

 @return 
 */
+(instancetype)shareScenePorter;

/**
 Description 销毁单例
 */
+(void)attempDealloc;

/**
 Description 注册 小区管理 （分组管理，一个tabbar对应的类 对应一个分组管理，这里别名队长）

 @param vc       注册的视图控制器
 @param identity 系统标识符  这里只对老师端 起到 管理作用
 */
-(void )registerGuradCaptainManager:(ETTViewController *)vc type:(ETTSideNavigationViewIdentity)identity;

/**
 Description 是否可以打开

 @param vc       要打开的视图
 @param doorplat 门牌号

 @return 可以：yes  不可以：no
 */
-(BOOL)canOpenDoor:(ETTViewController *)vc withNum:(NSInteger)doorplat;
/**
 Description  注册一个门卫

 @return 无返回类型
 */

-(void )registerGurad:(ETTViewController *)vc withGuard:(ETTNormalGuardModel *) guardModel withHandle:(ETTGuradHandle)handle;

/**
 Description 移除 门卫

 @param guardModel  当前页面的门卫
 */
-(void)removeGurad:(ETTNormalGuardModel *) guardModel;


/**
 Description 注销快速返回备案
 */
-(void)cancellationRegistration:(ETTNormalGuardModel *)model;

/**
 Description 确定备案

 @param token 口令
 */
-(void)enterRegistration:(ETTNormalGuardModel * )model;

/**
 Description  记录行踪

 @param from    来自哪里
 @param current 去往哪里
 */
-(void)recordWhereabouts:(NSInteger)from to:(NSInteger)current;

/**
 Description  显示快速返回视图
 */
-(void)showPushingView;


/**
 Description 查询自己是否可以进行推送操作

 @param guardModel 所属自己的门卫model

 @return 如果快速返回登记中的信息和门卫的一致，则说明是自己的推送操作，可以进行推送和结束操作
 */
-(BOOL)queryWhetherCanPushOperation:(ETTNormalGuardModel *)guardModel;


/**
 Description 绑定一个视图到当前门卫上 用于视图控制器内的View快速返回

 @param guardModel 当前视图控制器的门卫
 @param view 绑定的视图
 */
-(void)bindingViewToGuardModel:(ETTNormalGuardModel *)guardModel withView:(UIView *)view;

/**
 Description 移除绑定的门卫

 @param guardModel 当前视图控制器的门卫
 @param view 绑定的视图
 */
-(void)removeTheBindingViewToGuardModel:(ETTNormalGuardModel *)guardModel withView:(UIView *)view;


/**
 Description 回到绑定的推送页面免打扰（不显示快速返回页面）

 @param guardModel 当前视图控制器的门卫
 @param view 绑定的视图
 */
-(void)donotDisturbBackIntoTheRoom:(ETTNormalGuardModel * )guardModel withView:(UIView *)view;
////复位
//-(void)resetScenePorterSystem;
@end
