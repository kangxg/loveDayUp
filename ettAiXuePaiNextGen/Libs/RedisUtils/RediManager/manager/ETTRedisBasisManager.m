//
//  ETTRedisBasisManager.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 2016/10/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisBasisManager.h"

#import "ETTRedisServerManager.h"

@interface ETTRedisBasisManager ()
{
    
    ETTRedisServerManager  * _mRedisServer;
}
@property (nonatomic,retain)ETTRedisServerManager  * MDRedisServer;

@property (nonatomic,assign) RedisStateEnum         mState;

@end

@implementation ETTRedisBasisManager
@synthesize     MDRedisServer      =   _mRedisServer;
@synthesize     MDelegate          =   _MDelegate;
@synthesize     mDataSource        =   _mDataSource;


@synthesize     heartBeatState     =   _heartBeatState;
static ETTRedisBasisManager *redisManager = nil;
static dispatch_once_t onceRedisToken;
+(instancetype)sharedRedisManager
{
    
    dispatch_once(&onceRedisToken, ^{
        redisManager = [[ETTRedisBasisManager alloc]init];
    });
    return redisManager;
    
}



-(void)setMDataSource:(id<ETTRedisBasisDelegate>)mDataSource
{
    if (mDataSource)
    {
        _mDataSource = mDataSource;
    }
    
    if (_mRedisServer)
    {
        _mRedisServer.EDDataSource = mDataSource;
    }
}

-(id<ETTRedisBasisDelegate>)mDataSource
{
    if (_mRedisServer)
    {
        return _mRedisServer.EDDataSource;
    }
    return nil;
}

/**
 Description 数据归档
 */
-(void)dataCodeing
{
    if (_mRedisServer )
    {
        [_mRedisServer dataCodeing];
    }
}

/**
 Description  异常推出数据归档
 */
-(void)redisDataArchiving
{
    if (_mRedisServer )
    {
        [_mRedisServer redisDataArchiving];
    }
}

/**
 Description  对异常退出 后进行数据复活
 */
-(void)redisDatarecovery
{
    if (_mRedisServer == nil)
    {
        [_mRedisServer redisDatarecovery];
    }
}

/**
 Description  初始化server类
 
 @param host 目标地址
 @param port 端口
 */
-(void)initWithServerHost:(NSString *)host port:(int)port
{
    
    if (_mRedisServer == nil)
    {
        _mRedisServer = [[ETTRedisServerManager alloc]initWithServerHost:host port:port];
    }
    else
    {
        [_mRedisServer resetServerHost:host port:port];
    }
    
    _mRedisServer.EDDataSource = _mDataSource;
    
    
}


-(void)channelForConnectHostWithPassword:(NSString *)password respondHandler:(RespondHandler)respondHandler
{
    return [self allObjectCreateConnectWithPassword:password respondHandler:respondHandler];
}

#pragma mark ----- allObjectCreateConnectWithPassword ------

-(void)allObjectCreateConnectWithPassword:(NSString *)password respondHandler:(RespondHandler)responHandler
{
    
    if (_mRedisServer)
    {
        [_mRedisServer allObjectCreateConnectWithPassword:password respondHandler:responHandler];
    }
    
}



-(void)echoString:(NSString *)echoStr respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer )
    {
        [_mRedisServer echoString:echoStr respondHandler:respondHandler];
    }
    
}

-(void)getVersion:(RespondHandler)respondHandler
{
    if (_mRedisServer )
    {
        [_mRedisServer getVersion:respondHandler];
    }
    
}

-(void)quit:(RespondHandler)respondHandler
{
    if (_mRedisServer )
    {
        [_mRedisServer quit:respondHandler];
    }
    
}

-(void)channelQuit:(RespondHandler)respondHandler
{
    if (_mRedisServer )
    {
        [_mRedisServer channelQuit:respondHandler];
    }
}

-(void)allQuit:(RespondHandler)respondHandler
{
    if (_mRedisServer )
    {
        [_mRedisServer allQuit:respondHandler];
    }
}

-(void)pingHostGetRespondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer)
    {
        [_mRedisServer pingHostGetRespondHandler:respondHandler];
    }
}

-(void)channelPingHostGetRespondHandler:(RespondHandler)respondHanler
{
    if (_mRedisServer)
    {
        [_mRedisServer channelPingHostGetRespondHandler:respondHanler];
    }
}

-(void)receivingSubcribtionDataWithObserver:(id)mOberver channelNameArray:(NSArray *)channelNameArray respondHandler:(RespondHandler)respondHandler subscribeMessage:(void (^)(NSString *message))subscribeMessage
{
    if (_mRedisServer)
    {
        [_mRedisServer receivingSubcribtionDataWithObserver:mOberver channelNameArray:channelNameArray respondHandler:respondHandler subscribeMessage:subscribeMessage];
    }
}


