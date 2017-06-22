//
//  ETTChooseView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/17.
//  Copyright © 2017年 Etiantian. All rights reserved.
//
////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.3.17  18:15
 modifier : 康晓光
 version  ：Epic-0315-AIXUEPAIOS-1077
 branch   ：Epic-0315-AIXUEPAIOS-1077/AIXUEPAIOS-0315-984
 describe :学生在爱学派应用内按ipad的开关锁屏后，教师发起指令（推送或者同步进课）时，学生解锁，学生的应用黑屏后退出
 operation: 用于学生选择课堂老师选择班级的父类 用于定位没有开启的提示
 */

/////////////////////////////////////////////////////
#import "ETTView.h"

@interface ETTChooseView : ETTView<UIAlertViewDelegate>

/**
 Description 检查开启定位服务
 */
-(void)checkLoactionServeropen;

/**
 Description  确定选择
 */
-(void)enterChoose;


@end
