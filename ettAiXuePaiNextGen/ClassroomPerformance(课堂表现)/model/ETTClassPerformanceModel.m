//
//  ETTClassPerformanceModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
#import"ETTClassPerformanceModel.h"

@interface ETTClassPerformanceModel()
@property (nonatomic,retain)NSMutableArray * MVUserModelArr;
@end

@implementation ETTClassPerformanceModel
-(id)init
{
    if (self = [super init])
    {
        _MVUserModelArr = [[NSMutableArray alloc]init];
        _EDCurrentScoreModel = [[ETTScoreSectionModel alloc]init];
        _EDAccumuScoreModel = [[ETTScoreSectionModel alloc]init];

    }
    return self;
}
-(NSString *)getClassName:(NSInteger )index
{
    return @"";
}
-(NSString *)getClassId:(NSInteger)index
{
    return @"";
}
-(NSInteger )getClassCount
{
    return self.EDClassModelArr.count;
}

-(void)setAccumulativeClassUser:(NSArray *)arr
{
    
}
-(NSArray *)getAccumulativeClassSession:(NSString *)classId
{
    return nil;
}
-(void)setEDClassModelArr:(NSArray<ETTClasssModel *> *)EDClassModelArr
{
    if (EDClassModelArr)
    {
        _EDClassModelArr = EDClassModelArr;
      
    }
}
-(NSArray *)getCurrentClassSession:(NSString *)classId
{
    if (_MVUserModelArr.count)
    {
        return  _MVUserModelArr;
    }
    ETTClasssModel  * classModel = nil;
    for ( ETTClasssModel  * model in _EDClassModelArr)
    {
        if (classId.integerValue == model.classId.integerValue) {
            classModel = model;
            break;
        }
    }
    NSMutableArray * modelArr = [NSMutableArray array];
    if (classModel)
    {
        for (int j = 0; j<classModel.groupList.count; j++)
        {
            ETTClasssGroupModel * groupModel = classModel.groupList[j];
            for (int i = 0; i<groupModel.userList.count; i++) {
                [modelArr addObject:groupModel.userList[i]];
            }
        }
    }
    
    [self sortModel:modelArr withSort:@"rewardScore" ascending:false];
    [self sortRewardScoreSession:modelArr];
 
    
    return _MVUserModelArr;;

}
-(void)sortModel:(NSMutableArray <ETTClassUserModel *>*)arr withSort:(NSString *)sortString ascending:(BOOL)ascending
{
    if (arr)
    {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortString ascending:ascending];
        NSArray *descriptors             = [NSArray arrayWithObjects:sortDescriptor,nil];

        [arr sortUsingDescriptors:descriptors];
    }
   
    
    
    
}

-(void)sortRewardScoreSession:(NSMutableArray <ETTClassUserModel *>*)arr
{
    if (arr)
    {
        if (_MVUserModelArr.count)
        {
            [_MVUserModelArr removeAllObjects];
  
           
        }
        NSMutableSet *set = [NSMutableSet set];
        [arr enumerateObjectsUsingBlock:^(ETTClassUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [set addObject:@(obj.rewardScore)];
            
        }];
        NSMutableArray *groupArr = [NSMutableArray array];
        [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            [groupArr addObject:obj];
        }];
        [self sortModel:groupArr withSort:nil ascending:false];
        [_EDCurrentScoreModel putInDataForArr:groupArr];
       
        [groupArr enumerateObjectsUsingBlock:^(id  _Nonnull rewardScore, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rewardScore = %@", rewardScore];
            NSArray *tempArr       = [NSArray arrayWithArray:[arr filteredArrayUsingPredicate:predicate]];
            [_MVUserModelArr addObject:tempArr];
        }];

     
      
    }
}
-(ETTClasssModel *)getCurrentClassModel:(NSString *)classId
{
    ETTClasssModel  * classModel = nil;
    for ( ETTClasssModel  * model in _EDClassModelArr)
    {
        if (model.classId.integerValue == classId.integerValue)
        {
            classModel = model;
            break;
        }
    }
    return classModel;
}

