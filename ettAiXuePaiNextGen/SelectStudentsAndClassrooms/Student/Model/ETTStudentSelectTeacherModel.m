//
//  ETTStudentSelectTeacherModel.m
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
//  Created by zhaiyingwei on 2016/10/13.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentSelectTeacherModel.h"

@interface ETTStudentSelectTeacherModel ()

@end

@implementation ETTStudentSelectTeacherModel
@synthesize iconURL         =       _iconURL;
@synthesize titlName        =       _titlName;
@synthesize userId          =       _userId;
@synthesize classIdsStr     =       _classIdsStr;
@synthesize subjectId       =       _subjectId;
@synthesize gradeId         =       _gradeId;
@synthesize selected        =       _selected;
@synthesize classList       =       _classList;
@synthesize time            =       _time;

-(instancetype)initWithIconURL:(NSString *)userPhoto titleName:(NSString *)userName userId:(NSString *)userId
{
    if (self = [super init]) {
        [self setIconURL:userPhoto];
        [self setTitlName:userName];
        [self setUserId:userId];
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setIconURL:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userPoto"]]];
        [self setTitlName:[dic objectForKey:@"userName"]];
        [self setUserId:[dic objectForKey:@"userId"]];
        [self setClassIdsStr:[dic objectForKey:@"classIdsStr"]];
        [self setClassroomId:[dic objectForKey:@"classroomId"]];
        [self setSubjectId:dic[@"subjectId"]];
        [self setGradeId:dic[@"gradeId"]];
        [self setTime:dic[@"time"]];
        [self setSelected:NO];
        [self setClassList:dic[@"classList"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.iconURL forKey:@"iconURL"];
    [aCoder encodeObject:self.titlName forKey:@"titlName"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.classIdsStr forKey:@"classIdsStr"];
    [aCoder encodeObject:self.classroomId forKey:@"classroomId"];
    [aCoder encodeObject:self.subjectId forKey:@"subjectId"];
    [aCoder encodeObject:self.gradeId forKey:@"gradeId"];
    [aCoder encodeInteger:self.selected forKey:@"selected"];
    [aCoder encodeObject:self.classList forKey:@"classList"];
    [aCoder encodeObject:self.time forKey:@"time"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.iconURL     = [aDecoder decodeObjectForKey:@"iconURL"];
        self.titlName    = [aDecoder decodeObjectForKey:@"titlName"];
        self.userId      = [aDecoder decodeObjectForKey:@"userId"];
        self.classIdsStr = [aDecoder decodeObjectForKey:@"classIdsStr"];
        self.classroomId = [aDecoder decodeObjectForKey:@"classroomId"];
        self.subjectId   = [aDecoder decodeObjectForKey:@"subjectId"];
        self.gradeId     = [aDecoder decodeObjectForKey:@"gradeId"];
        self.selected    = [aDecoder decodeIntegerForKey:@"selected"];
        self.classList   = [aDecoder decodeObjectForKey:@"classList"];
        self.time        = [aDecoder decodeObjectForKey:@"time"];
    }
    return self;
}

-(NSString *)description
{
    [super description];
    NSLog(@"iconURL is %@ \n titleName is %@ \n userId is %@ \n classIdsStr is %@ \n classroomId is %@ \n subjectId is %@ \n gradeId is %@ \n selected is %d \n classList is %@",self.iconURL,self.titlName,self.userId,self.classIdsStr,self.classroomId,self.subjectId,self.gradeId,self.selected,self.classList);
    return @"ETTStudentSelectTeacherModel";
}

@end
