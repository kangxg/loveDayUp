//
//  ETTClassUserModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassUserModel.h"
#import "NSMutableArray+merge.h"
#import <objc/runtime.h>
@implementation ETTClassUserModel
@synthesize jid            = _jid;
@synthesize userName       = _userName;
@synthesize userPhoto      = _userPhoto;
@synthesize showScore      = _showScore;
@synthesize lastScoreTime  = _lastScoreTime;
@synthesize userType       = _userType;
@synthesize isOnline       = _isOnline;
-(id)init
{
    if (self = [super init])
    {
        _isOnline = false;
    }
    return self;
}
-(BOOL)putInDataFordic:(id)data
{
    if (data == nil)
    {
        return false;
    }
    NSDictionary * dic = data;
    _jid               = [dic valueForKey:@"jid"];
    _userName          = [dic valueForKey:@"userName"];
    _userPhoto         = [dic valueForKey:@"userPhoto"];
    _showScore         = [dic valueForKey:@"showScore"];
    _lastScoreTime     = [dic valueForKey:@"lastScoreTime"];
    _userType          = [[dic valueForKey:@"userType"] integerValue];
    _remindCount       = [[dic valueForKey:@"remindCount"] integerValue];
    _rewardScore       = [[dic valueForKey:@"rewardScore"] integerValue];
    _answerCount       = [[dic valueForKey:@"answerCount"] integerValue];
    _rollCallCount     =  [[dic valueForKey:@"rollCallCount"] integerValue];
    return YES;
}
-(BOOL)setAssignValue:(NSString *)key value:(NSString *)value
{
    if ([key isEqualToString:@"remindCount"])
    {
        _remindCount += value.integerValue;
    }
    else if ([key isEqualToString:@"rewardScore"])
    {
        _rewardScore += value.integerValue;
    }
    else if ([key isEqualToString:@""])
    {
        _remindCount += value.integerValue;
    }
    else if ([key isEqualToString:@"responderCount"])
    {
        _answerCount += value.integerValue;
    }
    return YES;
    
}

-(BOOL)accumulationAssignValue:(NSDictionary *)dic
{
    if (dic)
    {
        
        _remindCount     =  [[dic valueForKey:@"remindCount"] integerValue];
        _rewardScore     =  [[dic valueForKey:@"rewardScore"] integerValue];
        _answerCount     =  [[dic valueForKey:@"answerCount"] integerValue];
        _rollCallCount   =  [[dic valueForKey:@"rollCallCount"] integerValue];
        return YES;
    }
    return false;
}


-(ETTClassType )userType
{
    return ETTCLASSESTABLISH;
}
-(id)copyWithZone:(NSZone *)zone
{
    ETTClassUserModel * model = [[[self class]allocWithZone:zone]init];
    model.jid = _jid;
    model.userName      = _userName;
    model.userPhoto     = _userPhoto;
    model.showScore     = _showScore;
    model.lastScoreTime = _lastScoreTime;
    return model;
}

-(NSDictionary *)transformModelToNSDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);
    for(int i = 0;i < propsCount; i++){
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [self valueForKey:propName];

        if(value == nil){
            value = [self getObjectInternal:value];;
        }

        [dic setObject:value forKey:propName];
    }
    return dic;
}

-(NSDictionary  *)getUserIntegral
{
   
    NSDictionary *dic = @{@"remindCount":@(_remindCount),@"rewardScore":@(_rewardScore),@"answerCount":@(_answerCount),@"rollCallCount":@(_rollCallCount),@"jid":_jid};
    return dic;

}
-(NSString *)getObjectInternal:(id)value
{
    return [NSString stringWithFormat:@"%@",value];
}


@end


@implementation ETTAttendUserModel
-(ETTClassType )userType
{
    return ETTCLASSTYPEATTEND;
}
@end

@implementation ETTResponderModel
@synthesize time = _time;
-(ETTClassType )userType
{
    return ETTCLASSRESPONDER;
}
@end


@implementation ETTStuPerforemanceUserModel
////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.3.23  16:35
 modifier : 康晓光
 version  ：AIXUEPAIOS-924
 branch   ：AIXUEPAIOS-924／AIXUEPAIOS-1131
 describe : 师端奖励后学生端没有出现奖励数值的变化
 operation: 数据初始化
 */
-(BOOL)putInDataFordic:(id)data
{
    if ([super putInDataFordic:data])
    {
        _remindSum       = self.remindCount;
        _rewardScoreSum  = self.rewardScore;
        _rollCallSum     = self.rollCallCount;
        _answerSum       = self.answerCount;
        return YES;
    }
    return false;
}

/////////////////////////////////////////////////////

////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.3.23  16:35
 modifier : 康晓光
 version  ：AIXUEPAIOS-924
 branch   ：AIXUEPAIOS-924／AIXUEPAIOS-1131
 describe : 师端奖励后学生端没有出现奖励数值的变化
 operation: 数据累积
 */
-(BOOL)statisticalAssignValue:(NSDictionary *)dic
{
    if (dic)
    {
        self.remindCount  =_remindSum + [[dic valueForKey:@"remindCount"] integerValue];
        
        self.rewardScore  = _rewardScoreSum + [[dic valueForKey:@"rewardScore"] integerValue];
       
        self.answerCount  = _answerSum + [[dic valueForKey:@"answerCount"] integerValue];;
        
        self.rollCallCount = _rollCallSum + [[dic valueForKey:@"rollCallCount"] integerValue];;
        return YES;
    }
    return false;
}
/////////////////////////////////////////////////////

@end
