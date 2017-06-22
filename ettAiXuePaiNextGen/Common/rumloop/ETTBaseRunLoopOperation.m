//
//  ETTBaseRunLoopOperation.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseRunLoopOperation.h"

@implementation ETTBaseRunLoopOperation
@synthesize EDDelegate = _EDDelegate;
-(instancetype)init:(id<ETTOperationDelegate>)delegate
{
    if (self = [super init])
    {
        _EDDelegate = delegate;
    }
    return self;
}
-(void)stop
{
    
}
@end
