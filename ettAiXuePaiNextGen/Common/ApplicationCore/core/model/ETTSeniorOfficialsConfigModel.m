//
//  ETTSeniorOfficialsConfigModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTSeniorOfficialsConfigModel.h"

@implementation ETTSeniorOfficialsConfigModel
-(id)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

-(void)initData
{
    [self loadModelData:@"EttSeniorOfficialsConfig" withblock:^(NSError * error)
     {
         
     }];
    
}
@end
