//
//  ETTGuradCaptainModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTGuradManageModel.h"

/**
 Description 门卫队长
 */
@interface ETTGuradCaptainModel : ETTGuradManageModel
@property (nonatomic,assign)NSInteger EDCurrentGuradEmpno;
//-(void )registerGurad:(ETTViewController *)vc withHandle:(ETTGuradHandle)handle;

/**
 Description 向一个院落队长注册一个门卫

 @param vc 注册的门卫的上一级工作实体
 @param guradModel 注册的门卫的上一级门卫
 @param handle 操作类型
 */
-(void )registerGurad:(ETTViewController *)vc withParentModel:(ETTNormalGuardModel *)guradModel withHandle:(ETTGuradHandle)handle;

/**
 Description 获取当前的门卫是否需要快速返回

 @return  yes 需要 no 不需要
 */
-(BOOL)getNeedNoticeLastGurad;

-(BOOL)getCurrentDoorplate:(NSInteger )tokenPath;

/**
 Description 通过员工号 获取所对应的当前门卫

 @param empo 员工号吗
 @return 门卫
 */
-(ETTNormalGuardModel *)getCurrentGuardModel:(NSInteger )empo;

/**
 Description 获取当前的门卫

 @return 门卫
 */
-(ETTNormalGuardModel *)getCurrentGuardModel;
@end
