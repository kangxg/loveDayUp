//
//  ETTRedisDataWarehouse.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTRedisHeader.h"

#import "ObjCHiredis.h"

/**
 Description redisbasisManager 存放的数据仓库
 */
@interface ETTRedisDataWarehouse : ETTBaseModel<NSCoding>
@property (nonatomic,copy)NSString                          *  EDServerHost;
@property (nonatomic,assign)NSInteger                          EDServerPort;
@property (nonatomic,copy)NSString                          *  EDPassword;
@property (nonatomic,copy)RespondHandler                       EDHandler;
///登录时redis服务器的格林威治时间。
@property (nonatomic,assign) NSTimeInterval                    EDRedisTime;
///登录时本地的格林威治时间。
@property (nonatomic,assign) NSTimeInterval                    EDLoginTime;

//@property (nonatomic,retain) NSMutableArray<NSString *>     *  EDChannelNameArray;

@property (nonatomic,retain) NSMutableSet  <NSString *>     *  EDChannelNameSet;
///用于非频道消息监听以外的其他操作。
@property (nonatomic,strong) ObjCHiredis                     *  EDCocoaRedis;
///用于监听频道消息
@property (nonatomic,strong) ObjCHiredis                     *  EDChannelRedis;


@property (atomic,assign)BOOL                                   EDHasRegChannel;
@property (nonatomic,assign) NSInteger                          EDHeartTime;

@property (nonatomic,retain)id <NSObject>                       EDOberserver;

-(void)resetDataHouse;

/**
 Description  重连重置
 */
-(void)reconnectionReset;

-(void)resetCocoaRedis;

-(void)resetChannelRedis;


-(void)removeOberServer;

-(void)registerOberServer:(void (^)(NSString *message))subscribeMessage;


-(void)dataWarehousing:(NSString *)message;


@end
