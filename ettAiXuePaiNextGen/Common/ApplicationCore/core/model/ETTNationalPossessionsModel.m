//
//  ETTNationalPossessionsModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTNationalPossessionsModel.h"

@implementation ETTNationalPossessionsModel

@end

@implementation ETTGenNationalPossessionsModel


-(BOOL)putInDataFordic:(id)data
{
    if (data)
    {
        NSDictionary * dic = data;
    
        _EDLogName   = [dic valueForKey:@"id"];
        _EDSelected  = [dic valueForKey:@"selected"];
        _EDPassword  = [dic valueForKey:@"password"];
        _EDICon      = [dic valueForKey:@"icon"];
        _EDUid       = [dic valueForKey:@"uid"];
        self.EDIdentity = [dic valueForKey:@"identity"];
    }
    return false;
}
@end
