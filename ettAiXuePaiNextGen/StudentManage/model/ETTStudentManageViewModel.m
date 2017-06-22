//
//  ETTStudentManageViewModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentManageViewModel.h"
#import "ETTClasssModel.h"

@interface ETTStudentManageViewModel()
@property (nonatomic,retain)dispatch_semaphore_t  MDRefSemaphore;
@end

@implementation ETTStudentManageViewModel
@synthesize EDClassModel = _EDClassModel;
-(id)init
{
    if (self = [super init])
    {
        _EDGetStudentsIntegral             = false;
        _EDClassListArr                    = [[NSMutableArray alloc]init];
        ETTClassOnlineModel *  onlinemodel = [[ETTClassOnlineModel alloc]init];
        [_EDClassListArr addObject:onlinemodel];

        ETTClassAttendModel * attendModel  = [[ETTClassAttendModel alloc]init];
        [_EDClassListArr addObject:attendModel];

        _EDOnlineUserArr                   = [[NSMutableArray alloc]init];
        _EDAttendUserArr                   = [[NSMutableArray alloc]init];
        _MDRefSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}
-(void)setEDClassModel:(ETTOpenClassroomDoBackModel *)EDClassModel
{
    if (EDClassModel)
    {
        _EDClassModel = EDClassModel;
        [self createClassListArr];
    }
    
}
-(void)refreshClassOnlineData:(NSDictionary * )dic block:(ETTPutDataBlock)block
{
    if (!dic ||!dic.count)
    {
        block(ETTPROCESSINGDATANULL);
        return;
    }
    dispatch_queue_t serialQueue;
    serialQueue = dispatch_queue_create("com.example.SerialQueue", NULL);
  
  
   dispatch_async(serialQueue, ^{
        dispatch_semaphore_wait(_MDRefSemaphore, DISPATCH_TIME_FOREVER);
        if (_EDOnlineUserArr == nil)
        {
            _EDOnlineUserArr = [[NSMutableArray alloc]init];
        }
       NSArray * stuArr = [dic valueForKey:@"student"];
       [self manageOnlineUsers:stuArr];
        if (_EDAttendUserArr.count)
        {
            [_EDAttendUserArr removeAllObjects];
        }
        NSArray * attArr = [dic valueForKey:@"ObserveStudents"];
       
        for (NSDictionary * dic  in attArr)
        {
            ETTClassUserModel * model = [[ETTClassUserModel alloc]init];
            [model putInDataFordic:dic];
            model.userType = ETTCLASSTYPEATTEND;
            model.isOnline = YES;
            [_EDOnlineUserArr addObject:model];
            [_EDAttendUserArr addObject:model];
            
        }
    
        [self sumOnlineStudent];
        [self sumAllOnlineUsers];
        [self sumAttendOnlineUsers];
        
        block(ETTPROCESSINGDATASUCCESS);
       
       dispatch_semaphore_signal(_MDRefSemaphore);
    });

}


-(void)sumAllOnlineUsers
{
    ETTClassificationModel * cmodel = _EDClassListArr.firstObject;
    cmodel.onlineCount = _EDOnlineUserArr.count;
}
-(void)sumAttendOnlineUsers
{
    ETTClassificationModel * cmodel = _EDClassListArr.lastObject;
    cmodel.onlineCount = _EDAttendUserArr.count;
}

/**
 Description 处理收到刷新 班级在线人员

 @param onlineArr       班级内的在线学生信息数组
 */
-(void)manageOnlineUsers:(NSArray *)onlineArr
{
    if (onlineArr.count<=0 )
    {
        //1全部不在线
        [self allOffLine];
        [self sumOnlineStudent];
        return;
    }
    
    //2 移除在线的旁听生
    [self removeAttendUsersinOnlineUsers];
    //向班级点名 响应在线状态 将 在线人员记录在临时数组中
    NSMutableArray * tempOnlineUserArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary * dic in onlineArr)
    {
        NSInteger jid =  [[dic valueForKey:@"jid"] integerValue];
        for (ETTClasssModel  * model in _EDClassModel.classModelList)
        {
            ETTClassUserModel * userModel = [model getUserModelForJid:jid];
            if (userModel)
            {
                userModel.isOnline = YES;
                [tempOnlineUserArr addObject:userModel];
            }
            
        }
    }
    //将掉线的人员记录在临时数组中
    NSMutableArray * marr = [NSMutableArray new];
    for (ETTClassUserModel * umodel in _EDOnlineUserArr)
    {
        if (umodel.userType ==ETTCLASSTYPEATTEND )
        {
            continue;
        }
        if (![tempOnlineUserArr containsObject:umodel])
        {
            umodel.isOnline = false;
            [marr addObject:umodel];
        }
        
    }
    //将在线数组中的不在线人员删除
    for (ETTClassUserModel * umodel in marr)
    {
        [_EDOnlineUserArr removeObject:umodel];
    }
    
    //将在线临时数组中的人员 没有出现在 在线数组中人员加入在线数组
    
    for (ETTClassUserModel * umodel in tempOnlineUserArr)
    {
        if (umodel.userType ==ETTCLASSTYPEATTEND )
        {
            continue;
        }
        if (![_EDOnlineUserArr containsObject:umodel])
        {
            [_EDOnlineUserArr addObject:umodel];
        }
        
    }
    [self filterOnlineModel];
    //按照在线状态排序
    [self sortDescriptorlassModelList];
    
    
    //统计 班级人员在线信息
    [self sumOnlineStudent];
}

