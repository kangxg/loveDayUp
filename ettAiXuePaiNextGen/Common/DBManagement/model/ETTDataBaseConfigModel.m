//
//  ETTDataBaseConfigModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTDataBaseConfigModel.h"

@implementation ETTDataBaseConfigModel
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
    [self loadModelData:@"EttDatabaseConfig" withblock:^(NSError * error)
    {
      
    }];

}
@end
