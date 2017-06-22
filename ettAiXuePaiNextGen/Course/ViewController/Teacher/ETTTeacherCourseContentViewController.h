//
//  ETTCourseContentViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"
#import "ETTManageViewController.h"
@interface ETTTeacherCourseContentViewController : ETTManageViewController
/* 当前按钮索引*/
@property (assign, nonatomic) NSInteger currentIndex;

/* 导航栏标题*/
@property (copy, nonatomic  ) NSString  *navigationTitle;

/* 课程ID*/
@property (copy, nonatomic  ) NSString  *courseID;//课程id


@end
