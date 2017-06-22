//
//  EttRedisDelegate.h
//  ETTRedisDemo
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
//  Created by zhaiyingwei on 16/8/2.
//  Copyright © 2016年 zhaiyingwei. All rights reserved.
//
//  此接口封装了redis服务器不同状态下的执行任务。

#import <Foundation/Foundation.h>

/**
 *  redis当前的状态
 */
typedef NS_ENUM(NSInteger,RedisStateEnum) {
    CONNECTION_SUCCESS = 0,         //链接成功
    DISCONNECT         = 1,         //链接断开
    CONNECTION_FAILS   = 2          //链接失败
};

@protocol EttRedisDelegate <NSObject>

@optional
/**
 *  开始连接
 */
-(void)pConnectBegin:(id)object;
/**
 *  连接出错
 */
-(void)pConnectFail:(id)object;
/**
 *  连接成功
 */
-(void)pContectSuccess:(id)object;

/**
 *  正在连接
 */
-(void)pConnecting:(id)object;
/**
 *  连接结束
 */
-(void)pContectFinish:(id)object;
/**
 *  执行心跳护航
 */
-(void)pThrowsHeartbeat;

@end
