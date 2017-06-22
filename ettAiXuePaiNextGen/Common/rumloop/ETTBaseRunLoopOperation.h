//
//  ETTBaseRunLoopOperation.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTOperationDelegate.h"
@interface ETTBaseRunLoopOperation : NSOperation
@property (nonatomic,weak)   id<ETTOperationDelegate>      EDDelegate;
-(void)stop;

-(instancetype)init:(id<ETTOperationDelegate>)delegate;
@end
