//
//  ETTPersonnellAssistant.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

/**
 Description 人事部助手类文件
 */
#import "ETTBaseAssistant.h"
#import "ETTCVCardModel.h"
#import "ETTNationalPossessionsModel.h"
@interface ETTPersonnellAssistant : ETTBaseAssistant

@end


/**
 Description 档案助手
 */
@interface  ETTPerArchivesAssistant: ETTPersonnellAssistant

@property (atomic,nonnull,retain)NSMutableDictionary <NSString *,ETTNationalPossessionsModel * >  * EDPersonnelFile;


-(nullable ETTNationalPossessionsModel * )archivesOffice:(NSInteger)officeType withCard:(nonnull ETTCVCardModel *)card;
-(nullable ETTNationalPossessionsModel *)getNationalPossessionsModel:(nonnull NSString *)name;
@end
