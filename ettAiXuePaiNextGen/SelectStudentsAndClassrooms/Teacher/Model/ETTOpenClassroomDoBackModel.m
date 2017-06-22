//
//  ETTOpenClassroomDoBackModel.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 2016/10/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTOpenClassroomDoBackModel.h"

@implementation ETTOpenClassroomDoBackModel

@synthesize classroomId         =   _classroomId;
@synthesize lastClassroomId     =   _lastClassroomId;
@synthesize classList           =   _classList;
@synthesize courseList          =   _courseList;
@synthesize coursesTag          =   _coursesTag;
@synthesize cloudNowTime        =   _cloudNowTime;
@synthesize numLimit            =   _numLimit;
@synthesize subLimit            =   _subLimit;
@synthesize jid                 =   _jid;
@synthesize schoolId            =   _schoolId;
@synthesize gradeId             =   _gradeId;
@synthesize subjectId           =   _subjectId;
@synthesize classIdsStr         =   _classIdsStr;


-(instancetype)initWithDictionary:(NSDictionary *)dataDic
{
    if (self = [super init]) {
        [self setClassroomId:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"classroomId"]]];
        [self setLastClassroomId:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"lastClassroomId"]]];
        [self setCourseList:[NSArray arrayWithArray:[dataDic valueForKey:@"courseList"]]];
        [self setCoursesTag:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"coursesTag"]]];//课程名称
        [self setCloudNowTime:[dataDic valueForKey:@"cloudNowTime"]];
        [self setNumLimit:[[dataDic valueForKey:@"numLimit"] intValue]];
        [self setSubLimit:[[dataDic valueForKey:@"subLimit"] intValue]];
        [self setJid:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"jid"]]];
        [self setSchoolId:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"schoolId"]]];
        [self setGradeId:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"gradeId"]]];
        [self setClassIdsStr:[NSString stringWithFormat:@"%@",dataDic[@"classIdsStr"]]];
        [self setSubjectId:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"subjectId"]]];
        _classList = [[NSMutableArray alloc]init];
        [self setClassList:[dataDic valueForKey:@"classList"]];
        [self processingDataClassList:[dataDic valueForKey:@"classList"]];
        [self getClassModeltoDic:self.classModelList];
    }
    
    return self;
}

-(NSDictionary *)getDictionaryWithModle
{
    int time = 0;
    if ([_cloudNowTime isKindOfClass:[NSNumber class]])
    {
        time = _cloudNowTime.intValue;
    }
    NSDictionary *dict = @{@"classroomId":self.classroomId,
                           @"lastClassroomId":self.lastClassroomId,
                           @"courseList":self.courseList,
                           @"coursesTag":self.coursesTag,
                           @"cloudNowTime":@(time),
                           @"numLimit":[NSString stringWithFormat:@"%d",time],
                           @"subLimit":[NSString stringWithFormat:@"%d",(int)self.subLimit],
                           @"jid":[NSString stringWithFormat:@"%@",self.jid],
                           @"schoolId":[NSString stringWithFormat:@"%@",self.schoolId],
                           @"gradeId":[NSString stringWithFormat:@"%@",self.gradeId],
                           @"classIdsStr":self.classIdsStr,
                           @"subjectId":self.subjectId,
                           @"classList":[self getArrayWithClassList]
                           };
    return dict;
}


-(NSString     *)getClassModelToJsonString
{
    return [self getClassModelToJsonStringForModelArr:self.classModelList];
}

-(NSString     *)getClassModelToJsonStringForModelArr:(NSArray *)modelArr
{
    NSDictionary * classDic = [self getClassModeltoDic:modelArr];
    NSString * jsonString = [self getDicToJsonString:classDic];
    return jsonString;
}

-(NSMutableDictionary * )getClassModeltoDic:(NSArray *)modelArr
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (int i  = 0; i<modelArr.count; i++)
    {
        ETTClasssModel * model = modelArr[i];
        NSDictionary * dic =  [model transformModelToNSDictionary];
        [arr addObject:dic];
        
    }
    NSMutableDictionary * classDic  = [[NSMutableDictionary alloc]init];
    [classDic setValue:arr forKey:@"classList"];

    return classDic;
}

-(NSArray *)getArrayWithClassList
{
    return [[self getClassModeltoDic:self.classModelList]objectForKey:@"classList"];
}

-(NSMutableDictionary * )getClassModeltoDic
{
    return [self getClassModeltoDic:self.classModelList];
   
}

-(NSArray *)getClassClassIntegral
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (int i  = 0; i<self.classModelList.count; i++)
    {
        ETTClasssModel * model = self.classModelList[i];
        [arr addObjectsFromArray:[model getAllUserIntegral]];
        
    }

    return arr;
}
-(void)changeRewardScoreUserModel:(NSInteger)jid
{
    for (int i  = 0; i<self.classModelList.count; i++)
    {
        ETTClasssModel * model = self.classModelList[i];
        ETTClassUserModel * userModel = [model getUserModelForJid:jid];
        if (userModel) {
            userModel.rewardScore++;
        }
        
    }
}

-(void)processingDataClassList:(NSArray *)arr
{
    if (_classModelList == nil)
    {
        _classModelList = [[NSMutableArray alloc]init];
    }
    if (arr)
    {
        
        for (NSDictionary * dic in arr)
        {
            ETTClasssModel * model = [[ETTClasssModel alloc]init];
            if (![model putInData:dic]) {
                continue;
            }
            else
            {
                [_classModelList addObject:model];
            }
        }
    }
}
-(NSString *)description
{
    NSLog(@"ETTOpenClassroomDoBackModel is  classroomId == %@ \n lastClassroomId == %@ \n classList == %@ \n courseList == %@ \n coursesTag == %@ \n cloudNowTime == %@ \n numLimit == %ld \n subLimit == %ld \n classIdsStr == %@",_classroomId,_lastClassroomId,_classList,_courseList,_coursesTag,_cloudNowTime,(long)_numLimit,(long)_subLimit,_classIdsStr);
    return @"hello!";
}

@end
