//
//  ETTRedisWorkerModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisWorkerModel.h"

@implementation ETTRedisWorkerModel
@synthesize EDEmployer       = _EDEmployer;
@synthesize EDWarehouse      = _EDWarehouse;
@synthesize EDNumberOfLinks  = _EDNumberOfLinks;
-(instancetype)init:(id<ETTRedisDataHouseManageInterface>)dataHouseManager employers:(id<ETTRedisWorkerManageInterface>)employers
{
    if (self = [super init])
    {
        _EDEmployer       =  employers;
        _EDWarehouse      =  dataHouseManager;
        _EDNumberOfLinks  =  1;
        [self initData];
    }
    return self;
}

-(void)startsWorker
{
    
}

-(void)workAgain
{
    
}

-(void)updateTimeWithCocoaRedis
{
    if ([_EDWarehouse getRedisTime] == 0 || [self.EDWarehouse getLoginTime]==0)
    {
        [self getRedisTime:^(id value, id error) {
            if (!error)
            {
                [self updateTime:value];
            }
        }];
        
    }
}
-(CGFloat)getSquare:(CGFloat)num withTime:(CGFloat)time
{
    CGFloat auareFloat = num * time;
    return auareFloat;
}
-(void)updateTime:(NSDate *)redisDate
{
    if (_EDWarehouse)
    {
        [_EDWarehouse updateTime:redisDate];
    }
}
-(void)getRedisTime:(RespondHandler)respondHandler
{
   NSArray * value =  [_EDWarehouse.EDCocoaRedis commandArgv:@[@"TIME"]];
   NSInteger timestamp = [value[0] integerValue];
   NSDate * date =[NSDate dateWithTimeIntervalSince1970: timestamp];
    if (date)
    {
        respondHandler(date,nil);
        
    }
    else
    {
        NSError * error = [NSError errorWithDomain:@"getRedisTime_error" code:1118 userInfo:nil];
         respondHandler(nil,error);
    }
}
-(void)workComplete
{
    _EDEmployer = nil;
}
-(void)stopWorker
{
      
}

-(void)endWorker
{
    [self stopWorker];
}
-(void)initData
{
    
}
-(NSDictionary *)promiseNSDict:(id)value
{
    if ([value isKindOfClass:[NSArray class]])
    {
        NSArray * arr = value;
        NSUInteger count = [arr count];
        if (count == 0)
        {
            return [NSDictionary new];
            
        }
        NSMutableDictionary* result = [NSMutableDictionary new];
        for( int i = 0; i < count; i += 2 ) {
            id obj = arr[i];
            id val = arr[i+1];
            [result setObject:val forKey:obj];
        }
        
        return result;
        
    }
    return [NSDictionary new];
    
}
-(void)resetEmployer:(id<ETTRedisWorkerManageInterface>  )    EDEmployer
{
    _EDEmployer = EDEmployer;
}

-(void)resetHouseManager:(id<ETTRedisDataHouseManageInterface> )  EDWarehouse
{
    _EDWarehouse = EDWarehouse;
}
@end
