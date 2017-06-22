//
//  ETTRedisDataWarehouse.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisDataWarehouse.h"

typedef void (^OnRespondHandler) (NSString *message);

@implementation ETTRedisDataWarehouse
@synthesize EDServerHost        = _EDServerHost;
//@synthesize EDChannelNameArray  = _EDChannelNameArray;
@synthesize EDChannelNameSet    = _EDChannelNameSet;
@synthesize EDServerPort        = _EDServerPort;
@synthesize EDHandler           = _EDHandler;
@synthesize EDOberserver        = _EDOberserver;
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_EDChannelNameSet forKey:@"ChannelNames"];
    [aCoder encodeObject:_EDServerHost forKey:@"host"];
    [aCoder encodeInteger:_EDServerPort forKey:@"port"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super init])
    {
        _EDChannelNameSet   = [aDecoder decodeObjectForKey:@"ChannelNames"];
        _EDServerHost       = [aDecoder decodeObjectForKey:@"host"];
        _EDServerPort       = [aDecoder decodeIntegerForKey:@"port"];
    }
    return self;
}
-(id)init
{
    if (self = [super init])
    {
        //        _EDChannelNameArray = [[NSMutableArray alloc]init];
        _EDChannelNameSet   = [[NSMutableSet alloc]init];
        [self resetDataHouse];
        
    }
    return self;
}

-(void)setEDServerPort:(NSInteger)EDServerPort
{
    if (EDServerPort == 0)
    {
        _EDServerPort = kPORT;
    }
    else
    {
        _EDServerPort = EDServerPort;
    }
}

-(NSInteger )EDServerPort
{
    if (_EDServerPort == 0)
    {
        return kPORT;
    }
    return _EDServerPort;
}


-(void)reconnectionReset
{
    [_EDChannelNameSet removeAllObjects];
    [_EDCocoaRedis close];

    [_EDChannelRedis close];

    
    _EDRedisTime        = 0;
    _EDLoginTime        = 0;
    
    _EDHeartTime   = 0;
}
-(void)resetDataHouse
{
    
    [self reconnectionReset];
    
    _EDHeartTime   = 0;
    
    _EDServerHost       = @"";
    _EDServerPort       = 0;
    _EDHandler          = nil;
    
    [self removeOberServer];
    
    
    _EDPassword         = @"";
    
}

-(void)resetCocoaRedis
{

    _EDCocoaRedis = nil;
}

-(void)resetChannelRedis
{

    _EDChannelRedis = nil;
   
    [self removeOberServer];
}

OnRespondHandler onRespondHandler;

-(void)removeOberServer
{
    
}

-(void)registerOberServer:(void (^)(NSString *message))subscribeMessage
{
    onRespondHandler = subscribeMessage;
}

-(void)registerNotifictionMessage:(NSNotification *)notification
{
    if (onRespondHandler)
    {
        NSString *str = notification.userInfo[@"message"];
        onRespondHandler(str);
        
    }
    
}
-(void)dataWarehousing:(NSString *)message
{
  
}
@end
