//
//  ETTDisasterListingModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/5.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTDisasterListingModel.h"

@implementation ETTDisasterListingModel
-(BOOL)putInDataFordic:(id)data
{
    NSDictionary * dic = data;
    if (dic == nil || dic.count == 0)
    {
        return false;
    }
    _EDJid          = [dic valueForKey:@"jid"];
    _EDDisasterType = [dic valueForKey:@"type"];
    _EDHaveDisaster = [dic valueForKey:@"disaster"];
    _EDDisasterDic  = [dic valueForKey:@"theUserInfo"];
    _EDDisasterTime = [dic valueForKey:@"time"];
    _EDRoomId       = [dic valueForKey:@"roomid"];
    NSDictionary * otherdic = [dic valueForKey:@"other"];
    if (otherdic.count)
    {
        _EDOperationSTate = [[otherdic valueForKey:@"state"]integerValue];
    }
    NSNumber * num = [otherdic valueForKey:@"pushPaper"];
    if (num )
    {
        _EDIsPushPaper = num.boolValue;
    }
    else
    {
        _EDIsPushPaper = YES;
    }
    _EDTitle = [otherdic valueForKey:@"title"];
    _EDExpDic = [otherdic valueForKey:@"exp"];
    
    _EDPushTestPaperId =[otherdic valueForKey:@"pushTestPaperId"];
    _EDLastDic = [dic objectForKey:@"subTopicUserInfo"];
    return YES;
}


@end
