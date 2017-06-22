//
//  ETTBaseTask.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/4.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseTask.h"

@implementation ETTBaseTask
@synthesize EDTaskType = _EDTaskType;
@synthesize EDCommmand = _EDCommmand;
-(instancetype)initTask:(NSInteger)taskType
{
    if (self = [super init])
    {
        _EDTaskType = taskType;
    }
    return self;
}

-(instancetype)initCommand:(id<ETTCommandInterface>)taskCommand
{
    if (self = [super init])
    {
        _EDCommmand = taskCommand;
    }
    return self;
}
@end
