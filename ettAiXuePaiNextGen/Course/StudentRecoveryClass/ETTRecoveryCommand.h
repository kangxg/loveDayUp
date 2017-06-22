//
//  ETTRecoveryCommand.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 2017/4/13.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

/**
    学生端课堂恢复命令常量
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

////////////////////////PDF课件命令////////////////////////

/** pdf命令 */
UIKIT_EXTERN NSString * const kPDFCoursewareCommand;

/** 推送pdf课件 */
UIKIT_EXTERN NSString * const kPushPDF;

/** 上下滚动协同浏览 */
UIKIT_EXTERN NSString * const kSynchronousBrowsingUpDown;

/** 点击缩略图协同浏览 */
UIKIT_EXTERN NSString * const kSynchronousBrowsingThumb;

/** pdf课件结束推送 */
UIKIT_EXTERN NSString * const kEndPushPDF;


/////////////////////////////////////////////////////////




////////////////////////试卷课件命令////////////////////////

/** 试卷命令 */
UIKIT_EXTERN NSString * const kTestPaperCommand;

/** 推送试卷 */
UIKIT_EXTERN NSString * const kPushTestPaper;

/** 试卷结束作答 */
UIKIT_EXTERN NSString * const kEndAnswer;

/** 试卷翻页协同浏览 */
UIKIT_EXTERN NSString * const kSynchronousBrowsingTestPaper;

/** 答对奖励 */
UIKIT_EXTERN NSString * const kRewardRightAnswer;

/** 主观题批阅 */
UIKIT_EXTERN NSString * const kSubjectiveItemMarking;

/** 主观题批阅结束 */
UIKIT_EXTERN NSString * const kEndSubjectiveItemMarking;


/////////////////////////////////////////////////////////
