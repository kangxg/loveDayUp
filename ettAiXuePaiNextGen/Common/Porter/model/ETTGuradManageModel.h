//
//  ETTGuradManageModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTGuardModel.h"
@class ETTTakecareRegistrationModel;
@class ETTGuradCaptainModel;
@class ETTNormalGuardModel;
/**
 Description 门卫管理
 */
@interface ETTGuradManageModel : ETTGuardModel

-(BOOL)canOpenDoor:(ETTViewController *)vc withNum:(NSInteger)doorplat;
-(void)resetManagerSystem;
-(ETTGuradCaptainModel *)getguradCapationModel:(NSInteger) doorplate;
-(void)removeGurad:(ETTNormalGuardModel *)guardModel;

-(void)deleteGurad:(ETTNormalGuardModel *)guardModel;

-(void)removeGurad:(ETTNormalGuardModel *)guardModel takeRegist:(ETTTakecareRegistrationModel *)takecareModel;
@end
