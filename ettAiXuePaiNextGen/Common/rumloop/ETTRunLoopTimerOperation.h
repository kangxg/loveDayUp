//
//  ETTRunLoopTimerOperation.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseRunLoopOperation.h"

@interface ETTRunLoopTimerOperation : ETTBaseRunLoopOperation
-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate;
-(void)taskeSuccess;
@end

@interface ETTStuPerformanceRunLoop: ETTBaseRunLoopOperation

-(instancetype)initWithInterval:(NSTimeInterval)interval withDelegate:(id<ETTOperationDelegate>)delegate;
@end