-(void)filterOnlineModel
{
    if (_EDOnlineUserArr == nil ||_EDOnlineUserArr.count<2 )
    {
        return;
    }

    NSMutableSet *seenObjects = [NSMutableSet set];
    NSPredicate *dupPred = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
        ETTClassUserModel *hObj = (ETTClassUserModel*)obj;
        BOOL seen = [seenObjects containsObject:hObj.jid];
        if (!seen) {
            [seenObjects addObject:hObj.jid];
        }
        return !seen;
    }];
    
    [_EDOnlineUserArr filterUsingPredicate:dupPred];
  
    
    
}
/**
 Description 全部掉线 将在线人员数组 清空，并将人员状态设置为不在线
 */
-(void)allOffLine
{
    for (ETTClassUserModel * model in _EDOnlineUserArr)
    {
        model.isOnline = false;
    }
    [_EDOnlineUserArr removeAllObjects];
}
-(void)sumOnlineStudent
{
   
    
    for (int i = 0; i<_EDClassListArr.count; i++)
    {
        
        ETTClassificationModel * cmodel = _EDClassListArr[i];
        if (cmodel.classType == ETTCLASSESTABLISH)
        {
            ETTClasssModel * classModel = [self getClassModel:cmodel.classId];
            cmodel.onlineCount = [classModel getClassUserOnlineCount];

        }
        
    }

}

-(void)removeAttendUsersinOnlineUsers
{
    if (_EDOnlineUserArr.count<=0)
    {
        return;
    }
    
    for (ETTClassUserModel  * model  in _EDOnlineUserArr)
    {
        if (model.userType == ETTCLASSTYPEATTEND )
        {
            [_EDOnlineUserArr removeObject:model];
        }
    }
}
//对班级内的学生和在线学生进行对比改变在线状态
//现在离线 不正确
-(void)refreshClassStudentData:(NSString *)classId
{
    if (!classId.length)
    {
        return;
    }
    NSArray * stuArr= [self getClassStuden:classId];
    
    for (ETTClassUserModel * model in _EDOnlineUserArr)
    {
        for (ETTClassUserModel * stumodel in stuArr)
        {
            if (stumodel.jid.integerValue == model.jid.integerValue)
            {
                stumodel.isOnline = YES;
                continue;
                
            }
        
        }
    }
  
    
    
    [self sortDescriptorlassModelList];
}

-(void)sortDescriptorlassModelList
{
    for (ETTClasssModel  * model in _EDClassModel.classModelList)
    {
        [model sortDescriptorUserOnline];
    }
}
-(void)refreshClassStudentWithClassModel:(ETTClasssModel *)classModel
{
    if (classModel== nil)
    {
        return;
    }
    
    NSArray * stuArr   = [self getClassStudentWitchClassModel:classModel];
    for (ETTClassUserModel * model in _EDOnlineUserArr)
    {
        for (ETTClassUserModel * stumodel in stuArr)
        {
            if (stumodel.jid.integerValue == model.jid.integerValue)
            {
                stumodel.isOnline = YES;
            }
        }
    }
}

