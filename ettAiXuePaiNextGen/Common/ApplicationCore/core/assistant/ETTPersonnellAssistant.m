//
//  ETTPersonnellAssistant.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTPersonnellAssistant.h"
#import "ETTDBManagement.h"

@implementation ETTPersonnellAssistant

@end


//人事档案助手
@implementation ETTPerArchivesAssistant

-(void)initOffice
{
    if (_EDPersonnelFile == nil)
    {
        _EDPersonnelFile = [[NSMutableDictionary alloc]init];
    }
}
-(nullable ETTNationalPossessionsModel *)getNationalPossessionsModel:(nonnull NSString *)name
{
    if (name)
    {
        ETTNationalPossessionsModel * model = [_EDPersonnelFile objectForKey:name];
        return model;
    
    }
    return nil;
}
-(nullable ETTNationalPossessionsModel * )archivesOffice:(NSInteger)officeType withCard:(nonnull ETTCVCardModel *)card
{
    if (card == nil)
    {
        return nil;
    }
    ETTNationalPossessionsModel * model = nil;
    switch (officeType)
    {
        case ETTPERDEPOFFICEGENMANAGER:
        {
            model = [self createGeneralManagerArchives:card];
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(ETTNationalPossessionsModel *)createGeneralManagerArchives:(ETTCVCardModel *)card
{
    if (card)
    {
        ETTGenNationalPossessionsModel * model = (ETTGenNationalPossessionsModel *)[_EDPersonnelFile valueForKey:card.EDName];
        
        if (model == nil )
        {
            model = [[ETTGenNationalPossessionsModel alloc]init];
            model.EDCVCard = [card copy];
            NSDictionary * dic = [[ETTDBManagement sharedDBManagement] dbGetAllUserLogInfoData];
            [model putInDataFordic:dic];
            
            if ([[ETTDBManagement sharedDBManagement] dbGetCurrentClassroomClassStateInformation])
            {
                model.EDLastState = YES;
            }
            else
            {
                 model.EDLastState = false;
            }
            [_EDPersonnelFile setObject:model forKey:card.EDName];
            
            
        }
        
        return model;
    }
    return nil;
}
@end
