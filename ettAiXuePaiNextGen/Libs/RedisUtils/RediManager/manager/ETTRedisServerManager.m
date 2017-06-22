
//
//  ETTRedisServerManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/19.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisServerManager.h"
#import "ETTRedisDataWarehouse.h"
#import "ETTRedisDataHouseManager.h"
#import "ETTRedisWorkerModel.h"
#import "ETTRedisConnectWorker.h"
#import "ETTRedisSubscribeWorker.h"
#import "ETTRedisChannelConnectWorker.h"
#import "ETTRedisGuardianWorker.h"
#import "ETTUserInformationProcessingUtils.h"
#import "ETTRedisReceptionistWorker.h"
#import "ETTWorkerDepartmentHeads.h"
#import "ETTRedisPostOfficeModel.h"

#import "ETTRedisMaintenanceWorker.h"
@interface ETTRedisServerManager ()
{
}

/**
 Description 数据仓库
 */
@property (nonatomic,retain)ETTRedisDataWarehouse       *  MDDataHouse;

/**
 Description 仓库管理员
 */
@property (nonatomic,retain)ETTRedisDataHouseManager    *  MDDataHouseManager;

/**
 Description redis创建工作者
 */
@property (nonatomic,retain)ETTRedisWorkerModel         *  MDRedisWorker;

/**
 Description 联系设置数据 管理者
 */
@property (nonatomic,retain)ETTContinuousSettingHeads   *  MDConSettingHeads;

/**
 Description 连续获取全部数据 管理员
 */
@property (nonatomic,retain)ETTContinuousGetALLHeads    *  MDconGetallHeads;

/**
 Description 连续获取单个数据 管理员
 */
@property (nonatomic,retain)ETTContinuousGetSingleHeads *  MDConGetSingleHeads;
/**
 Description 连续向频道发送数据 管理员
 */
@property (nonatomic,retain)ETTContinuousSendChannelMsgHeads *  MDConPushChannelHeads;


/**
 Description 接收 频道消息邮局
 */
@property (nonatomic,retain)ETTRedisPostOfficeModel          *  MDRedisPostOfficeModel;

/**
 Description 前台工作者 负责非连续的数据操作
 */
@property (nonatomic,retain)ETTRedisReceptionistWorker * MDRecWorker;


/**
 Description  守护者
 */
@property (nonatomic,retain)ETTRedisGuardianWorker    * MDRedisGuard;

/**
 Description  维修工
 */
@property (nonatomic,retain)ETTRedisMaintenanceWorker * MDRedisMaintenanceWorker;
@end

@implementation ETTRedisServerManager
@synthesize     MDDataHouse         =   _MDDataHouse;
@synthesize     MDDataHouseManager  =   _MDDataHouseManager;
@synthesize     MDRedisWorker       =   _MDRedisWorker;
@synthesize     MDRecWorker         =   _MDRecWorker;

