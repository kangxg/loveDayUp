//
//  ETTClassificationModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
//
//学生管理左侧列表项班级分类数据model
//
#import "ETTBaseModel.h"
#import "ETTStudentManageEnum.h"
@interface ETTClassificationModel : ETTBaseModel
@property (nonatomic,copy  ) NSString  * classId;
@property (nonatomic,copy  ) NSString  * className;
@property (nonatomic,assign) NSInteger onlineCount;
@property (nonatomic,assign) NSInteger studentCount;
@property (nonatomic,assign)ETTClassType classType;

@property (nonatomic,assign)BOOL        isLockScreen;
@property (nonatomic,assign)BOOL        isRollCall;
@property (nonatomic,assign)BOOL        isReponder;
@property (nonatomic,assign)BOOL        isGroup;
@property (nonatomic,assign)BOOL        isTV;
@end
//在线
@interface ETTClassOnlineModel : ETTClassificationModel

@end
//旁听
@interface ETTClassAttendModel : ETTClassificationModel

@end
//创建的班级
@interface ETTClassEstablishModel : ETTClassificationModel

@end





