//
//  ETTCVCardModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTCVCardModel.h"

@implementation ETTCVCardModel
- (id)copyWithZone:(NSZone __unused *)zone
{
    ETTCVCardModel *constraint = [[ETTCVCardModel alloc] initWithCard:self];

    return constraint;
}
-(instancetype )initWithCard:(ETTCVCardModel *)card
{
    if (self = [super init])
    {
        _EDName      = card.EDName;
        _EDLevel     = card.EDLevel;
        _EDPerType   = card.EDPerType;
        _EDEmpNumber = card.EDEmpNumber;
    }
    return self;
}
-(BOOL)putInDataFordic:(id)data
{
    if (data )
    {
        NSDictionary * dic = data;
        _EDName            = [dic valueForKey:@"name"];
        _EDLevel           = [[dic valueForKey:@"level"] integerValue];
        _EDPerType         = [[dic valueForKey:@"perType"] integerValue];
        _EDEmpNumber       = [dic valueForKey:@"empNumber"];
        return YES;
    }
    return false;
}
@end
