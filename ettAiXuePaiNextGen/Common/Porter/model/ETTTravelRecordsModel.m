//
//  ETTTravelRecordsModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/7.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTravelRecordsModel.h"

@implementation ETTTravelRecordsModel
@synthesize EDFromPath     = _EDFromPath;
@synthesize EDCurrentPath  = _EDCurrentPath;

-(id)init
{
    if (self = [super init])
    {
        [self resetTravelRecords];
    }
    return self;
}

-(void)resetTravelRecords
{
    _EDEmpo = -1;
    _EDCurrentPath = -1;
    _EDFromPath = -1;
}
@end
