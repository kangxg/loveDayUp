//
//  ETTRedisBasisManager.h
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

#import <Foundation/Foundation.h>
#import "EttRedisDelegate.h"
#import "RedisPrefix.pch"


#import "ETTRedisManagerConst.h"
#import "ETTUserInformationProcessingUtils.h"
#import "ETTRedisWorkerManager.h"
#import "ETTRedisHeader.h"
#import "ETTRedisServerDelegate.h"


@interface ETTRedisBasisManager : ETTRedisWorkerManager





@property (nonatomic,strong) id<EttRedisDelegate>     MDelegate;
@property (nonatomic,strong) id<ETTRedisBasisDelegate>  mDataSource;

///redis检测是否在运行
@property (nonatomic,assign) BOOL                   heartBeatState;

+(instancetype)sharedRedisManager;




///初始化端口号、IP 端口号默认6379（输入0）
-(void)initWithServerHost:(NSString *)host port:(int)port;

-(void)channelForConnectHostWithPassword:(NSString *)password respondHandler:(RespondHandler)respondHandler;
///所有对象创建链接
-(void)allObjectCreateConnectWithPassword:(NSString *)password respondHandler:(RespondHandler)responHandler;





-(void)echoString:(NSString *)echoStr respondHandler:(RespondHandler)respondHandler;

///获得当前redis服务器的版本，可以用来判断当前与服务器的链接状态。
-(void)getVersion:(RespondHandler)respondHandler;







///关闭当前链接并退出。成功后返回@“OK”。
-(void)quit:(RespondHandler)respondHandler;

-(void)channelQuit:(RespondHandler)respondHandler;

-(void)allQuit:(RespondHandler)respondHandler;



///ping命令
-(void)pingHostGetRespondHandler:(RespondHandler)respondHandler;
-(void)channelPingHostGetRespondHandler:(RespondHandler)respondHanler;




/**
 *  注册频道的监听、接收订阅频道的信息
 *
 *  @param callBack 返回订阅的信息。
 */
-(void)receivingSubcribtionDataWithObserver:(id)mOberver channelNameArray:(NSArray *)channelNameArray respondHandler:(RespondHandler)respondHandler subscribeMessage:(void (^)(NSString *message))subscribeMessage;
///建议不要直接使用
-(void)channelForReceivingSubcribtionDataWithObserver:(id)mOberver channelNameArray:(NSArray *)channelNameArray respondHandler:(RespondHandler)respondHandler subscribeMessage:(void (^)(NSString *message))subscribeMessage;







/**
 *  发布信息（字符串）
 *
 *  @param channelName 频道名称
 *  @param message     信息内容
 *  @param callBack    回调函数（如果发送成功会返回NSInteger类型值,发送成功返回1，失败返回0)
 */
-(void)publishMessageToChannel:(NSString *)channelName message:(NSString *)message respondHandler:(RespondHandler)respondHandler;

-(void)channelPublishMessage:(NSString *)channelName message:(NSDictionary *)message intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;






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

-(NSTimeInterval)getRedisTime;
-(NSTimeInterval)getLoginTime;

+(NSString *)getTime;
+(NSString *)getJSONWithDictionary:(NSDictionary *)dic;
+(NSMutableDictionary *)getDictionaryWithJSON:(NSString *)jsonStr;


-(void)endWorker;

@end











