//
//  ETTViewControllerInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

/**
 *  @brief  UIViewController 父接口文件
 *
 *  @param  11.17 15:40
 *  @param  康晓光
 *  @param  暴露的方法用于外部对控制器数据传递、操作等共有方法
 *  @param  注意：如果自己添加的方法一定要 UIViewController 里重写，然后 子类实现
 */
#import <Foundation/Foundation.h>

@class  ETTOpenClassroomDoBackModel;
@class  ETTNormalGuardModel;
@protocol ETTViewControllerInterface <NSObject>
@optional
@property (nonatomic,retain)ETTNormalGuardModel  * EVGuardModel;
//
//  刷新学生管理学生信息
//
-(void)refreshClassOnlinePersonnelInformation:(NSDictionary *)dict;

//刷新旁听人数
-(void)refreshClassEattendPersonnelInformation:(NSArray * )arr;










//给班级管理赋值model  不需要redis端提供
-(void)putInOpenClassroomDoBackModel:(ETTOpenClassroomDoBackModel * )model;


- (void)closeDocument;


-(void)returnBindingRoomView: (UIView *)view;


//用户快速返回绑定视图的返回回调处理
-(void)bindingViewReturnCallback;

/**
 Description  免打扰
 
 @return 是否开启免打扰
 */
-(BOOL)donotDisturb;


-(void)removeNotify;

-(void)resetViewController;
@end