-(void)endWorker
{
    
    if(_MDconGetallHeads)
    {
        [_MDconGetallHeads endWorker];
    }
    
    if (_MDConSettingHeads )
    {
        [_MDConSettingHeads endWorker];
    }
    
    if (_MDconGetallHeads)
    {
        [_MDconGetallHeads endWorker];
    }
    
    if (_MDRedisGuard)
    {
        [_MDRedisGuard endWorker];
        _MDRedisGuard = nil;
    }
    
    
    
    
    if (_MDConPushChannelHeads)
    {
        
        [_MDConPushChannelHeads endWorker];
    }
    
    
    
    [self allQuit:^(id value, id error) {
        if (_MDDataHouseManager )
        {
            [_MDDataHouseManager endWork];
        }
        
        if (_MDRedisWorker)
        {
            [_MDRedisWorker endWorker];
            _MDRedisWorker = nil;
        }
    }];
    
}
-(void)dataCodeing
{
    NSString * SettingHeadsPath =[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Caches/SettingHeads"];
    [NSKeyedArchiver archiveRootObject:_MDConSettingHeads toFile:SettingHeadsPath];
    
    
    NSString * conGetallHeadsPath =[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Caches/conGetallHeads"];
    [NSKeyedArchiver archiveRootObject:_MDconGetallHeads toFile:conGetallHeadsPath];
    
    NSString * GetSingleHeadsPath =[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Caches/GetSingleHeads"];
    [NSKeyedArchiver archiveRootObject:_MDConGetSingleHeads toFile:GetSingleHeadsPath];
    
    NSString * RedisDataHousePath =[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Caches/RedisDataHouse"];
    [NSKeyedArchiver archiveRootObject:_MDDataHouse toFile:RedisDataHousePath];
    
    
    NSString * ConPushChannelHeadsPath =[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Caches/ConPushChannelHeads"];
    [NSKeyedArchiver archiveRootObject:_MDConPushChannelHeads toFile:ConPushChannelHeadsPath];
    
}
-(instancetype)initWithServerHost:(NSString *)host port:(int)port
{
    if (self = [super init])
    {
        ////////////////////////////////////////////////////////
        /*
         new      : ADD
         time     : 2017.3.27  14:45
         modifier : 康晓光
         version  ：bugfix/Epic-0327-AIXUEPAIOS-1140
         branch   ：bugfix/Epic-0327-AIXUEPAIOS-1140／AIXUEPAIOS-0327-984
         describe : 注册接收 SIGPIPE 崩溃信号量消息
         */
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sigpipeCollapseCallback) name:ETTSIGPIPECOLLAPSE object:nil];
        /////////////////////////////////////////////////////
       
        [self createDataHouseSystem:host port:port];
        
        ////////////////////////////////////////////////////////
        /*
         new      : ADD
         time     : 2017.3.30  12:04
         modifier : 康晓光
         version  ：bugfix/Epic-0322-AIXUEPAIOS-1124
         branch   ：bugfix/Epic-0322-AIXUEPAIOS-1124／AIXUEPAIOS-0322-984
         describe : 接收 SIGPIPE 崩溃信号量消息  ETTSIGPIPECOLLAPSE         */
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sigpipeCollapseCallback) name:ETTSIGPIPECOLLAPSE object:nil];

        /////////////////////////////////////////////////////
        
        _MDRecWorker         = [[ETTRedisReceptionistWorker alloc]init:_MDDataHouseManager employers:self];
        
        [self createMaintenanceWorker];
        [self createSettingHeads];
        [self createGetAllHeads];
        [self createGetSingleHeads];
        [self createConPushChannelMsgHeader];
        [self createConGetChannelMsgHeader];
        [self settingNetworkConnect];
        [self regitOutNitify];
    }
    return self;
}
////////////////////////////////////////////////////////
/*
 new      : ADD

 time     : 2017.3.30  12:04
 modifier : 康晓光
 version  ：bugfix/Epic-0322-AIXUEPAIOS-1124
 branch   ：bugfix/Epic-0322-AIXUEPAIOS-1124／AIXUEPAIOS-0322-984
 describe : 注册接收 SIGPIPE 崩溃信号量消息

 */
-(void)sigpipeCollapseCallback
{
    if (self.MDDataHouse.EDCocoaRedis == nil)
    {
        [self allObjectAgainCreateConnect];
        
    }
    else
    {
        [self allObjectAgainCreateConnect];
        
    }
    
}
/////////////////////////////////////////////////////
-(instancetype)init
{
    
    return [self initWithServerHost:nil port:0];
}

-(void)resetServerHost:(NSString *)host port:(int)port
{
    if (_MDDataHouseManager )
    {
        _MDDataHouseManager.EDServerPort = port;
        _MDDataHouseManager.EDServerHost = host;
    }else{
        _MDDataHouseManager = [ETTRedisDataHouseManager new];
        _MDDataHouseManager.EDServerPort = port;
        _MDDataHouseManager.EDServerHost = host;
    }
}
-(void)createDataHouseSystem:(NSString *)host port:(int)port
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.17  10:15
     modifier : 康晓光
     version  ：Epic-0315-AIXUEPAIOS-1077
     branch   ：AIXUEPAIOS-0315-939
     describe : 两个教师同时上课时，教师A的学生收到了教师B的指令（奖励提醒）
     operation: 去除对本地存档的恢复
     */
    //NSString * RedisDataHousePath =[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Caches/RedisDataHouse"];
    //_MDDataHouse=[NSKeyedUnarchiver unarchiveObjectWithFile:RedisDataHousePath];
    // else
    //    {
    //        _MDDataHouseManager  = [[ETTRedisDataHouseManager alloc]init:self withHouse:_MDDataHouse];
    //        [self removeCoding:RedisDataHousePath];
    //    }
    /////////////////////////////////////////////////////

    if (_MDDataHouse== nil)
    {
        _MDDataHouse         = [[ETTRedisDataWarehouse alloc]init];
        _MDDataHouseManager  = [[ETTRedisDataHouseManager alloc]init:self withHouse:_MDDataHouse];
        _MDDataHouseManager.EDServerPort = port;
        _MDDataHouseManager.EDServerHost = host;
        
    }
    
}
-(void)redisDataArchiving
{
    [self dataCodeing];
    [self allQuit:^(id value, id error) {
        
    }];
}

