//
//  ETTStudentManageViewModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseViewModel.h"
#import "ETTOpenClassroomDoBackModel.h"
#import "ETTClassificationModel.h"

@interface ETTStudentManageViewModel : ETTBaseViewModel
@property (nonatomic,assign)BOOL                         EDGetStudentsIntegral;
@property (nonatomic,assign)NSInteger                   * EDOnlineCount;

@property (nonatomic,retain)ETTOpenClassroomDoBackModel * EDClassModel;
//左侧班级分类 modle 数组
@property (nonatomic,retain)NSMutableArray <ETTClassificationModel *> * EDClassListArr;

//在线 modle 数组
@property(nonatomic,retain)NSMutableArray<ETTClassUserModel *>  * EDOnlineUserArr;

//旁听 modle 数组
@property(nonatomic,retain)NSMutableArray<ETTClassUserModel *>  * EDAttendUserArr;

@property(nonatomic,assign)BOOL                                   EDLockView;
@property (nonatomic,assign)NSInteger                             EDRollCallCount;
@property (nonatomic,assign)NSInteger                             EDResponderCount;

@property (nonatomic,assign)NSInteger                             EDLastRefreTime;
//获取所有学生数量
-(NSInteger )getSumInClass;
//获取班级总数
-(NSInteger )getClassCount;
//获取班级里所有分组数量
-(NSInteger)getGroupCount:(NSString *)classId;
//获取班级里所有在线学生数量
-(NSInteger *)getOnlineCountInClass:(NSString *)classId;

//获取组成员数量

//获取旁听总数
//获取班级model
-(ETTClasssModel *)getClassModel:(NSString *)classId;

//获取班级里所有学生
-(NSArray<ETTClasssModel *> *)getClassStuden:(NSString *)classId;



//刷线班级学生在线信息
-(void)refreshClassStudentData:(NSString *)classId;

-(void)refreshClassStudentWithClassModel:(ETTClasssModel *)classModel;



-(void)refreshClassOnlineData:(NSDictionary *)dic block:(ETTPutDataBlock)block;


-(void)setStudentAnswerData:(NSArray *  )arr;


-(void)processingDataClassMap:(NSDictionary *)dic;

@end
