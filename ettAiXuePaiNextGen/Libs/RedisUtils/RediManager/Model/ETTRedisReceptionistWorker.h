//
//  ETTRedisReceptionistWorker.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

/**
 Description 前台工作者

 @return 负责非连续性 数据收发
 */
#import "ETTRedisWorkerModel.h"

@interface ETTRedisReceptionistWorker : ETTRedisWorkerModel
-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict respondHandler:(RespondHandler)respondHandler;
-(void)redisGet:(id)key respondHandler:(RespondHandler)respondHandler;

-(void)redisSet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler;
-(void)redisAsySet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler;
-(void)redisHGETALL:(id)key respondHandler:(RespondHandler)respondHandler;


-(void)redisHGET:(id)key field:(id)field respondHandler:(RespondHandler)respondHandler;


-(void)publishMessageToChannel:(NSString *)channelName message:(NSString *)message respondHandler:(RespondHandler)respondHandler;
@end