-(void)redisDatarecovery
{
    [self createSettingHeads];
    [self createGetAllHeads];
    [self createGetSingleHeads];
    [self createConPushChannelMsgHeader];
    [self allObjectCreateConnectWithPassword:nil respondHandler:^(id value, id error) {
        
    }];
}

-(void)settingNetworkConnect
{
    WS(weakSelf);
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown)
        {
            
            [weakSelf.MDRedisGuard endWorker];
        }
        else
        {

           [self allObjectAgainCreateConnect];
        }
    }];
}
-(void)regitOutNitify
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillTerminateNotification) name:UIApplicationWillTerminateNotification  object:nil];
}
-(void)appWillTerminateNotification
{
    [self dataCodeing];
    [self allQuit:^(id value, id error) {
        
    }];
}
-(void)createMaintenanceWorker
{
    if (_MDRedisMaintenanceWorker == nil)
    {
        _MDRedisMaintenanceWorker = [[ETTRedisMaintenanceWorker alloc]init:_MDDataHouseManager employers:self];
    }
}
-(void)createSettingHeads
{
    if (_MDConSettingHeads == nil)
    {
        _MDConSettingHeads   = [[ETTContinuousSettingHeads  alloc]init:_MDDataHouseManager employers:self];
    }
    
}

-(void)createGetAllHeads
{
    if (_MDconGetallHeads == nil)
    {
        _MDconGetallHeads  = [[ETTContinuousGetALLHeads  alloc]init:_MDDataHouseManager employers:self];
    }
    
}

-(void)createGetSingleHeads
{
        if (_MDConGetSingleHeads == nil)
        {
            _MDConGetSingleHeads   = [[ETTContinuousGetSingleHeads  alloc]init:_MDDataHouseManager employers:self];
        }
    
}

-(void)createConPushChannelMsgHeader
{
    
    if (_MDConPushChannelHeads  == nil)
    {
        _MDConPushChannelHeads    = [[ETTContinuousSendChannelMsgHeads alloc]init:_MDDataHouseManager employers:self];
    }

}

-(void)createConGetChannelMsgHeader
{
    if (_MDRedisPostOfficeModel == nil)
    {
        _MDRedisPostOfficeModel    = [[ETTRedisPostOfficeModel alloc]init:_MDDataHouseManager employers:self];
    }
}
-(void)removeCoding:(NSString *)path
{
    NSFileManager * manager=[NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
}
-(ETTRedisGuardianWorker *)MDRedisGuard
{
    if (_MDRedisGuard == nil)
    {
        _MDRedisGuard = [[ETTRedisGuardianWorker alloc]init:_MDDataHouseManager employers:self];
    }
    return _MDRedisGuard;
}
#pragma mark ----- allObjectCreateConnectWithPassword ------

-(void)allObjectCreateConnectWithPassword:(NSString *)password respondHandler:(RespondHandler)responHandler
{
    
    [_MDDataHouseManager setConnectResponHandler:responHandler];
    if (password.length)
    {
        [_MDDataHouseManager setWorkPassword:password];
    }
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_queue_t qt = dispatch_queue_create("redisConnectStart", DISPATCH_QUEUE_SERIAL);
    
    
    WS(weakSelf);
    
    dispatch_async(qt, ^{
         dispatch_semaphore_wait(semaphore, 20);
           [weakSelf allObjectAgainCreateConnect];
          dispatch_semaphore_signal(semaphore);
    });
 
    
}

-(void)allObjectAgainCreateConnect
{
    if (_MDRedisGuard)
    {
        [_MDRedisGuard endWorker];
    }

    WS(weakSelf);
    if (self.MDDataHouse)
    {
        [self reconnectionQuit:^(id value, id error) {
            if (error) {
                NSLog(@"quit was wrong!");
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf redisConnectStart];
//                });
                 [weakSelf redisConnectStart];
            }else
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf redisConnectStart];
//                });
                [weakSelf redisConnectStart];
            }
            
        }];
    }
        
    else
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf redisConnectStart];
//        });
        [weakSelf redisConnectStart];
        
    }
}

