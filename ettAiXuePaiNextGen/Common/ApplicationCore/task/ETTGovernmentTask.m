//
//  ETTGovernmentTask.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/4.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTGovernmentTask.h"

@implementation ETTGovernmentTask

@end


@implementation ETTGovernmentWorkTask



@end

@implementation ETTGovernmentClassReportTask
-(instancetype)initTask:(NSInteger)taskType withClassRoom:(NSString *)roomId
{
    if (self = [super initTask:taskType])
    {
        _EDDisasterClassRoomid = roomId;
        _EDDisasterOtherDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(BOOL)putInDataFordic:(id)data
{
    NSDictionary * dic = data;
    if (dic == nil)
    {
        return false;
    }
    
    _EDDisasterType = [dic valueForKey:@"type"];
    if ([_EDDisasterType isEqualToString:@"WB_01"])
    {
        
        _EDDisasterDic  = [dic valueForKey:@"userInfo"];
    }
    else
    {
         _EDDisasterDic  = [dic valueForKey:@"theUserInfo"];
    }
    
    
    return YES;
}

-(void)setOperationState:(ETTBackupOperationState)state
{
    if (state <0)
    {
        return;
    }
    if (_EDDisasterOtherDic)
    {
        [_EDDisasterOtherDic setValue:[NSNumber numberWithInteger:state] forKey:@"state"];
    }
}
-(void)setExtensionData:(NSString *)key value:(id)data
{
    if (key == nil || data == nil)
    {
        return;
    }
    
    if (_EDDisasterOtherDic)
    {
        [_EDDisasterOtherDic setValue:data forKey:key];
    }
}
@end


@implementation ETTGovRestoreWorkTask

@end