-(NSInteger )getClassStudentCount:(NSString *)classId
{
    ETTClasssModel  * classModel  = [self getCurrentClassModel:classId];
    if (classModel)
    {
        return [classModel getclassUserCount];
    }
    return 0;
}

-(void)setAllClassUser:(NSArray * )arr
{

}

-(BOOL)putCurrentClassPerformanceJosnString:(NSString *)jsonString
{
    return false;
}

-(BOOL)processingDataClassList:(NSArray *)arr
{
    return YES;
}

-(BOOL)processingDataClassList:(NSArray *)arr withComplete:(ETTPutDataBlock)block
{
    return YES;
}
-(BOOL)processingDataClassMap:(NSDictionary *)dic withComplete:(ETTPutDataBlock)block
{
    return false;
}
-(void)cumulativeClassUserPerformance:(NSMutableArray <ETTClassUserModel *>*)arr
{
    
}

-(BOOL)haveClassPerformace
{
    return false;
}
@end

#pragma mark ----------- 教师端课堂表现 ---------------
@interface ETTTeaClassPerformanceModel()
@property (nonatomic,retain)NSMutableArray * MVUserModelAccumArr;
@end

@implementation ETTTeaClassPerformanceModel
-(id)init
{
    if (self = [super init])
    {
        _MVUserModelAccumArr = [[NSMutableArray alloc]init];
    }
    return self;
}
-(ETTClasssModel *)getCurrentClassModel:(NSString *)classId
{
    return [super getCurrentClassModel:self.EDClassModelArr.firstObject.classId];
 
}

-(void)setAccumulativeClassUser:(NSArray *)arr
{
    if (!arr)
    {
        return;
    }
    NSArray * classArr = nil;
    for (NSDictionary * dic in arr)
    {
        if ([[dic valueForKey:@"classId"] integerValue] == self.EDClassModelArr.firstObject.classId.integerValue)
        {
            classArr = [dic valueForKey:@"userList"];
            break;
        }
    }
    [self createAccumulativeUserModel:classArr];
    
  
    
    
}

-(NSArray *)getAccumulativeClassSession:(NSString *)classId
{
     return _MVUserModelAccumArr;
}

-(void)createAccumulativeUserModel:(NSArray *)arr
{
    if (!arr.count)
    {
        return;
    }
    NSMutableArray * allUserModle = [[NSMutableArray alloc]init];
    for (NSDictionary  * dic in arr)
    {
        ETTClassUserModel * model = [[ETTClassUserModel alloc]init];
        [model putInDataFordic:dic];
        if (model.jid == nil)
        {
            model.jid = [dic valueForKey:@"userId"];
        }
        [allUserModle addObject:model];
    }
    NSLog(@"userarr = %@",allUserModle);
    [self sortModel:allUserModle withSort:@"rewardScore" ascending:false];
    [self cumulativeClassUserPerformance:allUserModle];
    [self sortAccumulativeRewardScoreSession:allUserModle];
    
    
}

-(BOOL)haveClassPerformace
{
    return YES;
}
-(void)sortAccumulativeRewardScoreSession:(NSMutableArray <ETTClassUserModel *>*)arr
{
    if (arr)
    {
        if (_MVUserModelAccumArr.count)
        {
            [_MVUserModelAccumArr removeAllObjects];
            
            
        }
        NSMutableSet *set = [NSMutableSet set];
        [arr enumerateObjectsUsingBlock:^(ETTClassUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [set addObject:@(obj.rewardScore)];
        }];
        NSMutableArray *groupArr = [NSMutableArray array];
        [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            [groupArr addObject:obj];
        }];
        [self sortModel:groupArr withSort:nil ascending:false];
        [self.EDAccumuScoreModel putInDataForArr:groupArr];
        
        [groupArr enumerateObjectsUsingBlock:^(id  _Nonnull rewardScore, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rewardScore = %@", rewardScore];
            NSArray *tempArr = [NSArray arrayWithArray:[arr filteredArrayUsingPredicate:predicate]];
            [_MVUserModelAccumArr addObject:tempArr];
        }];
        
    }
    
    
}

/**
 Description 将累计数据与本节数据尽享累加

 @param arr  学生数组
 */
