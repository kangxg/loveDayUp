//
//  ETTOperationDelegate.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETTOperationDelegate <NSObject>
@optional
/**
 *  Description  进入RunLoop
 */
-(void)pRunLoopEntry:(NSOperation *)operation;

-(void)pRunLoopEntry:(NSOperation *)operation info:(id)info;

-(void)pRunloopTimeout:(NSOperation *)operation;
/**
 *  Description  即将处理Timer
 */
-(void)pRunLoopBeforeTimers;
/**
 *  Description  即将处理source
 */
-(void)pRunLoopBeforeSources;
/**
 *  Description  即将进入睡眠
 */
-(void)pRunLoopBeforeWaiting;
/**
 *  Description  即将醒来
 */
-(void)pRunLoopAfterWaiting;
/**
 *  Description  退出
 */
-(void)pRunLoopExit;
@end
