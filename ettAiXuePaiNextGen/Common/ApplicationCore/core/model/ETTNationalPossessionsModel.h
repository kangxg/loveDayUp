//
//  ETTNationalPossessionsModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTPersonnelInfoModel.h"

/**
 Description 高级干部人事档案
 */
@interface ETTNationalPossessionsModel : ETTPersonnelInfoModel

@property (nonatomic,copy)NSString * EDIdentity;


@end



/**
 Description  总理人事档案
 */
@interface ETTGenNationalPossessionsModel : ETTNationalPossessionsModel



@property (nonatomic,copy)NSString * EDLogName;

@property (nonatomic,copy)NSString * EDPassword;


@property (nonatomic,copy)NSString * EDSelected;

@property (nonatomic,copy)NSString * EDUid;

@property (nonatomic,copy)NSData   * EDICon;

@property (nonatomic,assign)BOOL     EDLastState;




@end



