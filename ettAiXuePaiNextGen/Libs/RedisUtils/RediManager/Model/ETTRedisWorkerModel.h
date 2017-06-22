//
//  ETTRedisWorkerModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTRedisDataHouseManageInterface.h"
#import "ETTRedisWorkerManageInterface.h"
#import "ETTRedisWorkerInterface.h"
#import "ETTRedisHeader.h"
/**
 Description redisManager  的操作工作者父类
 */

@interface ETTRedisWorkerModel : ETTBaseModel<ETTRedisWorkerInterface>

/**
 Description 雇主
 */
@property (nonatomic,weak,readonly)id<ETTRedisWorkerManageInterface>      EDEmployer;


/**
 Description 数据仓库管理员
 */
@property (nonatomic,weak,readonly)id<ETTRedisDataHouseManageInterface>   EDWarehouse;


@property (nonatomic,assign)CGFloat                                       EDNumberOfLinks;

/**
 Description 工作者构造函数

 @param dataHouseManager 雇主
 @param employers        仓库管理员

 @return 工作者
 */
-(instancetype)init:(id<ETTRedisDataHouseManageInterface>)dataHouseManager employers:(id<ETTRedisWorkerManageInterface>)employers ;


-(void)resetEmployer:(id<ETTRedisWorkerManageInterface>  )    EDEmployer;

-(void)resetHouseManager:(id<ETTRedisDataHouseManageInterface> )  EDWarehouse;
-(void)updateTimeWithCocoaRedis;

-(CGFloat)getSquare:(CGFloat)num withTime:(CGFloat)time;

-(void)updateTime:(NSDate *)redisDate;

-(void)getRedisTime:(RespondHandler)respondHandler;
-(void)initData;
-(void)workComplete;


-(void)stopWorker;

-(void)endWorker;


//将返回的数据 解析成字典
-(NSDictionary *)promiseNSDict:(id)value;
@end
