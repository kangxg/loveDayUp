//
//  ETTGuardModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTGuardModelInterface.h"
#import "ETTPorterEnum.h"
/**
 Description 门卫系统类
 */
@interface ETTGuardModel : ETTBaseModel<ETTGuardModelInterface>



@property (nonatomic,weak)id<ETTGuardModelInterface> EDLeader;

/**
 Description
 */
-(void)initGuardData;

/**
 Description 设置门牌号，也就是 根视图的号码

 @param doorplate 编号，门牌号
 */
-(void)setDoorplate:(NSInteger )doorplate;


/**
 Description 设置编号，也就是 跟视图的号码
 
 @param doorplate 编号，每个跟视图下的入栈视图的编号（员工号）
 */
-(void)setEmpno:(NSInteger )empno;

/**
 Description 设置回调

 @param handle 操作类型
 */
-(void)setHandle:(ETTGuradHandle)handle;

/**
 Description 设置是否需要通知 快速返回

 @param needNotice yes:需要，no:不需要
 */
-(void)setNeedNotice:(BOOL)needNotice;
@end
