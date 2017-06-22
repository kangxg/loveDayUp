//
//  ETTCoreAssistant.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTCoreAssistant.h"

@implementation ETTCoreAssistant
@synthesize EDHighestLeadr = _EDHighestLeadr;
-(instancetype)initCoreAssistant:(id<ETTHighestLeaderInterface>)boss{
    if (self = [super init])
    {
        _EDHighestLeadr =  boss;
        [self initOffice];
    }
    return self;
}
@end

@implementation ETTCoreArchivesAssistant


-(void)createHighestCard:(ETTCoreLeadership *)leader config:(ETTSeniorOfficialsConfigModel *)config
{
    if (leader == nil || config == nil|| leader != self.EDHighestLeadr)
    {
        return;
    }
    [self createHighestCard:config];
    
}


-(void)createHighestCard:(ETTSeniorOfficialsConfigModel *)config
{
    if (_EDHighestCard == nil)
    {
        _EDHighestCard = [[ETTCVCardModel alloc]init];
        [_EDHighestCard putInDataFordic:[config.EDSeniorLeadership valueForKey:@"HighestLeader"]];
        
    }
}


-(ETTCVCardModel *)createSeniorLeadershipCard:(ETTOfficialsLevel)level   boss:(ETTCoreLeadership *)leader config:(ETTSeniorOfficialsConfigModel *)config
{
    if (leader == nil || config == nil || leader != self.EDHighestLeadr)
    {
        return nil;
    }
    ETTCVCardModel * card = nil;
    switch (level)
    {
        case ETTOFFICIALSPERDEP:
        {
            card = [self createPersonnelDepartmentCard:config];
        }
            break;
        case ETTOFFICIALSSECURITY:
        {
            card = [self createSecurityManagerCard:config];
        }
            break;
        case ETTOFFICIALSCIVILAFFAIRS:
        {
            card =  [self createCivilAffairsManagerCard:config];
        }
            break;
        case ETTOFFICIALSGENERALMANAGER:
        {
            card = [self createGenneralManagerCard:config];
        }
            break;
        default:
            break;
    }
    return card;
}

-(ETTCVCardModel *)createPersonnelDepartmentCard:(ETTSeniorOfficialsConfigModel *)config

{
    ETTCVCardModel  * card = [[ETTCVCardModel alloc]init];
    [card putInDataFordic:[config.EDSeniorLeadership valueForKey:@"PersonnelDepartment"]];
    return card;
}

-(ETTCVCardModel *)createSecurityManagerCard:(ETTSeniorOfficialsConfigModel *)config

{
    ETTCVCardModel  * card = [[ETTCVCardModel alloc]init];
    [card putInDataFordic:[config.EDSeniorLeadership valueForKey:@"SecurityDepartment"]];
    return card;
}

-(ETTCVCardModel *)createCivilAffairsManagerCard:(ETTSeniorOfficialsConfigModel *)config

{
    ETTCVCardModel  * card = [[ETTCVCardModel alloc]init];
    [card putInDataFordic:[config.EDSeniorLeadership valueForKey:@"CivilAffairsDepartment"]];
    return card;
}

-(ETTCVCardModel *)createGenneralManagerCard:(ETTSeniorOfficialsConfigModel *)config

{
    ETTCVCardModel  * card = [[ETTCVCardModel alloc]init];
    [card putInDataFordic:[config.EDSeniorLeadership valueForKey:@"GenneralManager"]];
    return card;
}


@end
