//
//  ETTRecoveryCommand.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 2017/4/13.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTRecoveryCommand.h"

////////////////////////PDF课件命令////////////////////////

/** pdf命令 */
NSString * const kPDFCoursewareCommand = @"CO_02";

/** 推送pdf课件 */
NSString * const kPushPDF = @"CO_02_state1";

/** 上下滚动协同浏览 */
NSString * const kSynchronousBrowsingUpDown = @"CO_02_state2";

/** 点击缩略图协同浏览 */
NSString * const kSynchronousBrowsingThumb = @"CO_02_state3";

/** pdf课件结束推送 */
NSString * const kEndPushPDF = @"CO_02_state5";


/////////////////////////////////////////////////////////


////////////////////////试卷课件命令////////////////////////

/** 试卷命令 */
NSString * const kTestPaperCommand = @"CO_04";

/** 推送试卷 */
NSString * const kPushTestPaper = @"CO_04_state1";

/** 试卷结束作答 */
NSString * const kEndAnswer = @"CO_04_state2";

/** 试卷翻页协同浏览 */
NSString * const kSynchronousBrowsingTestPaper = @"CO_04_state3";

/** 答对奖励 */
NSString * const kRewardRightAnswer = @"CO_04_state4";

/** 主观题批阅 */
NSString * const kSubjectiveItemMarking = @"26";

/** 主观题批阅结束 */
NSString * const kEndSubjectiveItemMarking = @"27";


/////////////////////////////////////////////////////////