-(void)redisConnectError
{
    
    CGFloat intervalTime = kREDIS_CONNECT_DEFAULT_INTERVAL;
    
    dispatch_time_t mTime = dispatch_time(DISPATCH_TIME_NOW, intervalTime*NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_queue_create("ettConnect", DISPATCH_QUEUE_CONCURRENT);
    dispatch_after(mTime, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self allObjectAgainCreateConnect];
            
        });
    });
    
}
-(void)redisConnectStart
{
    _MDRedisWorker =[[ETTRedisConnectWorker alloc]init:_MDDataHouseManager employers:self];
    
    [_MDRedisWorker startsWorker];
    
}
#pragma mark
#pragma mark ---------------- 连接回调 -------------------

-(void)manageWorkConnectSuccess:(ETTRedisWorkerModel *)worker
{
    
}


/**
 Description 连接任务redis密码验证成功
 
 @param object 工作者
 */
-(void)manageWorkConnectRegAuthPwdSuccess:(ETTRedisWorkerModel *)worker
{
    
}


/**
 Description 频道连接 redis密码验证成功
 
 @param object 工作者
 */
-(void)manageWorkChannelConnectRegAuthPwdSuccess:(ETTRedisWorkerModel *)worker
{
    RespondHandler  handle = [_MDDataHouseManager getRespondBackHandle];
    if (handle)
    {
        handle(self,nil);
    }
}

-(void)manageWorkRegAuthPwdFail:(ETTRedisWorkerModel *)worker error:( NSError *)err
{
    [self manageWorkConnectFail:worker error:err];
}

-(void)manageWorkConnectFail:(ETTRedisWorkerModel *)worker error:( NSError *)err
{
    if (_MDRedisWorker == nil)
    {
        _MDRedisWorker = [[ETTRedisConnectWorker alloc]init:_MDDataHouseManager employers:self];
        
    }
    RespondHandler  handle = [_MDDataHouseManager getRespondBackHandle];
    if (handle)
    {
        handle(self,nil);
    }
    [_MDRedisWorker workAgain];
    
    
}

-(void)manageWorkerHandove:(ETTRedisWorkerModel *)OnDuty succession:(ETTRedisWorkerModel *)succession
{
    
    if (succession)
    {
        
        _MDRedisWorker = succession;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_MDRedisWorker startsWorker];
        });
    }
    
}

-(void)manageWorkConnectFinished:(ETTRedisWorkerModel *)worker error:( NSError *)err
{
    if (err == nil)
    {
        ////////////////////////////////////////////////////////
        /*
         new      : ADD
         time     : 2017.3.30  12:04
         modifier : 康晓光
         version  ：bugfix/Epic-0322-AIXUEPAIOS-1124
         branch   ：bugfix/Epic-0322-AIXUEPAIOS-1124／AIXUEPAIOS-0322-984
         describe : 系统异常崩溃类型 redis 连接完成发送消息
         */
        [[NSNotificationCenter defaultCenter]postNotificationName:ETTREDISCONNECTFINISH object:nil];
        ///////////////////////////////////////////////////////

        [_MDRedisWorker stopWorker];
        _MDRedisWorker = nil;
        [self.MDRedisGuard startsWorker];
        [_MDRedisPostOfficeModel resetHouseManager:_MDDataHouseManager ];
        [_MDRedisPostOfficeModel startsWorker];
        
    }
}


-(void)manageGuardWorkerReceivingSubcribtion:(ETTRedisWorkerModel *)worker withChannel:(NSString *)channelName
{
    if (worker == _MDRedisGuard)
    {
        WS(weakSelf);
        [self receivingSubcribtionDataWithObserver:nil channelNameArray:@[channelName] respondHandler:^(id value, id error)
         {
             if (error) {
                 NSLog(@"测试频道订阅失败!");
                 [weakSelf.MDRedisGuard guardChannelSubscribeWorkFail];
                 
             }else
             {
                 NSLog(@"测试频道订阅成功!");
                 [weakSelf.MDRedisGuard guardChannelSubscribeWorkSuccess];
                 
             }
             
         } subscribeMessage:^(NSString *message) {
             // NSLog(@"** 提示 ** 收到测试消息：%@",message);
         }];
    }
}

