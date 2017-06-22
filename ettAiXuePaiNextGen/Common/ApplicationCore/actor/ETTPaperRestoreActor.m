//
//  ETTPaperRestoreActor.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/6/9.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTPaperRestoreActor.h"

@implementation ETTPaperRestoreActor



-(void)actorBegain:(NSString *)indentity command:(id<ETTCommandInterface>)command
{
    if (command == nil || indentity == nil)
    {
        if (self.EDCommmand)
        {
            [self.EDCommmand commandPeriodicallyComplete:self.EDEntity];
        }
        return;
    }
    self.EDCommmand = command;

    if ([indentity isEqualToString:@"CO_04_state1"])
    {
        [self updateActorInfo:@{@"state":@(ETTPAPERRESTOREPUSHEDBEGIN)}];
    }
    else if ([indentity isEqualToString:@"CO_04_state2"])
    {
        [self updateActorInfo:@{@"state":@(ETTPAPERRESTOREENDANSERBEGIN)}];
    }
    else
    {
        if (self.EDCommmand)
        {
            [self.EDCommmand commandPeriodicallyComplete:self.EDEntity];
        }
    }

}
-(void)actorEnd:(NSString *)indentity  command:(id<ETTCommandInterface>)command
{
    if (isEmptyString(indentity))
    {
        if (self.EDCommmand)
        {
            [self.EDCommmand commandPeriodicallyComplete:self.EDEntity];
        }
        return;
    }
    if ([indentity isEqualToString:@"CO_04_state1"])
    {
        [self updateActorInfo:@{@"state":@(ETTPAPERRESTOREPUSHEND)}];
    }
    else if ([indentity isEqualToString:@"CO_04_state2"])
    {
        [self updateActorInfo:@{@"state":@(ETTPAPERRESTOREENDANSEREND)}];
    }
    else
    {
        if (self.EDCommmand)
        {
            [self.EDCommmand commandPeriodicallyComplete:self.EDEntity];
        }
    }
}
-(void)actorChange:(NSString *)indentity
{

}

-(void)actorStateChange:(NSInteger)state
{
    switch (state)
    {
        case ETTPAPERRESTOREPUSHEDBEGIN:
        {
            
        }
        break;
            
        case ETTPAPERRESTOREPUSHEND:
        {
            if (self.EDCommmand)
            {
                [self.EDCommmand commandPeriodicallyComplete:self.EDEntity];
            }
        }
        break;
        
        case ETTPAPERRESTOREENDANSERBEGIN:
        {
            
        }
            break;
        case ETTPAPERRESTOREENDANSEREND:
        {
//            if (self.EDEntity)
//            {
//                
//                [self.EDEntity performActorResponse:self withInfo:@{@"state":@(self.EDState)}];
//            }
            
            if (self.EDCommmand)
            {
                [self.EDCommmand commandPeriodicallyComplete:self.EDEntity];
            }
        }
            break;
      default:
        break;
    }
}
@end
