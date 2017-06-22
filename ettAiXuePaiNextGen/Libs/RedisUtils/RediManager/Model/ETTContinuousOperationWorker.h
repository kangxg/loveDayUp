//
//  ETTContinuousOperationWorker.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisWorkerModel.h"

/**
 Description  连续数据操作工作者
 */
@interface ETTContinuousOperationWorker : ETTRedisWorkerModel<NSCoding>
@property (nonatomic,assign)NSTimeInterval           EDWorkTimeInterval;
@property (nonatomic,retain)NSDictionary         *   EDWorkInfoDic;
@property (nonatomic,copy)NSString               *   EDOperationKey;
@property (nonatomic,retain)NSString             *   EDField;
@property (nonatomic,copy)RespondHandler             EDHandlerblock;
@property (nonatomic,retain)dispatch_queue_t         EDOperQueue;
@property (nonatomic,copy)NSString               *   EDWorkType;

-(void)hangWorkerTask;

-(void)wakeupWorkerTask;

-(void)startRedisWork;

-(void)createOperQueue;
@end


/**
 Description 连续数据设置
 */
@interface ETTContinuousSettingWorker : ETTContinuousOperationWorker
-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict type:(NSString *)type intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;

-(void)redisHMSETesurrection:(RespondHandler)respondHandler;
@end



/**
 Description 连续获取所用
 */
@interface ETTContinuousGetALLWorker : ETTContinuousOperationWorker
-(void)redisHGETALL:(id)key intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;
-(void)redisHGETALLTesurrection:(RespondHandler)respondHandler;
@end


/**
 Description 连续获取单个
 */
@interface ETTContinuousGetSingleWorker : ETTContinuousOperationWorker

-(void)redisHGET:(id)key field:(id)field intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;
-(void)redisHGETTesurrection:(RespondHandler)respondHandler;

@end


/**
 Description 连续获取单个
 */
@interface ETTContinuousPushChannelWorker : ETTContinuousOperationWorker

-(void)channelPublishMessage:(NSString *)channelName message:(NSDictionary *)message intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;

-(void)redisPushChannelTesurrection:(RespondHandler)respondHandler;

@end



@interface ETTContinuousGetChannelMsgWorker : ETTContinuousOperationWorker
@property(nonatomic,retain,readonly)NSMutableArray <NSString *>  *  EDChannelNames;
-(void)channelMessage:(NSString *)channelName  respondHandler:(RespondHandler)respondHandler;

-(void)redisChannelTesurrection:(RespondHandler)respondHandler;

@end


