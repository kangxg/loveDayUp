//
//  EETCourseCell.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCourseCell.h"
#import <Masonry.h>

@implementation ETTCourseCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        [self setupSubview];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self layoutSubview];
}

/**
 *  初始化子控件,一次性设置在这里处理
 */
- (void)setupSubview {
    
    //cell背景
    self.backgroundImageView = [[UIImageView alloc]init];
    self.backgroundImageView.image = [UIImage imageNamed:@"course_bg"];
    self.backgroundImageView.layer.cornerRadius = YES;
    self.backgroundImageView.clipsToBounds = 25;
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.backgroundImageView];
    
    //标题
    _courseNameLabel = [[UILabel alloc]init];
    _courseNameLabel.textAlignment = NSTextAlignmentLeft;
    _courseNameLabel.font = [UIFont systemFontOfSize:20];
    _courseNameLabel.textColor = [UIColor colorWithRed:(55) / 255.0 green:(55) / 255.0 blue:(55) / 255.0 alpha:1.0];
    _courseNameLabel.numberOfLines = 1;
    [_backgroundImageView addSubview:_courseNameLabel];
    
    
    //课件
    _coursewareButton = [[ETTLCAButton alloc]init];
    //_coursewareButton.tag = 100000;
    _coursewareButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_coursewareButton setImage:[UIImage imageNamed:@"course_icon_course"] forState:UIControlStateNormal];
    [_coursewareButton setTitleColor:kF7_COLOR forState:UIControlStateHighlighted];
    [_coursewareButton setTitleColor:kF3_COLOR forState:UIControlStateNormal];
    [_coursewareButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.contentView addSubview:_coursewareButton];
    
    //试卷
    _testPaperButton = [[ETTLCAButton alloc]init];
    //_testPaperButton.tag = 100001;
    _testPaperButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_testPaperButton setImage:[UIImage imageNamed:@"course_icon_textpaper"] forState:UIControlStateNormal];
    [_testPaperButton setTitleColor:kF7_COLOR forState:UIControlStateHighlighted];
    [_testPaperButton setTitleColor:kF3_COLOR forState:UIControlStateNormal];
    [_testPaperButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.contentView addSubview:_testPaperButton];
    
    //课中笔记
    _classNoteButton = [[UIButton alloc]init];
    //_classNoteButton.tag = 100002;
    [_classNoteButton setImage:[UIImage imageNamed:@"course_icon_note_teacher"] forState:UIControlStateNormal];
    [_classNoteButton setTitleColor:kF7_COLOR forState:UIControlStateHighlighted];
    [_classNoteButton setTitleColor:kF3_COLOR forState:UIControlStateNormal];
    [_classNoteButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //[self.contentView addSubview:_classNoteButton];
    
}


/**
 *  布局子控件
 */
- (void)layoutSubview {
    
    //背景图片
    _backgroundImageView.frame = self.contentView.frame;
    
    //标题
    CGFloat titleX = self.contentView.width * (20.000 / 300);
    CGFloat titleY = self.contentView.height *(30.000 / 113);
    CGFloat titleWidth = self.contentView.width * (1 - (20.000 / 300) * 2);
    CGFloat titleHeight = (2.000 / 9) * self.contentView.height;
    _courseNameLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    
    //课件
    CGFloat coursewareX = 0;
    CGFloat coursewareY = (82.000 / 113) * self.contentView.height;;
    CGFloat coursewareWidth = self.contentView.width / 2;
    CGFloat coursewareHeight = (31.000 / 113) * self.contentView.height;
    
    _coursewareButton.imageRect = CGRectMake((44.000 / 150) * self.contentView.width / 2, (7.000 / 113) * self.contentView.height, (17.000 / 113) * self.contentView.height, (17.000 / 113) * self.contentView.height);
    _coursewareButton.titleRect = CGRectMake(CGRectGetMaxX(_coursewareButton.imageRect) + 5, (7.000 / 113) * self.contentView.height, (40.000 / 300) * self.contentView.width, (17.000 / 113) * self.contentView.height);
    _coursewareButton.frame = CGRectMake(coursewareX, coursewareY, coursewareWidth, coursewareHeight);
    
    //试卷
    CGFloat examinationPaperX = CGRectGetMaxX(_coursewareButton.frame);
    CGFloat examinationPaperY = coursewareY;
    CGFloat examinationPaperWidth = coursewareWidth;
    CGFloat examinationPaperHeight = coursewareHeight;
    _testPaperButton.imageRect = CGRectMake((44.000 / 150) * self.contentView.width / 2, (7.000 / 113) * self.contentView.height, (17.000 / 113) * self.contentView.height, (17.000 / 113) * self.contentView.height);
    _testPaperButton.titleRect = CGRectMake(CGRectGetMaxX(_coursewareButton.imageRect) + 5, (7.000 / 113) * self.contentView.height, (40.000 / 300) * self.contentView.width, (17.000 / 113) * self.contentView.height);
    _testPaperButton.frame = CGRectMake(examinationPaperX, examinationPaperY, examinationPaperWidth, examinationPaperHeight);
    
    //课中笔记
    CGFloat classNoteX = CGRectGetMaxX(_testPaperButton.frame);
    CGFloat classNoteY = coursewareY;
    CGFloat classNoteWidth = coursewareWidth;
    CGFloat classNoteHeight = coursewareHeight;
    _classNoteButton.frame = CGRectMake(classNoteX, classNoteY, classNoteWidth, classNoteHeight);
    _classNoteButton.imageEdgeInsets = UIEdgeInsetsMake([self countHeight:9.00], [self countWidth:25.00], [self countHeight:9.00], [self countWidth:55.00]);
    _classNoteButton.titleEdgeInsets = UIEdgeInsetsMake([self countHeight:9], -[self countWidth:15], [self countHeight:9], -[self countWidth:10]);
    
}

/**
 *  给子控件赋值
 *
 *  @param courseModel 课程模型
 */
- (void)setCourseModel:(CourseModel *)courseModel {
    
    _courseModel = courseModel;
    _courseNameLabel.text = _courseModel.courseName;
    [_coursewareButton setTitle:[NSString stringWithFormat:@"(%ld)",(long)_courseModel.coursewareNum] forState:UIControlStateNormal];
    [_testPaperButton setTitle:[NSString stringWithFormat:@"(%ld)",(long)_courseModel.testPaperNum] forState:UIControlStateNormal];
}

- (CGFloat)countWidth:(CGFloat)original {
    
    return original / self.contentView.width * self.contentView.width;
}

- (CGFloat)countHeight:(CGFloat)original {
    
    return original / self.contentView.height * self.contentView.height;
}

@end
