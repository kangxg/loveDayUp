//
//  ETTGuradBattalionChiefModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTGuradManageModel.h"

/**
 Description  门卫大队长
 */
@class ETTGuradCaptainModel;
@interface ETTGuradBattalionChiefModel : ETTGuradManageModel

/**
 Description  注册一个院落的门卫队长

 @param 注册的队长 驻地单位
 */
-(void )registerGuradCaptainManager:(ETTViewController *)vc ;


/**

 Description  判断单位是否已派驻队长

 @param vc 单位实体类
 @return   返回已经驻地队长
 */
-(ETTGuradCaptainModel *)haveGuradCaptain:(ETTViewController *)vc;

/**
 Description 是否可以打开门
 @param vc   需要打开的门的单位
 @param doorplat 门牌号
 @return YES 可以 NO: 不可以
 */
-(BOOL)canOpenDoor:(ETTViewController *)vc withNum:(NSInteger)doorplat;
@end
