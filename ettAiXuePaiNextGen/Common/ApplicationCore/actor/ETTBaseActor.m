//
//  ETTBaseActor.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/6/9.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseActor.h"

@implementation ETTBaseActor
@synthesize EDState     =   _EDState;
@synthesize EDCommmand  =   _EDCommmand;
@synthesize EDEntity    =   _EDEntity;
-(instancetype)initActor:(id<ETTCommandInterface>)command withEntity:(id<ETTPerformEntityInterface>)entity
{
    if (self = [super init])
    {
        _EDState      = 0;
        _EDEntity     = entity;
        _EDCommmand   = command;
    }
    return self;
}
-(void)updateActorInfo:(NSDictionary *)info
{
    if (info)
    {
        NSInteger newState = [[info valueForKey:@"state"] integerValue];
        if ( newState != _EDState )
        {
            _EDState = newState;
            [self actorStateChange:_EDState];
        }
    }
}

-(void)actorStateChange:(NSInteger)state
{
    
}

-(void)actorBegain:(NSString *)indentity
{
    
}

-(void)actorChange:(NSString *)indentity
{
    
}

-(void)actorEnd:(NSString *)indentity
{
    
}
@end