-(void)cumulativeClassUserPerformance:(NSMutableArray <ETTClassUserModel *>*)arr
{
    for (int i = 0 ; i<self.MVUserModelArr.count; i++)
    {
        NSArray * userarr = self.MVUserModelArr[i];
        for (ETTClassUserModel * model in userarr)
        {
            for (int j = 0; j<arr.count; j++)
            {
                ETTClassUserModel * model2 = arr[j];
                if (model2.jid.integerValue == model.jid.integerValue)
                {
                    model2.remindCount += model.remindCount;
                    model2.rewardScore += model.rewardScore;
                    model2.answerCount += model.answerCount;
                    model2.rollCallCount += model.rollCallCount;
                 
                }
            }
        }
    }
}
@end

#pragma mark ----------- 学生端课堂表现 ---------------
@interface ETTStuClassPerformanceModel()

/**
 Description  累计视图 显示需要的model 字典 @{@"classid":@"idvalue",@"userList":@[]}
 */
@property (nonatomic,retain)NSMutableDictionary    *  MVAccumuCurrentModelDic;
@property (nonatomic,retain)NSMutableDictionary    *  MVCurrentModelDic;


/**
 Description  后台返回学生累计数据 存放数组 格式为[@{@"classid":value,@"userList":[]}]
 */
@property (nonatomic,retain)NSMutableArray  *  MVAccumuClassModelArr;

/**
 Description 本节数据 存放数组 格式为[@{@"classid":value,@"userList":[]}]
 */
@property (nonatomic,retain)NSMutableArray  *  MVCurrentClassModelArr;



@end
@implementation ETTStuClassPerformanceModel


-(id)init
{
    if (self = [super init])
    {
        _MVAccumuClassModelArr   = [[NSMutableArray alloc]init];
        _MVAccumuCurrentModelDic = [[NSMutableDictionary alloc]init];
        _MVCurrentModelDic       = [[NSMutableDictionary alloc]init];
        _MVCurrentClassModelArr  = [[NSMutableArray alloc]init];

    }
    return self;
}
-(BOOL)putCurrentClassPerformanceJosnString:(NSString *)jsonString
{
    if (jsonString.length)
    {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return false;
        }
        return YES;
    }
    
    return false;
}
-(NSString *)getClassName:(NSInteger )index
{
    if (index<0 || index>=_MVCurrentClassModelArr.count)
    {
        return @"";
    }
    return [_MVCurrentClassModelArr[index] valueForKey:@"className"];
}
-(NSString *)getClassId:(NSInteger)index
{
    if (index<0 || index>=_MVCurrentClassModelArr.count)
    {
        return @"";
    }
    return [_MVCurrentClassModelArr[index] valueForKey:@"classId"];
}

-(NSInteger )getClassCount
{
    return _MVCurrentClassModelArr.count;
}
-(NSArray *)getCurrentClassSession:(NSString *)classId
{
    if (classId.integerValue<=0)
    {
        return nil;
    }
    if (_MVCurrentModelDic.count && classId.integerValue == [[_MVCurrentModelDic valueForKey:@"classId"] integerValue])
    {
        return [_MVCurrentModelDic valueForKey:@"userList"];
    }
    NSDictionary * classDic = nil;
    for (NSDictionary  * dic in  _MVCurrentClassModelArr)
    {
        NSString * jid = [dic valueForKey:@"classId"];
        if ([jid integerValue] ==  classId.integerValue)
        {
            classDic = dic;
        }
    }
    if (classDic == nil)
    {
        return nil;
    }
    NSArray * arr = [classDic valueForKey:@"userList"];
    if (arr == nil)
    {
        return nil;
    }
    [self createCurrentUserModel:arr];
    [_MVCurrentModelDic setValue:classId forKey:@"classId"];
    
    return [_MVCurrentModelDic valueForKey:@"userList"];
    
}


-(void)createCurrentUserModel:(NSArray *)arr
{
    if (!arr.count)
    {
        return;
    }
    NSMutableArray * allUserModle = [NSMutableArray arrayWithArray:arr];
    [self sortModel:allUserModle withSort:@"rewardScore" ascending:false];
    [self sortAccumulativeRewardScoreSession:allUserModle withDic:_MVCurrentModelDic ScoreModel:self.EDCurrentScoreModel];
}

