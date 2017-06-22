//
//  ETTRedisWorkerManageInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTRedisWorkerInterface.h"
#import "ETTRedisMaintenanceReportInterface.h"
@class ETTRedisMaintenanceWorker;
@class ETTRedisWorkerModel;
@protocol ETTRedisWorkerManageInterface <NSObject>
@optional
/**
 Description 连接将要开始

 @param object 工作者
 */
-(void)manageWorkWillBegain:(ETTRedisWorkerModel *)worker;

/**
 Description 连接成功

 @param object 工作者
 */
-(void)manageWorkConnectSuccess:(ETTRedisWorkerModel *)worker;

/**
 Description  redis密码验证将要开始

 @param object 工作者
 */
-(void)manageWorkRegAuthPwdWillBegain:(ETTRedisWorkerModel *)worker;

/**
 Description 连接任务redis密码验证成功

 @param object 工作者
 */
-(void)manageWorkConnectRegAuthPwdSuccess:(ETTRedisWorkerModel *)worker;


/**
 Description 频道连接 redis密码验证成功
 
 @param object 工作者
 */
-(void)manageWorkChannelConnectRegAuthPwdSuccess:(ETTRedisWorkerModel *)worker;

/**
 Description  工作任务完成
 
 @param object 工作者
 @param err    错误对象
 */
-(void)manageWorkConnectFinished:(ETTRedisWorkerModel *)worker error:( NSError *)err;

/**
 Description  工作任务完成

 @param object 工作者
 @param err    错误对象
 */
-(void)manageWorkChannelConnectFinished:(ETTRedisWorkerModel *)worker error:( NSError *)err;

/**
 Description  连接工作失败

 @param object 工作者
 @param err    错误对象
 */
-(void)manageWorkConnectFail:(ETTRedisWorkerModel *)worker error:( NSError *)err;

/**
 Description  验证密码任务失败

 @param object 工作者
 @param err    错误对象
 */
-(void)manageWorkRegAuthPwdFail:(ETTRedisWorkerModel *)worker error:( NSError *)err;


/**
 Description  交班回调通知

 @param OnDuty     当班者
 @param succession 接班者
 */
-(void)manageWorkerHandove:(ETTRedisWorkerModel *)OnDuty succession:(ETTRedisWorkerModel *)succession;


/**
 Description  守护着注册频道

 @param worker      守护
 @param channelName 频道名称
 */
-(void)manageGuardWorkerReceivingSubcribtion:(ETTRedisWorkerModel *)worker withChannel:(NSString *)channelName;

/**
 Description 守护 推送消息失败

 @param worker 守护
 */
-(void)manageGuardWorkerPublishMessageToChannelFail:(ETTRedisWorkerModel *)worker;


/**
 Description 守护检测超时
 @param worker 守护
 */
-(void)manageGuardWorkerConnectionTimeout:(ETTRedisWorkerModel *)worker;


/**
 Description 守护检测成功后 唤醒其他任务

 @param worker 守护
 */
-(void)manageGuardWorkerConnectionWakeup:(ETTRedisWorkerModel *)worker;

/**
 Description 是否允许工作

 @param worker 调用的工作者
 @return 可以：yes 不可以：false
 */
-(BOOL)manageWorkerCanAllowedtowork:(ETTRedisWorkerModel *)worker;


/**
 Description 验证失败
 
 @param worker 调用的工作者
 @return
 */
-(void)manageWorkerReportAuthFail:(id<ETTRedisReportInterface>)worker;


-(void)DeliveryChannelData:(NSString * )message;


-(ETTRedisMaintenanceWorker *)callRedisRedisMaintenanceHelp;
@end
