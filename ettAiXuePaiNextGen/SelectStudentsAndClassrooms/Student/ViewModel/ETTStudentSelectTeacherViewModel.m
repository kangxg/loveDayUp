//
//  ETTStudentSelectTeacherViewModel.m
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
//  Created by zhaiyingwei on 2016/10/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentSelectTeacherViewModel.h"

@implementation ETTStudentSelectTeacherViewModel

+(ETTStudentSelectTeacherViewModel *)sharedStudentSelectTeacherViewModel
{
    static ETTStudentSelectTeacherViewModel *studentModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        studentModel = [[ETTStudentSelectTeacherViewModel alloc]init];
    });
    return studentModel;
}

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(NSArray *)getArrayWithStudentSelectTeacherModel
{
    NSArray *arr = [NSArray arrayWithArray:[self createModel]];
    return arr;
}

-(NSArray *)createModel
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<10; i++) {
        ETTStudentSelectTeacherModel *objModel = [[ETTStudentSelectTeacherModel alloc]initWithIconURL:@"http://attach.etiantian.com/common/cooperateschool/teacher/upload/axpad_unknown.png" titleName:[NSString stringWithFormat:@"苍老师%d号",i] userId:@"aaaaa"];
        [arr addObject:objModel];
    }
    return arr;
}

-(NSMutableArray *)getDataSourceForStudentSelectTeacherModelWithArray:(NSArray *)arr
{

    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    if (arr&&arr.count>0) {
        for (int i=0; i<arr.count; i++) {
            NSDictionary *obj = arr[i];
            NSMutableDictionary *dic               = [obj objectForKey:@"message"];
            [dic setObject:[obj objectForKey:@"time"] forKey:@"time"];
            [dic setObject:[obj objectForKey:@"classList"] forKey:@"classList"];
            
            ETTStudentSelectTeacherModel *objModel = [[ETTStudentSelectTeacherModel alloc]initWithDictionary:[NSDictionary dictionaryWithDictionary:dic]];
            [dataArr addObject:objModel];
        }
        
    }
    return dataArr;
}

@end