-(void)manageGuardWorkerPublishMessageToChannelFail:(ETTRedisWorkerModel *)worker
{
    [self allObjectAgainCreateConnect];
}

-(void)manageGuardWorkerConnectionTimeout:(ETTRedisWorkerModel *)worker
{
       
    [self allObjectAgainCreateConnect];
    
}

-(void)manageGuardWorkerConnectionWakeup:(ETTRedisWorkerModel *)worker
{
    if (_MDConSettingHeads)
    {
        [_MDConSettingHeads wakeupWorkersTask];
    }
    if (_MDConGetSingleHeads)
    {
        [_MDConGetSingleHeads  wakeupWorkersTask];
    }
    if (_MDconGetallHeads)
    {
        [_MDconGetallHeads  wakeupWorkersTask];
        
    }
    if (_MDConPushChannelHeads)
    {
        
        [_MDConPushChannelHeads wakeupWorkersTask];
    }
    
}

-(BOOL)manageWorkerCanAllowedtowork:(ETTRedisWorkerModel *)worker
{
    if (_MDRedisGuard== nil)
    {
        return YES;
    }
    
    return [_MDRedisGuard getAllowToOperation];
}

-(void)receivingSubcribtionDataWithObserver:(id)mOberver channelNameArray:(NSArray *)channelNameArray respondHandler:(RespondHandler)respondHandler subscribeMessage:(void (^)(NSString *message))subscribeMessage
{
    WS(weakSelf);
    
    [self UNSubscribe:^(id value, id error) {
        
        if (error)
        {
             respondHandler(value,error);
        }
        else
        {
            if (_MDDataHouse.EDChannelRedis)
            {
                [weakSelf channelForReceivingSubcribtionDataWithObserver:nil channelNameArray:channelNameArray respondHandler:^(id value, id error) {
                    respondHandler(value,error);
                }
                                                        subscribeMessage:^(NSString *message)
                 {
                     if (weakSelf.EDDataSource&&[weakSelf.EDDataSource respondsToSelector:@selector(processChannelMessage:)])
                     {
                         [weakSelf.EDDataSource processChannelMessage:message];
                     }
                     if (subscribeMessage)
                     {
                         subscribeMessage(message);
                     }
                     
                 }];
            }

        }
    }];
}

-(void)DeliveryChannelData:(NSString * )message
{
    if (self.EDDataSource&&[self.EDDataSource respondsToSelector:@selector(processChannelMessage:)])
    {
        [self.EDDataSource processChannelMessage:message];
    }
}
-(void)channelForReceivingSubcribtionDataWithObserver:(id)mOberver channelNameArray:(NSArray *)channelNameArray respondHandler:(RespondHandler)respondHandler subscribeMessage:(void (^)(NSString *message))subscribeMessage
{
    WS(weakSelf);
    if (_MDDataHouse.EDChannelRedis)
    {
        [_MDDataHouseManager putinChannelWithArr:channelNameArray];
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
        NSArray *sortSetArray = [_MDDataHouse.EDChannelNameSet sortedArrayUsingDescriptors:sortDesc];
        
        
        NSMutableArray* command = [NSMutableArray arrayWithObject: @"SUBSCRIBE"];
        [command addObjectsFromArray: sortSetArray];
        id value = [_MDDataHouse.EDChannelRedis  commandArgv:command];
        
        if (value)
        {
            weakSelf.MDDataHouseManager.EDHasRegChannel = YES;
            [weakSelf.MDDataHouseManager registerOberServer:subscribeMessage];
            NSLog(@"当前创建频道监听  is %@",[NSThread currentThread]);
            if (_MDRedisPostOfficeModel)
            {
                [_MDRedisPostOfficeModel registeredChannelPublishMessages:sortSetArray respondHandler:^(id value, id error) {
                    
                }];
                
            }
            respondHandler(value,nil);
            
            
        }
        else
        {
            NSError * err = [NSError errorWithDomain:@"收到频道消息失败" code:2014 userInfo:nil];
            respondHandler(nil,err);
        }
    }
    
}

