//
//  ETTGuardModelInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/6.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTPorterEnum.h"
@class ETTTakecareRegistrationModel;
@protocol ETTGuardModelInterface <NSObject>
@optional
/**
 Description 当前路径口令 
 */
@property (nonatomic,assign)NSInteger   EDTokenPath;

/**
 Description  配置 结构体
 */
@property (nonatomic,assign)ETTGuradArchive     EDGuradArchive;

/**
 Description  单位名（也就是VC名）
 */
@property (nonatomic,copy)NSString         *    EDWorkUnitName;

/**
 Description 单位实体
 */
@property (nonatomic,retain)ETTViewController  * EDEDWorkUnitVC;

/**
 Description 构造函数

 @param workUnit 单位实体
 @param name     单位名称
 @return         门卫
 */
-(instancetype)initGuard:(ETTViewController  *)workUnit unitName:(NSString *)name;

/**
 Description  向上级报告

 @param doorplate 门牌号
 @param empo      门卫编号
 */
-(void)reportPathTosuperior:(NSInteger )doorplate empo:(NSInteger )empo;

/**
 Description      显示正在推送的页面

 @param takeModel 登记薄
 */
-(void)showIsPushingview:(ETTTakecareRegistrationModel *)takeModel;



-(void)resetGuard;
@end
