//
//  ETTDownLoadConfigModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/1.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTDownLoadConfigModel.h"

@implementation ETTDownLoadConfigModel
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
    [self loadModelData:@"EttDownLoadConfig" withblock:^(NSError * error)
    {
        if (error)
        {
            
        }
    }];
    
    
}


@end