-(void)UNSubscribe:(RespondHandler)respondHandler
{
    if (_MDDataHouse.EDChannelRedis)
    {
        @synchronized (_MDDataHouse.EDChannelRedis)
        {
           
            NSMutableArray* command = [NSMutableArray arrayWithObject: @"SUBSCRIBE"];
            [command addObjectsFromArray: @[@"test"]];
            
            id value = [_MDDataHouse.EDChannelRedis  commandArgv:command];
            if (value)
            {
                NSString *commStr = @"UNSUBSCRIBE";
                id result =  [_MDDataHouse.EDChannelRedis command:commStr];
                
                if (result)
                {
                    respondHandler(result,nil);
                }
                else
                {
                    NSError * err = [NSError errorWithDomain:ETTRedisCommondUNSubscribError code:ETTREDISERRORTYUNSUBSCRIBE userInfo:nil];
                    respondHandler(nil,err);
                }

                
            }
            else
            {
                respondHandler(@"ok",nil);

            }
        }
    }
    
}

-(void)publishMessageToChannel:(NSString *)channelName message:(NSString *)message respondHandler:(RespondHandler)respondHandler
{
    if (_MDRecWorker == nil)
    {
        return;
    }
    
    if (_MDConSettingHeads)
    {
        if (![_MDConSettingHeads setWorkerTask:channelName withInfo:[ETTRedisBasisManager getDictionaryWithJSON:message]])
        {
            [_MDRecWorker publishMessageToChannel:channelName message:message respondHandler:respondHandler];
        }
    }
}
-(void)channelPublishMessage:(NSString *)channelName message:(NSDictionary *)message intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    if (_MDConPushChannelHeads)
    {
        [_MDConPushChannelHeads channelPublishMessage:channelName message:message intervalTime:time respondHandler:respondHandler];
    }
}
#pragma mark   获取所用链接

-(void)quit:(RespondHandler)respondHandler
{
    WS(weakSelf);
    if (self.MDDataHouse.EDCocoaRedis == nil)
    {
        respondHandler(@"ok",nil);
        return;
    }
    [self.MDDataHouse.EDCocoaRedis close];
    if (_MDRedisPostOfficeModel)
    {
        [_MDRedisPostOfficeModel endWorker];
    }
    [_MDRedisGuard endWorker];
    
    [weakSelf.MDDataHouse resetCocoaRedis];
    respondHandler(@"ok",nil);
}
#pragma mark   退出所有频道
-(void)channelQuit:(RespondHandler)respondHandler
{
  
    
    if (self.MDDataHouse.EDChannelRedis  == nil)
    {
        respondHandler(@"ok",nil);
        
        return;
    }
    WS(weakSelf);
    if (_MDRedisPostOfficeModel)
    {
        [_MDRedisPostOfficeModel endWorker];
    }
    [weakSelf.MDDataHouse resetChannelRedis];
    respondHandler(@"ok",nil);
    
}

-(void)reconnectionQuit:(RespondHandler)respondHandler
{
    WS(weakSelf);
    
    if (_MDRedisPostOfficeModel)
    {
        [_MDRedisPostOfficeModel endWorker];
    }
    
    if (_MDRedisGuard)
    {
        [_MDRedisGuard endWorker];
    }
    if (self.MDDataHouse.EDCocoaRedis )
    {
        [weakSelf.MDDataHouse resetCocoaRedis];
    }
    if (_MDRedisPostOfficeModel)
    {
        [_MDRedisPostOfficeModel endWorker];
    }

    if (self.MDDataHouse.EDChannelRedis )
    {
        
        [weakSelf.MDDataHouse resetChannelRedis];
        
    }
    respondHandler(@"ok",nil);
}
#pragma mark   全部退出
-(void)allQuit:(RespondHandler)respondHandler
{
    
    
    if (_MDRedisPostOfficeModel)
    {
        [_MDRedisPostOfficeModel endWorker];
    }
    
    WS(weakSelf);
   
  

    [self quit:^(id value, id error) {
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                respondHandler(value,error);
            });
            
        }
        else
        {
            
            [weakSelf channelQuit:^(id value, id error) {
                if (error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        respondHandler(value,error);
                    });
                    
                }
                else
                {
                    [weakSelf.MDDataHouse resetDataHouse];
                    dispatch_async(dispatch_get_main_queue(), ^{

                        respondHandler(value,error);
                    });
                    
                }
            }];
        }
    }];
}

#pragma mark   获取版本信息
-(void)getVersion:(RespondHandler)respondHandler
{
    if (self.MDDataHouseManager.EDCocoaRedis)
    {
    }
    
}

#pragma mark   输出信息
-(void)echoString:(NSString *)echoStr respondHandler:(RespondHandler)respondHandler
{
    if (self.MDDataHouseManager.EDCocoaRedis)
    {
    }
    
}

