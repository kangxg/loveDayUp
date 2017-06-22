//
//  ETTDisasterListingModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/5.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTBaseModel.h"
#import "ETTCoreEnum.h"
@interface ETTDisasterListingModel : ETTBaseModel

@property (nonatomic,copy,  readonly)NSString      * EDJid;
@property (nonatomic,copy,  readonly)NSString      * EDRoomId;
@property (nonatomic,retain,readonly)NSString      * EDDisasterType;
@property (nonatomic,retain,readonly)NSString      * EDHaveDisaster;
@property (nonatomic,retain,readonly)NSDictionary  * EDDisasterDic;

/**
 Description 扩展的数据
 */
@property (nonatomic,copy,  readonly)NSString      * EDTitle;
@property (nonatomic,retain,readonly)NSDictionary  * EDExpDic;
@property (nonatomic,retain         )NSDictionary  * EDLastDic;
@property (nonatomic,retain,readonly)NSDate        * EDDisasterTime;
@property (nonatomic,assign,readonly)ETTBackupOperationState  EDOperationSTate;
@property (nonatomic,assign,readonly)BOOL            EDIsPushPaper;

@property (nonatomic,copy,  readonly)NSString      * EDPushTestPaperId;



@end
