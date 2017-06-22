//
//  EETCourseCell.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
#import "ETTKit.h"
#import <Foundation/Foundation.h>
#import "CourseModel.h"
#import "ETTLCAButton.h"

@interface ETTCourseCell : ETTCollectionViewCell

/**
 *  cell背景
 */
@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  课程标题
 */
@property (strong, nonatomic) UILabel *courseNameLabel;


/**
 *  课件
 */
@property (strong, nonatomic) ETTLCAButton *coursewareButton;

/**
 *  试卷
 */
@property (strong, nonatomic) ETTLCAButton *testPaperButton;


/**
 *  课中笔记
 */
@property (strong, nonatomic) UIButton *classNoteButton;

/**
 *  课程模型
 */
@property (strong, nonatomic) CourseModel *courseModel;

@end
