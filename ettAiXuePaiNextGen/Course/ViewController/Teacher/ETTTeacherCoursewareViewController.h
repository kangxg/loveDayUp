//
//  ETTCoursewareViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

/**
 Description 老师课件

 */
#import "ETTViewController.h"

@interface ETTTeacherCoursewareViewController : ETTViewController

@property (weak, nonatomic) UIViewController *delegate;

@property (copy, nonatomic) NSString         *jid;
@property (copy, nonatomic) NSString         *classroomId;
@property (copy, nonatomic) NSString         *courseId;

@end
