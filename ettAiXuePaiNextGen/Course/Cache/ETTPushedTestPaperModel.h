//
//  ETTPushedTestPaperModel.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 17/2/14.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

/**
 判断推送的是单道题还是推送的试卷
 如果有itemId,说明是推得是单道题
 
 **/
#import <Foundation/Foundation.h>

@interface ETTPushedTestPaperModel : NSObject

/** 推得试题id */
@property (nonatomic, copy) NSString *itemId;

/** 推得试卷id */
@property (nonatomic, copy) NSString *testPaperId;

/** 每次推送试卷or试题的id */
@property (nonatomic, copy) NSString *pushedId;

/** 上次推送试卷的参数 这个由NSDictionary转成的JSON 字符串 */
//@property (nonatomic, copy) NSString *pushedTestPaperParams;

/** 推送试卷的UrlString */
@property (nonatomic, copy) NSString *testPaperUrlString;

@end
