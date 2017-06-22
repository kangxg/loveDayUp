//
//  ETTTaskInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/4.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTCommandInterface.h"

@protocol ETTTaskInterface <NSObject>
@property (nonatomic,retain)id<ETTCommandInterface>  EDCommmand;
@property (nonatomic,assign,readonly)NSInteger  EDTaskType;

-(instancetype)initTask:(NSInteger)taskType;

-(instancetype)initCommand:(id<ETTCommandInterface>)taskCommand;
@end
