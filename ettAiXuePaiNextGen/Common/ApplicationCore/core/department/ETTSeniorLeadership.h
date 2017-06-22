//
//  ETTSeniorLeadership.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/26.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTBaseOfficials.h"
#import "ETTAssistantManagerInterface.h"
/**
 Description 高级领导基类
 */
@interface ETTSeniorLeadership : ETTBaseOfficials<ETTAssistantManagerInterface>
@property (nonatomic,retain)id<ETTAssistantInterface>    EDAssistant;
-(void)initAssistant;



@end
