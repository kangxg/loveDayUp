//
//  ETTBaseAssistant.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseAssistant.h"

@interface ETTBaseAssistant()
@property (nonatomic,weak,readonly) id<ETTAssistantManagerInterface>  MDLeader;
@end
@implementation ETTBaseAssistant

-(instancetype )initAssistant:(id<ETTAssistantManagerInterface>)leader
{
    if (self = [super init])
    {
        _MDLeader = leader;
        [self initOffice];
    }
    return self;
}

-(void)initOffice
{
    
}
@end
