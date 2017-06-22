//
//  ETTRedisManagerConst.h
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

#import <Foundation/Foundation.h>

UIKIT_EXTERN const int64_t kHEARTBEAT_TIME;

////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

UIKIT_EXTERN NSString * const kPCI_CLASSROOM_STATE;
///学校频道的前缀
UIKIT_EXTERN NSString * const kPCI_SCHOOLCHANNEL;
///班级消息推送的后缀
UIKIT_EXTERN NSString * const kPCI_CLASSROOM_CHANNEL;
///学生在线状态
UIKIT_EXTERN NSString * const kPCI_STUDENT_MANAGEMENT;

UIKIT_EXTERN NSString * const kPCI_WHICHPERFORMED;


UIKIT_EXTERN NSString * const kPCI_CLASSROOM_INTEGRAL;

UIKIT_EXTERN NSString * const kPCI_PLAY_EACH_OTHER;
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///查看学生当前状态的学生屏幕截图的大小
UIKIT_EXTERN const CGFloat kIMAGE_WIDTH_VIEW_STUDENT;
UIKIT_EXTERN const CGFloat kIMAGE_HEIGHT_VIEW_STUDENT;

///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

///redis的默认链接间隔时间
UIKIT_EXTERN const CGFloat kREDIS_CONNECT_DEFAULT_INTERVAL;

///向channel推送消息的默认时间间隔。
UIKIT_EXTERN const CGFloat kREDIS_CHANNEL_DEFAULT_INTERVAL;

///默认验证时间的倍数
UIKIT_EXTERN const CGFloat kREDIS_CONNECT_SCALE;

///redis默认连续GET间隔时间。
UIKIT_EXTERN const CGFloat kREDIS_GET_DEFAULT_INTERVAL;

///redis默认连续SET间隔时间。
UIKIT_EXTERN const CGFloat kREDIS_SET_DEFAULT_INTERVAL;

///默认的判断断网的间隔时间。
UIKIT_EXTERN const CGFloat kREDIS_CONVOY_TIME;

///心跳护航的时间。
UIKIT_EXTERN const CGFloat kREDIS_HEARTBEAT_TIME;
/*
 *  redis操作命令的监听~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
//创建学校频道订阅
UIKIT_EXTERN NSString * const kREDIS_MONITOR_SCHOOL_NOTIFICATION;

//取消学校频道的监听
UIKIT_EXTERN NSString * const kREDIS_CANCEL_MONITOR_SCHOOL_NOTIFICATION;

//更新学生选择课程的老师信息的数据源
UIKIT_EXTERN NSString * const kREDIS_CREATE_CLASSROOM_DATASOURCES;
//退订班级信息
UIKIT_EXTERN NSString * const kREDIS_UNSUBCRIBTION_CLASSROOM;
//学生进入课堂以后获得课堂需要的信息。
UIKIT_EXTERN NSString * const kREDIS_STUDENT_GET_CLASSROOMMESSAGE;
//老师创建课堂以后像课堂频道推送消息。
UIKIT_EXTERN NSString * const kREDIS_TEACHER_PUSH_CLASSROOMMESSAGE;
///老师向学生发送消息
UIKIT_EXTERN NSString * const kREDIS_STUDNET_GET_TEACHER_INFO;
///学生向老师发送通知
UIKIT_EXTERN NSString * const kREDIS_THEACHER_GET_STUDENT_INFO;

///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_CO_01;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_CO_02;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_CO_03;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_CO_04;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_CO_05;

UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_SCO_01;//学生发给老师

UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_WB_01;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_WB_02;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_WB_03;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_WB_04;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_WB_05;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_WB_06;

UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_SWB_02;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_SWB_03;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_SWB_04;

UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_01;
///奖励
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_02;
///提醒
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_03;
///查看
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_04;
///学生发送当前被查看的信息
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_SMA_04;
///锁屏
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_05;
///解锁
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_05_END;
///点名
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_06;
//关闭点名
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_06_END;
///抢答
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_07_BEGIN;
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_MA_07_END;
//学生确认抢答信息
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_SMA_07;

///教师更新学生课堂表现
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_CP_01;

///教师通知学生课堂关闭
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_CLOSE;
///教师离开课堂
UIKIT_EXTERN NSString * const kREDIS_COMMAND_TYPE_LEAVE;

///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//接收教师常见课堂请求的数据的时间戳属性.....（以后要改这是安卓的，IOS是time）
UIKIT_EXTERN NSString * const kCREATE_CLASSROOM_ATTRIBUTES_TIME;
UIKIT_EXTERN NSString * const kCREATE_CLASSROOM_ATTRIBUTES_USERID;
UIKIT_EXTERN NSString * const kCREATE_CLASSROOM_ATTRIBUTES_USERINFO;

///收到锁屏时暂停视频
UIKIT_EXTERN NSString * const kLOCK_SCREEN_PAUSE_VIDEO;

///抢答时暂停视频
UIKIT_EXTERN NSString * const kANSWER_PAUSER_VIDEO;

UIKIT_EXTERN NSString * const kEXIT;


