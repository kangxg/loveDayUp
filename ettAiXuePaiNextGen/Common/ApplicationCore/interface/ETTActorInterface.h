//
//  ETTActorInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/6/9.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ETTCommandInterface;
@protocol ETTPerformEntityInterface;

@protocol ETTActorInterface <NSObject>

@property (nonatomic,assign,readonly)NSInteger    EDState;
@property (nonatomic,assign)id<ETTCommandInterface>  EDCommmand;

@property (nonatomic,assign)id<ETTPerformEntityInterface>  EDEntity;


-(instancetype)initActor:(id<ETTCommandInterface>)command withEntity:(id<ETTPerformEntityInterface> )entity;

-(void)updateActorInfo:(NSDictionary *)info;

-(void)actorStateChange:(NSInteger)state;

-(void)actorBegain:(NSString *)indentity command:(id<ETTCommandInterface>)command;

-(void)actorEnd:(NSString *)indentity   command:(id<ETTCommandInterface>)command;

-(void)actorChange:(NSString *)indentity;
@end
