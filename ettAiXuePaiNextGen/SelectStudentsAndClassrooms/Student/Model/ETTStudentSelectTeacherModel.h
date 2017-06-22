//
//  ETTStudentSelectTeacherModel.h
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
//  学生选课按钮
//

#import <Foundation/Foundation.h>

@interface ETTStudentSelectTeacherModel : NSObject <NSCoding>
///头像 userPhto
@property (nonatomic , copy)NSString    *iconURL;
///教师名字 userName
@property (nonatomic , copy)NSString    *titlName;
///userid
@property (nonatomic , copy)NSString    *userId;
@property (nonatomic , copy)NSString    *time;

///教师当前创建课堂的classId组合
@property (nonatomic , copy)NSString    *classIdsStr;
@property (nonatomic , copy)NSString    *classroomId;
@property (nonatomic , copy)NSString    *gradeId;
@property (nonatomic , copy)NSString    *subjectId;
///当前课堂的基本信息.

/**
 *  @author LiuChuanan, 17-05-08 15:27:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 7
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic , strong)NSArray     *classList;

@property (nonatomic , assign)BOOL      selected;


-(instancetype)initWithIconURL:(NSString *)userPhoto titleName:(NSString *)userName userId:(NSString *)userId;
-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