-(BOOL)processingDataClassMap:(NSDictionary *)dic withComplete:(ETTPutDataBlock)block
{
    if (!dic)
    {
        return false;
    }
    
    self.EDRollCallCount   =  [[dic valueForKey:@"rollCallCount"] integerValue];
    self.EDResponderCount  =  [[dic valueForKey:@"answerCount"] integerValue];
    NSArray *  userArr     =  [dic valueForKey:@"data"];
    for ( NSDictionary * udic in userArr)
    {
        [self accumuCurrentModelDicStatistics:udic];
        [self currentModelDicStatistics:udic];
        
    }
    [_MVAccumuCurrentModelDic removeAllObjects];
    [_MVCurrentModelDic  removeAllObjects];
    block(ETTPROCESSINGDATASUCCESS);
    return YES;
}
/**
 Description  统计 累计信息
 
 @param dic 每个统计项字典
 */
-(void)accumuCurrentModelDicStatistics:(NSDictionary *)dic
{
    for ( NSDictionary * udic in _MVAccumuClassModelArr)
    {
      for (ETTClassUserModel * model in [udic valueForKey:@"userList"])
      {
          
        if (model.jid.integerValue == [[dic valueForKey:@"jid"] integerValue])
        {
            [model statisticalAssignValue:dic];
            break;
        }
      }
    }
}

/**
 Description  统计 本节信息

 @param dic 每个统计项字典
 */
-(void)currentModelDicStatistics:(NSDictionary *)dic
{
    for ( NSDictionary * udic in _MVCurrentClassModelArr)
    {
        for (ETTClassUserModel * model in [udic valueForKey:@"userList"])
        {
            
            if (model.jid.integerValue == [[dic valueForKey:@"jid"] integerValue])
            {
                [model accumulationAssignValue:dic];
                break;
            }
        }
    }
}

-(BOOL)processingDataClassList:(NSArray *)arr  withComplete:(ETTPutDataBlock)block
{

    if (arr)
    {

        NSMutableArray * classArr = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in arr)
        {
            ETTClasssModel * model = [[ETTClasssModel alloc]init];
            if (![model putInData:dic]) {
                continue;
            }
            else
            {
                [classArr addObject:model];
            }
        }
        
        self.EDClassModelArr = [NSArray arrayWithArray:classArr];
        
        [self cumulativeClassUserPerformance];
        return YES;
    }
    return false;
}
/**
 Description 将累计数据与本节数据尽享累加
 
 @param arr  学生数组
 */
-(void)cumulativeClassUserPerformance
{
    
}

-(void)cumulativeClassGroupUserPerformance
{
    
}




-(void)setAccumulativeClassUser:(NSArray *)arr
{
    if (!arr)
    {
        return;
    }
    [self processingAccumulativeDataClassList:arr];
}

-(void)processingAccumulativeDataClassList:(NSArray *)arr
{
    if (_MVAccumuClassModelArr == nil)
    {
        _MVAccumuClassModelArr = [[NSMutableArray alloc]init];
    }
    if (arr)
    {
        NSInteger i = 0;
        
        for (NSDictionary * dic in arr)
        {
            
            NSMutableDictionary * classDic = [[NSMutableDictionary alloc]init];
            NSMutableDictionary * currentclassDic = [[NSMutableDictionary alloc]init];
            [classDic setValue:[dic valueForKey:@"classId"] forKey:@"classId"];
            [currentclassDic setValue:[dic valueForKey:@"classId"] forKey:@"classId"];
            NSString * className = [dic valueForKey:@"className"];
            
            
            if (!className.length) {
                className = [NSString stringWithFormat:@"班级_%ld",(long)++i];
            }
            [classDic        setValue:className forKey:@"className"];
            [currentclassDic setValue:className forKey:@"className"];
            
            
            NSArray * stuArr = [dic valueForKey:@"userList"];
            NSMutableArray * userarr = [[NSMutableArray alloc]init];
            NSMutableArray * currentUserArr = [[NSMutableArray alloc]init];
            for (NSDictionary * studic in stuArr)
            {
                ////////////////////////////////////////////////////////
                /*
                 new      : Modify
                 time     : 2017.3.23  16:30
                 modifier : 康晓光
                 version  ：AIXUEPAIOS-924
                 branch   ：AIXUEPAIOS-924／AIXUEPAIOS-1131
                 describe : 师端奖励后学生端没有出现奖励数值的变化
                 operation: 原来为ETTClassUserModel 父类型 方便增量统计
                 */
                ETTStuPerforemanceUserModel * model = [[ETTStuPerforemanceUserModel alloc]init];
                /////////////////////////////////////////////////////
              
               
                [model putInDataFordic:studic];
                if (model.jid == nil)
                {
                    model.jid = [studic valueForKey:@"userId"];
                    
                }
                [userarr addObject:model];
                ETTStuPerforemanceUserModel  * cmodle = [model copy];
                [currentUserArr addObject:cmodle];
                
            }
            [classDic setValue:userarr forKey:@"userList"];
            [currentclassDic setValue:currentUserArr forKey:@"userList"];
            [_MVAccumuClassModelArr addObject:classDic];
            [_MVCurrentClassModelArr addObject:currentclassDic];
            
        }
    }
    
}

