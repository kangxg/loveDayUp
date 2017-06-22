//
//  ETTStudentCourseContentViewController.h
//  ettAiXuePaiNextGen
/**
 学生课程容器里面有:课件,课中笔记,我的笔记类
 
 
 */
//  Created by Liu Chuanan on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"

@interface ETTStudentCourseContentViewController : ETTViewController

@property (assign, nonatomic) NSInteger   currentIndex;

@property (copy, nonatomic  ) NSString    *navigationTitle;

@property (copy, nonatomic  ) NSString    *courseID;

@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)addCoverView;


@end
