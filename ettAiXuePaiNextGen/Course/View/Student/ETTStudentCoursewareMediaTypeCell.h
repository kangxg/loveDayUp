//
//  ETTStudentCoursewareMediaTypeCell.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/10.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCollectionViewCell.h"
#import "CoursewareMediaTypeModel.h"

@interface ETTStudentCoursewareMediaTypeCell : ETTCollectionViewCell

@property (strong, nonatomic) UIImageView                          *backgroundImageView;//item的背景图片

@property (strong, nonatomic) UILabel                              *coursewareNameLabel;//课件名称


/**
 多媒体部分的背景图,文本类型不用
 */
@property (strong, nonatomic) UIImageView                          *coursewareImgView;//多媒体类背景图片

/**
 多媒体类型,按钮点击后直接跳转到播放
 */
@property (strong, nonatomic) UIButton                             *coursewareButton;//课件按钮

/**
 只有多媒体类型有  还没添加 记得添加上去
 */
@property (strong, nonatomic) UILabel                              *coursewareTimeDurationLabel;//播放时长

@property (strong, nonatomic) UIView                               *coursewareTimeDurationCoverView;//播放时长遮盖

@property (strong, nonatomic) UIImageView                          *coursewareImgCoverView;//黑色半透明遮盖

@property (strong, nonatomic) CoursewareMediaTypeModel *coursewareMediaTypeModel;//媒体类型课件

@end
