//
//  ETTUserInfoHelperModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.12 13:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1182
 problem  : v新客户端问题修复（清空本地缓存）
 describe : 用户登录信息数据表操作
 */
/////////////////////////////////////////////////////
#import "ETTDataHelperModel.h"

@interface ETTUserInfoHelperModel : ETTDataHelperModel

/**
 Description 插入一条用户信息

 @param name 用户名称
 @param password 密码
 @param selected 是否记住用户名
 */
-(void)insertUserInfoTable:(NSString *)name passwordStr:(NSString *)password isSelected:(NSString *)selected;

/**
 Description 更新用户身份标识

 @param value 标识
 */
-(void)updateUserIdentity:(NSString *)value ;

/**
 Description 获取用户身份标识
 
 @param value 身份标识
 */
-(NSString * )selectUserIdentity;

/**
 Description 获取用户身名
 
 @param value 用户名
 */
-(NSString * )selectUserName;
/**
 Description 获取用户id
 
 @param value 用户ID
 */
-(NSString * )selectUserid;

/**
 Description 更新用户id
 
 @param value 用户ID
 */
-(void)updateUserid:(NSString *)uid;

/**
 Description 更新用户头像
 
 @param value 图片地址
 */
-(void)updateUserIcon:(NSData *)data;


-(NSData *)selectUserIcon;
@end
