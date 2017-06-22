//
//  ETTRedisServerManager.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/19.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisWorkerManager.h"
#import "RedisPrefix.pch"

#import "ETTRedisWorkerManager.h"
#import "ETTRedisHeader.h"
#import "ETTRedisManagerConst.h"
#import "ETTRedisServerDelegate.h"

@interface ETTRedisServerManager : ETTRedisWorkerManager

@property (nonatomic,weak) id<ETTRedisBasisDelegate>  EDDataSource;
//+(instancetype)sharedRedisManager;

/**
 Description 数据归档
 */
-(void)dataCodeing;

/**
 Description  异常推出数据归档
 */
-(void)redisDataArchiving;

/**
 Description  对异常退出 后进行数据复活
 */
-(void)redisDatarecovery;


/**
 Description 构造函数
 
 @param host 地址
 @param port 端口号
 @return redis 服务实例
 */
-(instancetype)initWithServerHost:(NSString *)host port:(int)port;


/**
 Description 重新设置 服务配置
 
 @param host 地址
 @param port 端口
 */
-(void)resetServerHost:(NSString *)host port:(int)port;


-(void)allObjectCreateConnectWithPassword:(NSString *)password respondHandler:(RespondHandler)responHandler;

-(void)receivingSubcribtionDataWithObserver:(id)mOberver channelNameArray:(NSArray *)channelNameArray respondHandler:(RespondHandler)respondHandler subscribeMessage:(void (^)(NSString *message))subscribeMessage;

-(void)publishMessageToChannel:(NSString *)channelName message:(NSString *)message respondHandler:(RespondHandler)respondHandler;

-(void)channelPublishMessage:(NSString *)channelName message:(NSDictionary *)message intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;
///关闭当前链接并退出。成功后返回@“OK”。
-(void)quit:(RespondHandler)respondHandler;

-(void)channelQuit:(RespondHandler)respondHandler;

-(void)allQuit:(RespondHandler)respondHandler;

-(void)echoString:(NSString *)echoStr respondHandler:(RespondHandler)respondHandler;

///获得当前redis服务器的版本，可以用来判断当前与服务器的链接状态。
-(void)getVersion:(RespondHandler)respondHandler;

-(void)pingHostGetRespondHandler:(RespondHandler)respondHandler;

-(void)channelPingHostGetRespondHandler:(RespondHandler)respondHanler;

#pragma mark ----- 键值对操作 ------
-(void)redisSet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler;

-(void)redisAsySet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler;
-(void)redisGet:(id)key respondHandler:(RespondHandler)respondHandler;

/*
 *  向服务器存储哈希表
 */
-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict respondHandler:(RespondHandler)respondHandler;
///连续获取数据，默认间隔时间1S
-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict type:(NSString *)type intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;




/*
 *  从服务器获取哈希表
 */
///获取key下的全部值
-(void)redisHGETALL:(id)key respondHandler:(RespondHandler)respondHandler;
///连续获取全部
-(void)redisHGETALL:(id)key intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;


///获取单个值
-(void)redisHGET:(id)key field:(id)field respondHandler:(RespondHandler)respondHandler;
///连续获取单个值，默认间隔时间为1S。
-(void)redisHGET:(id)key field:(id)field intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;

/**
 Description 删除连续设置任务
 
 @param key 任务标识符
 */
-(void)removeRedisHMSET:(id)key;
/**
 Description 删除连续获取所有任务
 
 @param key 任务标识符
 */
-(void)removeRedisHGETALL:(id)key;
/**
 Description 删除连续获取单值任务
 
 @param key 任务标识符
 */
-(void)removeRedisHGET:(id)key  withFeile:(id)field;;


-(NSTimeInterval)getLoginTime;

-(NSTimeInterval)getRedisTime;

@end
