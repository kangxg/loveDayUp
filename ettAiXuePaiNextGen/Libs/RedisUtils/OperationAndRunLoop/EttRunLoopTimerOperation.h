//
//  EttRunLoopTimerOperation.h
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

#import "EttBaseRunLoopOperation.h"
#import "EttOperationDelegate.h"

@interface EttRunLoopTimerOperation : EttBaseRunLoopOperation

/**
 *  生成Operation
 *
 *  @param interval timer间隔时间（默认时间间隔是5秒）
 *  @param useTime  是否在线程中使用Timer
 *  @param delegate delegate
 */
-(instancetype)initWithInterval:(NSTimeInterval)interval useTimer:(BOOL)useTime withDelegate:(id<EttOperationDelegate>)delegate;
/**
 *  Operation
 *
 *  @param interval timer间隔时间(默认时间间隔是5秒)
 *  @param useTime  是否使用timer
 *  @param target   委托线程的对象
 *  @param funcName 执行的方法
 */
-(instancetype)initWithInterval:(NSTimeInterval)interval useTimer:(BOOL)useTime addTarget:(id)target hookSelector:(NSString *)funcName;

-(BOOL)begin;
-(BOOL)stop;
-(BOOL)delegateTimer;

-(BOOL)isFinished;
-(BOOL)isExecuting;

@end