-(void)InspectionOnlineUserModel:(ETTClassUserModel *) model
{
    
}
-(void)setStudentAnswerData:(NSArray *  )arr
{
    if (arr)
    {
        for (ETTClasssModel * classModel in _EDClassModel.classModelList)
        {
            for (ETTResponderModel * reModel in arr)
            {
                ETTClassUserModel * stumodel= [classModel getUserModelForJid:reModel.jid.integerValue];
                if (stumodel)
                {
                    stumodel.answerCount ++;
                    continue;
                }
                
            }
        }
       
    }
}
-(void)processingDataClassMap:(NSDictionary *)dic
{
    if (!dic )
    {
        _EDGetStudentsIntegral = YES;
        return;
    }
    
   _EDRollCallCount   =  [[dic valueForKey:@"rollCallCount"] integerValue];
    _EDResponderCount =  [[dic valueForKey:@"answerCount"] integerValue];
     NSArray *  userArr     =  [dic valueForKey:@"data"];
    for ( NSDictionary * udic in userArr)
    {
        for (ETTClasssModel  * classmodel in _EDClassModel.classModelList)
        {
            [classmodel updateStudentsIntegral:udic];
        }
    }
    _EDGetStudentsIntegral = YES;
    
}
-(void)createClassListArr
{
    if (_EDClassListArr == nil)
    {
        _EDClassListArr = [[NSMutableArray alloc]init];
                           
    }
    
    for (int i = 0; i<_EDClassModel.classModelList.count ; i++)
    {
        ETTClasssModel  * classModel   = _EDClassModel.classModelList[i];
        ETTClassEstablishModel * model = [[ ETTClassEstablishModel alloc]init];
        model.classId                  = classModel.classId;
        model.className                = classModel.className;

        model.studentCount = [self getUserCountInModel:classModel];
        ////////////////////////////////////////////////////////
        /*
         new      : Modify
         time     : 2017.3.7  16:40
         modifier : 康晓光
         version  ：Dev-0224
         branch   ：1043
         describe : 将新疆成都老客户端xinjiangHIRedis0305 分支上代码优化move到Dev-0224上的工作任务 防止数组越界
         */
        
        NSInteger index =_EDClassListArr.count-1;
        if (index<0)
        {
            break;
        }
        [_EDClassListArr insertObject:model atIndex:index];
        /////////////////////////////////////////////////////
        
       
    }
}

-(NSArray<ETTClasssModel *> *)getClassStuden:(NSString *)classId
{
    ETTClasssModel  * classModel = nil;
    for ( ETTClasssModel  * model in _EDClassModel.classModelList)
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
    return modelArr;
}

-(NSArray<ETTClasssModel *> *)getClassStudentWitchClassModel:(ETTClasssModel  *)classModel
{
     NSMutableArray * modelArr = [NSMutableArray array];
     if (classModel )
     {
         for (int j = 0; j<classModel.groupList.count; j++)
         {
             ETTClasssGroupModel * groupModel = classModel.groupList[j];
             for (int i = 0; i<groupModel.userList.count; i++) {
                 [modelArr addObject:groupModel.userList[i]];
             }
         }
     }
    return modelArr;
}
-(NSInteger )getUserCountInModel:(ETTClasssModel  *)classModel
{
    NSInteger count = 0;
    if (classModel == nil)
    {
        return count;
    }
    for (int i = 0; i<classModel.groupList.count; i++)
    {
        ETTClasssGroupModel * groupModel = classModel.groupList[i];
        
        count = count + groupModel.userList.count;
    }
    return count;
}
//获取所有学生数量
-(NSInteger )getSumInClass
{
     NSInteger stuCount = 0;
    if (_EDClassModel == nil)
    {
        return stuCount;
    }
   
    for (int i = 0; i<_EDClassModel.classModelList.count ; i++)
    {
        ETTClasssModel  * classModel =_EDClassModel.classModelList[i];
    
        for (int j = 0; j<classModel.groupList.count; j++)
        {
            ETTClasssGroupModel * groupModel= classModel.groupList[j];
            stuCount = stuCount + groupModel.userList.count;
        }
    
    }
    return stuCount;
}
//获取班级总数
-(NSInteger )getClassCount
{
    if (_EDClassModel)
    {
        return _EDClassModel.classModelList.count;
    }
    return 0;
}
//获取班级里所有分组数量
-(NSInteger)getGroupCount:(NSString *)classId
{
    NSInteger count = 0;
    if (_EDClassModel == nil)
    {
        return count;
    }
    for (ETTClasssModel * model in  _EDClassModel.classModelList)
    {
        if ([model.classId isEqualToString:classId])
        {
            count = model.groupList.count;
        }
    }
    return count;
}
//获取班级里所有在线学生数量
-(NSInteger *)getOnlineCountInClass:(NSString *)classId
{
    return 0;
}

-(ETTClasssModel *)getClassModel:(NSString *)classId
{
    if (_EDClassModel == nil || !classId.length)
    {
        return nil;
    }
    ETTClasssModel * classmodel = nil;
    
    for (ETTClasssModel * model in  _EDClassModel.classModelList)
    {
        if (model.classId.integerValue == classId.integerValue)
        {
            classmodel = model;
            break;
        }
    }
    
    return classmodel;
}
@end