-(void)channelForReceivingSubcribtionDataWithObserver:(id)mOberver channelNameArray:(NSArray *)channelNameArray respondHandler:(RespondHandler)respondHandler subscribeMessage:(void (^)(NSString *message))subscribeMessage
{
    [self receivingSubcribtionDataWithObserver:mOberver channelNameArray:channelNameArray respondHandler:respondHandler subscribeMessage:subscribeMessage];
}


-(void)publishMessageToChannel:(NSString *)channelName message:(NSString *)message respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer )
    {
        [_mRedisServer publishMessageToChannel:channelName message:message respondHandler:respondHandler];
    }
    
}


-(void)channelPublishMessage:(NSString *)channelName message:(NSDictionary *)message intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    
    if (_mRedisServer)
    {
        [_mRedisServer channelPublishMessage:channelName message:message intervalTime:time respondHandler:respondHandler];
    }
}

-(void)redisSet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer)
    {
        [_mRedisServer redisSet:key value:value respondHandler:respondHandler];
    }
    
}

-(void)redisAsySet:(id)key value:(id)value respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer)
    {
        [_mRedisServer redisAsySet:key value:value respondHandler:respondHandler];
    }
}
-(void)redisGet:(id)key respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer)
    {
        [_mRedisServer redisGet:key respondHandler:respondHandler];
    }
    
}

-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict respondHandler:(RespondHandler)respondHandler
{
    
    if (_mRedisServer)
    {
        [_mRedisServer redisHMSET:key dictionary:dict respondHandler:respondHandler];
    }
    
}


-(void)redisHMSET:(id)key dictionary:(NSDictionary *)dict type:(NSString *)type intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    
    if (_mRedisServer)
    {
        [_mRedisServer redisHMSET:key dictionary:dict type:type intervals:time respondHandler:respondHandler];
    }
    
}


-(void)redisHGETALL:(id)key respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer)
    {
        [_mRedisServer redisHGETALL:key respondHandler:respondHandler];
    }
    
}


-(void)redisHGETALL:(id)key intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer)
    {
        [_mRedisServer redisHGETALL:key intervals:time respondHandler:respondHandler];
    }
    
}
-(void)redisHGET:(id)key field:(id)field respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer)
    {
        [_mRedisServer redisHGET:key field:field respondHandler:respondHandler];
    }
}


-(void)redisHGET:(id)key field:(id)field intervals:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    if (_mRedisServer)
    {
        [_mRedisServer redisHGET:key field:field intervals:time respondHandler:respondHandler];
    }
    
}

-(void)removeRedisHGET:(id)key withFeile:(id)field
{
    if (_mRedisServer)
    {
        [_mRedisServer removeRedisHGET:key withFeile:field];
    }
}

-(void)removeRedisHGETALL:(id)key
{
    if (_mRedisServer)
    {
        [_mRedisServer removeRedisHGETALL:key];
    }
}


-(void)removeRedisHMSET:(id)key
{
    if (_mRedisServer)
    {
        [_mRedisServer removeRedisHMSET:key];
    }
}

-(void)endWorker
{
    if (_mRedisServer)
    {
        [_mRedisServer endWorker];
        
    }
    
}
-(NSString *)upDateMessageTimeForJSONWithDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [messageDic setObject:[ETTRedisBasisManager getTime] forKey:@"time"];
    NSString *jsonStr = [ETTRedisBasisManager getJSONWithDictionary:messageDic];
    return jsonStr;
}

-(NSString *)updateMessageForJSON:(NSString *)jsonMessage
{
    NSMutableDictionary *messageDic = [ETTRedisBasisManager getDictionaryWithJSON:jsonMessage];
    [messageDic setObject:[ETTRedisBasisManager getTime] forKey:@"time"];
    NSString *jsonStr = [ETTRedisBasisManager getJSONWithDictionary:messageDic];
    return jsonStr;
}

-(NSTimeInterval)getRedisTime
{
    return [self.MDRedisServer getRedisTime];
}

-(NSTimeInterval)getLoginTime
{
    return [self.MDRedisServer getLoginTime];
}

+(NSString *)getTime
{
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    NSTimeInterval timeDifference = [[NSDate new]timeIntervalSince1970] - [redisManager getLoginTime];
    NSTimeInterval time = [redisManager getRedisTime]+timeDifference;
    return [NSString stringWithFormat:@"%.0f",time];
}

+(NSString *)getJSONWithDictionary:(NSDictionary *)dic
{
    NSError * err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+(NSMutableDictionary *)getDictionaryWithJSON:(NSString *)jsonStr
{
    ////////////////////////////////////////////////////////
    /*
     new      : ADD
     time     : 2017.4.21  11:15
     modifier : 康晓光
     version  ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
     branch   ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920／Epic-0421-AIXUEPAIOS-1206
     problem  : 大课件redis验证权限处理
     describe : 增加字符串类型判断
     */
    ////////////////////////////////////////////////////////
    if (jsonStr&&![jsonStr isEqual:[NSNull null]]&& [jsonStr isKindOfClass:[NSString class]]) {
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return jsonObj;
    }else{
        return nil;
    }
}

@end
