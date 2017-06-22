//
//  ETTClassPerformanceModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseViewModel.h"
#import "ETTClasssModel.h"
#import "ETTScoreSectionModel.h"
@interface ETTClassPerformanceModel : ETTBaseViewModel
@property  (nonatomic,retain)ETTScoreSectionModel * EDCurrentScoreModel;

@property  (nonatomic,retain)ETTScoreSectionModel * EDAccumuScoreModel;



/**
 Description  存放班级 model 数组
 */
@property (nonatomic,retain)NSArray  <ETTClasssModel *> * EDClassModelArr;

@property (nonatomic,assign)NSInteger                     EDResponderCount;
@property (nonatomic,assign)NSInteger                     EDRollCallCount;

@property (nonatomic,copy)NSString  *                     EDClassroomId;

-(NSArray *)getCurrentClassSession:(NSString *)classId;

-(NSArray *)getAccumulativeClassSession:(NSString *)classId;

-(ETTClasssModel *)getCurrentClassModel:(NSString *)classId;

-(NSInteger )getClassStudentCount:(NSString *)classId;

-(void)setAccumulativeClassUser:(NSArray * )arr;

-(void)sortModel:(NSMutableArray <ETTClassUserModel *>*)arr withSort:(NSString *)sortString ascending:(BOOL)ascending;
-(void)sortRewardScoreSession:(NSMutableArray <ETTClassUserModel *>*)arr;
//累计班级数据  累计数据 + 本节
-(void)cumulativeClassUserPerformance:(NSMutableArray <ETTClassUserModel *>*)arr;
//班级信息json字符串
-(BOOL)putCurrentClassPerformanceJosnString:(NSString *)jsonString;
-(BOOL)processingDataClassList:(NSArray *)arr;

-(BOOL)processingDataClassList:(NSArray *)arr withComplete:(ETTPutDataBlock)block;


-(BOOL)processingDataClassMap:(NSDictionary *)dic withComplete:(ETTPutDataBlock)block;

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.20 11:30
 modifier : 康晓光
 version  ：Epic-0410-AIXUEPAIOS-1190
 branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1241
 problem  : 教师账号互挤后，学生账号切换学生账号后，学生的课堂表现数据为空
 describe :  是否已经有了班级数据
 */
/////////////////////////////////////////////////////
-(BOOL)haveClassPerformace;
/**
 Description  获取班级名称

 @param index 下标

 @return 班级名称 没有返回 @""
 */
-(NSString *)getClassName:(NSInteger )index;

/**
 Description  获取班级总数

 @return 班级总数
 */
-(NSInteger )getClassCount;

/**
 Description 通过下表获取班级ID

 @param index 下标

 @return 没有返回@“”
 */
-(NSString *)getClassId:(NSInteger)index;



@end


@interface ETTTeaClassPerformanceModel : ETTClassPerformanceModel

@end

@interface ETTStuClassPerformanceModel : ETTClassPerformanceModel


@end
