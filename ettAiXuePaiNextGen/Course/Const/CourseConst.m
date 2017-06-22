//
//  CourseConst.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "CourseConst.h"

//测试接口-------------
/**
 *  教师课程列表
 */
NSString * const getCourseListForTeacher     = @"axpad/classroom/getCourseListForTeacher.do";

/**
 *  教师课件列表
 */
NSString * const getCoursewareListForTeacher = @"axpad/classroom/getCoursewareListForTeacher.do";

/**
 *  教师试卷列表
 */
NSString * const getTestPageList             = @"axpad/classroom/getTestPageList.do";




NSString * const setCoursewareVisible        = @"axpad/classroom/setCoursewareVisible.do";


NSString * const kCLASS_CLOSED               = @"ClassWasClosed";

NSString * const iPadMini1                   = @"iPad Mini 1";




//==================学生=====================

/**
 *  学生课程列表
 */
NSString * const getCourseListForStu         = @"axpad/classroom/getCourseListForStu.do";

/**
 *  学生课件列表
 */
NSString * const getCoursewareListForStu     = @"axpad/classroom/getCoursewareListForStu.do";



//正式接口------------------------








/**
 *  @author LiuChuanan, 17-03-13 17:40:57
 *  
 *  @brief 试卷页面的alert
 *
 *  @since 
 */

/////////********** 试卷alert *********/////////

/**
 *  推单道题
 */
NSString * const pushSingleItem = @"101";

/**
 *  获取试卷当前页
 */
NSString * const getCurrentPage = @"106";

/**
 *  主观题 查看详情 107
 */
NSString * const checkAnswerDetail = @"107";

/**
 *  每次向h5提交答案后都会弹 获得已提交的人数 110
 */
NSString * const getCommitedStudentCount = @"110";

/**
 *  答对奖励 111
 */
NSString * const rewardToRightAnswer = @"111";

/**
 *  页面加载完成 112
 */
NSString * const finishLoad = @"112";

/**
 *  显示试卷统计页面 117
 */
NSString * const showStatisticsPaper = @"117";

/**
 *  隐藏试卷统计页面 118
 */
NSString * const hideStatisticsPaper = @"118";

/**
 *  判断试卷中有几道题 120
 */
NSString * const getquestionCount = @"120";




