//
//  ETTStudentCourseCell.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/10.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTKit.h"
#import <Foundation/Foundation.h>
#import "CourseModel.h"
#import "ETTLCAButton.h"

@interface ETTStudentCourseCell : ETTCollectionViewCell

/**
 *  cell背景
 */
@property (strong, nonatomic) UIImageView  *backgroundImageView;

/**
 *  课程标题
 */
@property (strong, nonatomic) UILabel      *courseNameLabel;


/**
 *  课件
 */
@property (strong, nonatomic) ETTLCAButton *coursewareButton;

/**
 *  我的笔记
 */
@property (strong, nonatomic) UIButton     *myNoteButton;


/**
 *  课中笔记
 */
@property (strong, nonatomic) UIButton     *classNoteButton;

/**
 *  课程模型
 */
@property (strong, nonatomic) CourseModel *courseModel;

@end
