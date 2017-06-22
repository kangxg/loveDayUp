//
//  ETTOpenClassroomDoBackModel.h
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

#import <Foundation/Foundation.h>
#import "ETTClasssModel.h"
@interface ETTOpenClassroomDoBackModel : NSObject

@property (nonatomic,copy)  NSString             *classroomId;       //课堂id
@property (nonatomic,copy)  NSString             *lastClassroomId;   //上一节课的id
@property (nonatomic,copy)  NSMutableArray<ETTClasssModel *>             *classList;         //班级列表
@property (nonatomic,copy)  NSString             *coursesTag;        //课组标识
@property (nonatomic,copy)  NSArray              *courseList;        //课程列表
@property (nonatomic,assign)NSNumber             *cloudNowTime;      //服务器当前的毫秒数
@property (nonatomic,assign)NSInteger            numLimit;           //课堂最大人数限制
@property (nonatomic,assign)NSInteger            subLimit;           //旁听最大人数限制
//deng
@property (nonatomic,copy) NSString              *jid;
@property (nonatomic,copy) NSString              *schoolId;
@property (nonatomic,copy) NSString              *gradeId;
@property (nonatomic,copy) NSString              *subjectId;

@property (nonatomic,copy) NSString              *classIdsStr;      //教师当前创建的课堂id


-(instancetype)initWithDictionary:(NSDictionary *)dataDic;

@end
