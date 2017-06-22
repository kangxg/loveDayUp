//
//  ETTTeacherChooseClassroomModel.m
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
//  Created by zhaiyingwei on 2016/10/19.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherChooseClassroomModel.h"

@implementation ETTTeacherChooseClassroomModel

@synthesize jid         =       _jid;
@synthesize schoolId    =       _schoolId;
@synthesize classIdsStr =       _classIdsStr;
@synthesize gradeId     =       _gradeId;
@synthesize subjectId   =       _subjectId;
@synthesize classId     =       _classId;

-(instancetype)initWithIndexPath:(NSIndexPath *)indexPath
{
    if (self = [super init]) {
        [self updateAttributeWithIndexPath:indexPath];
    }
    return self;
}

-(instancetype)updateAttributeWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *typeDic     = [NSDictionary dictionaryWithDictionary:[ETTUSERDefaultManager getUserTypeDictionary]];
    NSDictionary *allClassDic = [[NSArray arrayWithArray:[ETTUSERDefaultManager getUserClassTagListForUserType:ETTUSERDefaultTypeTeacher]]objectAtIndex:indexPath.section];
    NSArray *classList        = [NSArray arrayWithArray:[allClassDic objectForKey:@"classList"]];
    NSDictionary *classDic    = [NSDictionary dictionaryWithDictionary:[classList objectAtIndex:indexPath.row]];
    NSDictionary *teacherDic = [NSDictionary dictionaryWithDictionary:[typeDic objectForKey:@"teacher"]];
    
    [self setJid:[NSString stringWithFormat:@"%@",[teacherDic valueForKey:@"jid"]]];
    [self setSchoolId:[NSString stringWithFormat:@"%@",[teacherDic valueForKey:@"schoolId"]]];
    [self setGradeId:[allClassDic valueForKey:@"gradeId"]];
    [self setSubjectId:[allClassDic valueForKey:@"subjectId"]];
    [self setClassTag:[NSString stringWithFormat:@"%@",[allClassDic valueForKey:@"classTag"]]];
    [self setClassName:[NSString stringWithFormat:@"%@",[classDic valueForKey:@"className"]]];
    [self setClassId:[NSString stringWithFormat:@"%@",[classDic valueForKey:@"classId"]]];
    
    return self;
}

-(void)dealloc
{
    _classIdsStr = nil;
}

@end
