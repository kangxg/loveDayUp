//
//  ETTStudentRecoveryClass.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 2017/4/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//
/*
    学生恢复课堂类,已经基本事件的恢复功能
    1.pdf课件恢复
    2.试卷的恢复
*/

#import <Foundation/Foundation.h>

@interface ETTStudentRecoveryClass : NSObject

- (void)getLastCourseDataWithDictionary:(NSDictionary *)dictionary;

@end
