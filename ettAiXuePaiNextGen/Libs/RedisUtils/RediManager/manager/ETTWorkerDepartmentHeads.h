//
//  ETTWorkerDepartmentHeads.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisWorkerManager.h"
#import "ETTRedisWorkerModel.h"
#import "ETTContinuousOperationWorker.h"
/**
 Description 部门领导
 */
@interface ETTWorkerDepartmentHeads : ETTRedisWorkerModel<NSCoding>
@property (nonatomic,retain)NSMutableArray<ETTContinuousOperationWorker *> * EDWorkerArr;

/**
 Description 通过key移除工作者

 @param key 工作者的标识
 */
-(void)removeWorker:(id)key;

/**
 Description 通过工作标识符 设置工作数据

 @param key  工作标识符
 @param dict 工作数据
 @return   如果通过工作标识符找到有对应的工作者返回真否则为假
 */
-(BOOL)setWorkerTask:(id)key withInfo:(NSDictionary *)dict;

/**
 Description  通过工作标识符获取 工作者

 @param key   工作标识符
 @return      工作者
 */
-(ETTContinuousOperationWorker *)haveWorkerWithTask:(id)key;


/**
 Description  通过工作标识符获取 工作者

 @param key   工作标识符
 @param Feild 工作标识符
 @return      工作者
 */
-(ETTContinuousOperationWorker *)haveWorkerWithTask:(id)key withField:(NSString *)Feild;

/**
 Description  挂起工作任务
 */
-(void)hangWorkersTask;

/**
 Description  唤醒工作任务
 */
-(void)wakeupWorkersTask;

/**
 Description  复活工作者

 @param respondHandler 任务结果回调
 */
-(void)resurrectionWorkers:(RespondHandler)respondHandler;


/**
 Description 开除工人
 
 @param key 任务标识符
 */
-(void)removeRedisWorker:(id)key;

/**
 Description 开除工人
 
 @param key 任务标识符
 */
-(void)removeRedisWorker:(id)key withFeile:(id)field;

@end

/**
 Description  连续设置部门领导
 */
@interface ETTContinuousSettingHeads : ETTWorkerDepartmentHeads

/**
 Description            构造函数

 @param key             工作标识符
 @param dict            工作数据
 @param type            工作任务类型
 @param time            时间间隔
 @param respondHandler  任务完成回调
 */
-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict type:(NSString *)type intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;
@end


/**
 Description  连续获取所有 部门领导
 */
@interface ETTContinuousGetALLHeads : ETTWorkerDepartmentHeads

/**
 Description            连续获取所有任务管理员 构造函数

 @param key             任务标识符
 @param time            时间间隔
 @param respondHandler  任务完成回调
 */
-(void)redisHGETALL:(id)key intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;
@end


/**
 Description  连续获取 单个 部门领导
 */
@interface ETTContinuousGetSingleHeads : ETTWorkerDepartmentHeads

/**
 Description            连续获取 单个任务管理员 构造函数

 @param key             任务标识符
 @param field           任务标识符
 @param time            时间间隔
 @param respondHandler  任务完成回调
 */
-(void)redisHGET:(id)key field:(id)field intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;
@end


/**
 Description  连续向频道推送消息
 */
@interface ETTContinuousSendChannelMsgHeads : ETTWorkerDepartmentHeads


/**
 Description            连续向频道推送消息

 @param channelName     频道名称
 @param message         工作数据
 @param time            时间间隔
 @param respondHandler  任务完成回调
 */
-(void)channelPublishMessage:(NSString *)channelName message:(NSDictionary *)message intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;



@end
