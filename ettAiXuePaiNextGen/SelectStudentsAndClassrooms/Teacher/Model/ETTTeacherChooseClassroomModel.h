//
//  ETTTeacherChooseClassroomModel.h
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
//  http://school.etiantian.com/aixuepad/axpad/classroom/openClassroom.do
//  输入参数

#import <Foundation/Foundation.h>
#import "ETTKit.h"
#import "ETTUSERDefaultManager.h"

@interface ETTTeacherChooseClassroomModel : NSObject

@property (nonatomic,copy)      NSString    *jid;               //用户id
@property (nonatomic,copy)      NSString    *schoolId;          //学校id
@property (nonatomic,copy)      NSString    *classIdsStr;       //上课班级串(多个班级中间用逗号分开)
@property (nonatomic,copy)      NSString    *gradeId;            //年级id
@property (nonatomic,copy)      NSString    *subjectId;          //学科id
@property (nonatomic,copy)      NSString    *classTag;          //班级标签
@property (nonatomic,copy)      NSString    *className;         //班级名
@property (nonatomic,copy)      NSString    *classId;           //班级id

-(instancetype)initWithIndexPath:(NSIndexPath *)indexPath;

@end
