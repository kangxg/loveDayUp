//
//  ETTRedisManagerConst.m
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
//  Created by zhaiyingwei on 2016/10/31.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisManagerConst.h"
#import "GlobelDefine.h"
#ifdef ETTKxgTest

NSString * const kPCI_CLASSROOM_STATE = @"pcl_cache_classroom_state:";

NSString * const kPCI_SCHOOLCHANNEL = @"pcl_channel_online:school_IOS_QQ";

NSString * const kPCI_CLASSROOM_CHANNEL = @"_AXP_IOS_QQ";
#else
NSString * const kPCI_CLASSROOM_STATE = @"pcl_cache_classroom_state:";

NSString * const kPCI_SCHOOLCHANNEL = @"pcl_channel_online:school_IOS_Z03";

NSString * const kPCI_CLASSROOM_CHANNEL = @"_AXP_IOS_Z03";

#endif
//班级了学生表现积分
NSString * const kPCI_CLASSROOM_INTEGRAL = @"pcl_cache_classroom_studentIntegral:";

NSString * const kPCI_PLAY_EACH_OTHER = @"pcl_play_each_other";



const int64_t kHEARTBEAT_TIME = 5.0;
NSString * const kPCI_STUDENT_MANAGEMENT = @"_student_management";

NSString * const kPCI_WHICHPERFORMED = @"_whichperformed";

const CGFloat kIMAGE_WIDTH_VIEW_STUDENT = 1600.0;
const CGFloat kIMAGE_HEIGHT_VIEW_STUDENT = 900.0;


const CGFloat kREDIS_CONNECT_DEFAULT_INTERVAL = 5.0;
const CGFloat kREDIS_CHANNEL_DEFAULT_INTERVAL = 5.0;
const CGFloat kREDIS_CONNECT_SCALE = 2.5;
const CGFloat kREDIS_GET_DEFAULT_INTERVAL = 5.0;
const CGFloat kREDIS_SET_DEFAULT_INTERVAL = 5.0;
const CGFloat kREDIS_CONVOY_TIME = 25.0;
//const CGFloat kREDIS_CONVOY_TIME = 5.0;
const CGFloat kREDIS_HEARTBEAT_TIME = 10.0;

NSString * const kREDIS_CANCEL_MONITOR_SCHOOL_NOTIFICATION = @"RedisCancelMonitorNotification";
NSString * const kREDIS_MONITOR_SCHOOL_NOTIFICATION = @"RedisMonitorSchoolNotification";
NSString * const kREDIS_CREATE_CLASSROOM_DATASOURCES = @"RedisCreateClassroomDatasources";
NSString * const kREDIS_UNSUBCRIBTION_CLASSROOM = @"RedisUnSubcribtionClassroom";
NSString * const kREDIS_STUDENT_GET_CLASSROOMMESSAGE = @"RedisStudentGetClassroommessage";
NSString * const kREDIS_TEACHER_PUSH_CLASSROOMMESSAGE = @"RedisTeacherPushClassroommessage";
NSString * const kREDIS_STUDNET_GET_TEACHER_INFO = @"RedisStudentGetTeacherInfo";
NSString * const kREDIS_THEACHER_GET_STUDENT_INFO = @"RedisTeacherGetStudnetInfo";


/** 课程相关 老师发给学生命令*/
NSString * const kREDIS_COMMAND_TYPE_CO_01 = @"RedisCommandTypeCO01";
NSString * const kREDIS_COMMAND_TYPE_CO_02 = @"RedisCommandTypeCO02";
NSString * const kREDIS_COMMAND_TYPE_CO_03 = @"RedisCommandTypeCO03";
NSString * const kREDIS_COMMAND_TYPE_CO_04 = @"RedisCommandTypeCO04";
NSString * const kREDIS_COMMAND_TYPE_CO_05 = @"RedisCommandTypeCO05";


/**课程相关 学生发给老师命令 */
NSString * const kREDIS_COMMAND_TYPE_SCO_01 = @"RedisCommandTypeSCO01";


NSString * const kREDIS_COMMAND_TYPE_WB_01 = @"RedisCommandTypeWB01";
NSString * const kREDIS_COMMAND_TYPE_WB_02 = @"RedisCommandTypeWB02";
NSString * const kREDIS_COMMAND_TYPE_WB_03 = @"RedisCommandTypeWB03";
NSString * const kREDIS_COMMAND_TYPE_WB_04 = @"RedisCommandTypeWB04";
NSString * const kREDIS_COMMAND_TYPE_WB_05 = @"RedisCommandTypeWB05";
NSString * const kREDIS_COMMAND_TYPE_WB_06 = @"RedisCommandTypeWB06";

//学生发给老师
NSString * const kREDIS_COMMAND_TYPE_SWB_02 = @"RedisCommandTypeSWB02";
NSString * const kREDIS_COMMAND_TYPE_SWB_03 = @"RedisCommandTypeSWB03";
NSString * const kREDIS_COMMAND_TYPE_SWB_04 = @"RedisCommandTypeSWB04";


NSString * const kREDIS_COMMAND_TYPE_MA_01 = @"RedisCommandTypeMA01";
NSString * const kREDIS_COMMAND_TYPE_MA_02 = @"RedisCommandTypeMA02";
NSString * const kREDIS_COMMAND_TYPE_MA_03 = @"RedisCommandTypeMA03";
NSString * const kREDIS_COMMAND_TYPE_MA_04 = @"RedisCommandTypeMA04";
NSString * const kREDIS_COMMAND_TYPE_SMA_04 = @"RedisCommandTypeSMA04";
NSString * const kREDIS_COMMAND_TYPE_MA_05 = @"RedisCommandTypeMA05";
NSString * const kREDIS_COMMAND_TYPE_MA_05_END = @"RedisCommandTypeMA05End";
NSString * const kREDIS_COMMAND_TYPE_MA_06 = @"RedisCommandTypeMA06";

NSString * const kREDIS_COMMAND_TYPE_MA_06_END = @"RedisCommandTypeMA06End";

NSString * const kREDIS_COMMAND_TYPE_MA_07_BEGIN = @"RedisCommandTypeMA07begin";
NSString * const kREDIS_COMMAND_TYPE_MA_07_END = @"RedisCommandTypeMA07end";
NSString * const kREDIS_COMMAND_TYPE_SMA_07 = @"RedisCommandTypeSMA07";

NSString * const kREDIS_COMMAND_TYPE_CP_01 = @"RedisCommandTypeCP01";

NSString * const kREDIS_COMMAND_TYPE_CLOSE = @"RedisCommandTypeClose";
NSString * const kREDIS_COMMAND_TYPE_LEAVE = @"RedisCommandTypeLeave";

NSString * const kCREATE_CLASSROOM_ATTRIBUTES_TIME = @"time";
NSString * const kCREATE_CLASSROOM_ATTRIBUTES_USERID = @"userId";
NSString * const kCREATE_CLASSROOM_ATTRIBUTES_USERINFO = @"userInfo";


NSString * const kLOCK_SCREEN_PAUSE_VIDEO = @"lockPauseVideo";//收到锁屏时暂停视频
NSString * const kANSWER_PAUSER_VIDEO = @"answerPauseVideo";//抢答时暂停视频


NSString * const kEXIT = @"exit";










