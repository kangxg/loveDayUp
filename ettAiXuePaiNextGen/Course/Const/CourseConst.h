//
//  CourseConst.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//根据宏来判断是什么环境
//#ifdef <#macro#>
//
//#else


/**
 *  课程测试列表()
 */
UIKIT_EXTERN NSString * const getCourseListForTeacher;

/**
 *  老师课件列表
 */
UIKIT_EXTERN NSString * const getCoursewareListForTeacher;

/**
 *  老师试卷列表
 */
UIKIT_EXTERN NSString * const getTestPageList;


/**
 *  老师更改课件可见性
 */

UIKIT_EXTERN NSString * const setCoursewareVisible;


UIKIT_EXTERN NSString * const kCLASS_CLOSED;

UIKIT_EXTERN NSString * const iPadMini1;






//===========学生===========

/**
 *  学生课程列表
 */
UIKIT_EXTERN NSString * const getCourseListForStu;

/**
 *  学生课件列表
 */
UIKIT_EXTERN NSString * const getCoursewareListForStu;


/**
 *  @author LiuChuanan, 17-03-13 17:40:57
 *  
 *  @brief 试卷页面的alert
 *
 *  @since 
 */

/////////********** 试卷alert *********/////////

/**
 *  推单道题 101
 */
UIKIT_EXTERN NSString * const pushSingleItem;

/**
 *  获取试卷当前页 106
 */
UIKIT_EXTERN NSString * const getCurrentPage;

/**
 *  主观题 查看详情 107
 */
UIKIT_EXTERN NSString * const checkAnswerDetail;

/**
 *  每次向h5提交答案后都会弹 获得已提交的人数 110
 */
UIKIT_EXTERN NSString * const getCommitedStudentCount;

/**
 *  答对奖励 111
 */
UIKIT_EXTERN NSString * const rewardToRightAnswer;

/**
 *  页面加载完成 112
 */
UIKIT_EXTERN NSString * const finishLoad;

/**
 *  显示试卷统计页面 117
 */
UIKIT_EXTERN NSString * const showStatisticsPaper;

/**
 *  隐藏试卷统计页面 118
 */
UIKIT_EXTERN NSString * const hideStatisticsPaper;

/**
 *  判断试卷中有几道题 120
 */
UIKIT_EXTERN NSString * const getquestionCount;




