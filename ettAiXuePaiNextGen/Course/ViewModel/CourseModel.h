//
//  CourseModel.h
//  ettAiXuePaiNextGen
/*
 1.课程列表模型
 
 
 */
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject

//课id
@property (copy, nonatomic  ) NSString  *courseId;

//课程名称
@property (copy, nonatomic  ) NSString  *courseName;

//试卷数量
@property (assign, nonatomic) NSInteger coursewareNum;

//课件数量
@property (assign, nonatomic) NSInteger testPaperNum;

//课中笔记数量
@property (assign, nonatomic) NSInteger classNoteNum;


@end
