//
//  ETTBaseAssistant.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseOfficials.h"
#import "ETTAssistantInterface.h"
#import "ETTAssistantManagerInterface.h"
@interface ETTBaseAssistant : ETTBaseOfficials<ETTAssistantInterface>

-(instancetype )initAssistant:(id<ETTAssistantManagerInterface>)leader;
@end