-(BOOL)haveClassPerformace
{
    if (_MVAccumuClassModelArr == nil || _MVCurrentClassModelArr == nil)
    {
        return false;
    }
    if (_MVCurrentClassModelArr.count == 0 || _MVAccumuClassModelArr.count == 0)
    {
        return false;
    }
    return YES;
}

-(NSArray *)getAccumulativeClassSession:(NSString *)classId
{
    if (classId.integerValue<=0)
    {
        return nil;
    }
    if (_MVAccumuCurrentModelDic.count && classId.integerValue == [[_MVAccumuCurrentModelDic valueForKey:@"classId"] integerValue])
    {
        return [_MVAccumuCurrentModelDic valueForKey:@"userList"];
    }
   
    NSDictionary * classDic = nil;
    for (NSDictionary  * dic in  _MVAccumuClassModelArr)
    {
        NSString * jid = [dic valueForKey:@"classId"];
        if ([jid integerValue] ==  classId.integerValue)
        {
            classDic = dic;
        }
    }
    
    if (classDic == nil)
    {
        return nil;
    }
    NSArray * arr = [classDic valueForKey:@"userList"];
    if (arr == nil)
    {
        return nil;
    }
    [self createAccumulativeUserModel:arr];
    [_MVAccumuCurrentModelDic setValue:classId forKey:@"classId"];

    return [_MVAccumuCurrentModelDic valueForKey:@"userList"];
}

-(void)createAccumulativeUserModel:(NSArray *)arr
{
    if (!arr.count)
    {
        return;
    }
    NSMutableArray * allUserModle = [NSMutableArray arrayWithArray:arr];
    [self sortModel:allUserModle withSort:@"rewardScore" ascending:false];
    [self cumulativeClassUserPerformance:allUserModle];
    [self sortAccumulativeRewardScoreSession:allUserModle withDic:_MVAccumuCurrentModelDic ScoreModel:self.EDAccumuScoreModel];
}

-(void)sortAccumulativeRewardScoreSession:(NSMutableArray <ETTClassUserModel *>*)arr  withDic:(NSMutableDictionary *)sourceDic ScoreModel:(ETTScoreSectionModel * )model
{
    if (arr)
    {
       
        NSMutableArray * accumModleArr = [[NSMutableArray alloc]init];
        NSMutableSet *set = [NSMutableSet set];
        [arr enumerateObjectsUsingBlock:^(ETTClassUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [set addObject:@(obj.rewardScore)];
        }];
        NSMutableArray *groupArr = [NSMutableArray array];
        [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            [groupArr addObject:obj];
        }];
        [self sortModel:groupArr withSort:nil ascending:false];
        [model putInDataForArr:groupArr];
        
        [groupArr enumerateObjectsUsingBlock:^(id  _Nonnull rewardScore, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rewardScore = %@", rewardScore];
            NSArray *tempArr = [NSArray arrayWithArray:[arr filteredArrayUsingPredicate:predicate]];
            [accumModleArr addObject:tempArr];
        }];
        
        [sourceDic setValue:accumModleArr forKey:@"userList"];
        
    }
    
    
}

@end