#pragma mark   ping
-(void)pingHostGetRespondHandler:(RespondHandler)respondHandler
{
    if (self.MDDataHouseManager.EDCocoaRedis)
    {
        __block BOOL state = YES;
        NSArray *cmArr=@[@"PING"];
            }
}
#pragma mark   ping 频道
-(void)channelPingHostGetRespondHandler:(RespondHandler)respondHanler
{
    if (self.MDDataHouseManager.EDChannelRedis)
    {
    }
}


#pragma mark
#pragma mark ----- 以下是键值对操作区域 ------
#pragma mark  通过key进行设置
-(void)redisSet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler
{
    if (_MDRecWorker == nil)
    {
        return;
    }
    [_MDRecWorker redisSet:key value:value respondHandler:respondHandler];
}

-(void)redisAsySet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler
{
    if (_MDRecWorker == nil)
    {
        return;
    }
    [_MDRecWorker redisAsySet:key value:value respondHandler:respondHandler];
}
#pragma mark  通过key 获取值

-(void)redisGet:(id)key respondHandler:(RespondHandler)respondHandler
{
    if (_MDRecWorker == nil)
    {
        return;
    }
    [_MDRecWorker redisGet:key respondHandler:respondHandler];
}
#pragma mark 向服务器存储哈希表

-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict respondHandler:(RespondHandler)respondHandler
{
    if (_MDRecWorker == nil)
    {
        return;
    }
    if (_MDConSettingHeads)
    {
        if (![_MDConSettingHeads setWorkerTask:key withInfo:dict])
        {
            [_MDRecWorker redisHMSET:key dictionary:dict respondHandler:respondHandler];
        }
        
    }
}

#pragma mark 获取key下的全部值
-(void)redisHGETALL:(id)key respondHandler:(RespondHandler)respondHandler
{
    if (_MDRecWorker == nil)
    {
        return;
    }
    
    
    [_MDRecWorker redisHGETALL:key respondHandler:respondHandler];
    
}
#pragma mark 获取单个值

-(void)redisHGET:(id)key field:(id)field respondHandler:(RespondHandler)respondHandler
{
    if (_MDRecWorker == nil)
    {
        return;
    }
    [_MDRecWorker redisHGET:key field:field respondHandler:respondHandler];
    
}
//
#pragma mark 连续获取数据，默认间隔时间1S

-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict type:(NSString *)type intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    if (_MDConSettingHeads)
    {
        [_MDConSettingHeads redisHMSET:key dictionary:dict type:type intervals:time respondHandler:respondHandler];
    }
    
}


#pragma mark 连续获取全部

-(void)redisHGETALL:(id)key intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    if (_MDconGetallHeads)
    {
        [_MDconGetallHeads redisHGETALL:key intervals:time respondHandler:respondHandler];
    }
}

#pragma mark 获取单个

-(void)redisHGET:(id)key field:(id)field intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    if (_MDConGetSingleHeads)
    {
        [_MDConGetSingleHeads redisHGET:key field:field intervals:time respondHandler:respondHandler];
    }
}
#pragma mark 删除单个连续任务
-(void)removeRedisHGET:(id)key withFeile:(id)field
{
    if (_MDConGetSingleHeads)
    {
        [_MDConGetSingleHeads removeRedisWorker:key withFeile:field];
    }
}

#pragma mark 删除获取所有值任务
-(void)removeRedisHGETALL:(id)key
{
    if (_MDconGetallHeads)
    {
        [_MDconGetallHeads removeRedisWorker:key];
    }
}

#pragma mark 删除连续设置任务
-(void)removeRedisHMSET:(id)key
{
    if (_MDConSettingHeads)
    {
        [_MDConSettingHeads removeRedisWorker:key];
    }
}
-(NSTimeInterval)getLoginTime
{
    return _MDDataHouse.EDLoginTime;
}

-(NSTimeInterval)getRedisTime
{
    return _MDDataHouse.EDRedisTime;
}


-(ETTRedisMaintenanceWorker *)callRedisRedisMaintenanceHelp
{
    if (_MDRedisMaintenanceWorker == nil)
    {
        [self createMaintenanceWorker];
    }
    
    return _MDRedisMaintenanceWorker;
}


-(void)manageWorkerReportAuthFail:(id<ETTRedisReportInterface>)worker
{
    if (worker)
    {
        [self allObjectAgainCreateConnect];
    }
}
@end
