//
//  ETTRescueRecoveryTaskInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol  ETTActorInterface;


@protocol ETTCommandInterface;

@protocol ETTPerformEntityInterface <NSObject>
@property (nonatomic,retain)id<ETTActorInterface>  EDActor;
@optional

-(void)performTask:(id<ETTCommandInterface>)commond ;


-(void)performActorResponse:(id<ETTActorInterface> )actor withInfo:(id)info;
@end


