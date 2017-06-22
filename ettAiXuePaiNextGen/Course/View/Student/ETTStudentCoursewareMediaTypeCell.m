//
//  ETTStudentCoursewareMediaTypeCell.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/10.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentCoursewareMediaTypeCell.h"
#import <UIImageView+WebCache.h>

@implementation ETTStudentCoursewareMediaTypeCell
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
    
    //背景图片
    _backgroundImageView                                = [[UIImageView alloc]init];
    _backgroundImageView.image                          = [UIImage imageNamed:@"courseware_cell_background"];
    _backgroundImageView.userInteractionEnabled         = YES;
    [self.contentView addSubview:_backgroundImageView];

    //coursewareImgView 音频背景图片
    _coursewareImgView                                  = [[UIImageView alloc]init];
    _coursewareImgView.userInteractionEnabled           = YES;
    _coursewareImgView.image                            = [UIImage imageNamed:@"courselist_bg_excel"];
    [_backgroundImageView addSubview:_coursewareImgView];

    //coursewareImgCoverView 音频蒙版
    _coursewareImgCoverView                             = [[UIImageView alloc]init];
    _coursewareImgCoverView.image                       = [UIImage imageNamed:@"course_bg_video"];
    _coursewareImgCoverView.userInteractionEnabled      = YES;
    [_coursewareImgView addSubview:_coursewareImgCoverView];

    //coursewareName 标题
    _coursewareNameLabel                                = [[UILabel alloc]init];
    _coursewareNameLabel.text                           = @"的领养木雕的中鲜明的人物形象的的";
    _coursewareNameLabel.textColor                      = kF9_COLOR;
    _coursewareNameLabel.textAlignment                  = NSTextAlignmentLeft;
    _coursewareNameLabel.font                           = [UIFont systemFontOfSize:12.0];
    [_backgroundImageView addSubview:_coursewareNameLabel];

    //coursewareButton 音视频点击直接播放
    _coursewareButton                                   = [[UIButton alloc]init];
    [_coursewareButton setImage:[UIImage imageNamed:@"courseware_icon_play"] forState:UIControlStateNormal];
    [_coursewareButton addTarget:self action:@selector(playButton) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImageView addSubview:_coursewareButton];

    //播放时长蒙版
    _coursewareTimeDurationCoverView                    = [[UIView alloc]init];
    _coursewareTimeDurationCoverView.backgroundColor    = [UIColor blackColor];
    _coursewareTimeDurationCoverView.alpha              = 0.3;
    _coursewareTimeDurationCoverView.layer.cornerRadius = 5;
    _coursewareTimeDurationCoverView.clipsToBounds      = YES;
    [_coursewareImgView addSubview:_coursewareTimeDurationCoverView];

    //播放时长
    _coursewareTimeDurationLabel                        = [[UILabel alloc]init];
    _coursewareTimeDurationLabel.text                   = @"12:40";
    _coursewareTimeDurationLabel.textColor              = [UIColor whiteColor];
    _coursewareTimeDurationLabel.font                   = [UIFont systemFontOfSize:12.0];
    _coursewareTimeDurationLabel.textAlignment          = NSTextAlignmentCenter;
    [_backgroundImageView addSubview:_coursewareTimeDurationLabel];
    
}


/**
 *  布局子控件
 */
- (void)layoutSubview {
    
    
    
    _backgroundImageView.frame = self.contentView.frame;
    
    //coursewareImgView
    CGFloat coursewareImgViewX = 0;
    CGFloat coursewareImgViewY = 0;
    CGFloat coursewareImgViewWidth = _backgroundImageView.width;
    CGFloat coursewareImgViewHeight = (124.000 / 166) * _backgroundImageView.height;
    _coursewareImgView.frame = CGRectMake(coursewareImgViewX, coursewareImgViewY, coursewareImgViewWidth, coursewareImgViewHeight);
    
    //coursewareImgCoverView
    _coursewareImgCoverView.frame = _coursewareImgView.frame;
    
    //_coursewareNameLabel
    CGFloat coursewareNameLabelX = (12.000 / 220) * _backgroundImageView.width;
    CGFloat coursewareNameLabelY = ((124.000 + 12.000) / 166) * _backgroundImageView.height;
    CGFloat coursewareNameLabelWidth = (180.000 / 220) * _backgroundImageView.width;
    CGFloat coursewareNameLabelHeight = ((42.000 - 24.000) / 166) * _backgroundImageView.height;
    _coursewareNameLabel.frame = CGRectMake(coursewareNameLabelX, coursewareNameLabelY, coursewareNameLabelWidth, coursewareNameLabelHeight);
    
    //_coursewareButton
    CGFloat coursewareButtonWidth = (64.000 / 166) *_backgroundImageView.height;
    CGFloat coursewareButtonHeight = coursewareButtonWidth;
    CGFloat coursewareButtonX = ((220 - coursewareButtonWidth) / 220) * _backgroundImageView.width / 2;
    CGFloat coursewareButtonY = ((124.000 / 166) * _backgroundImageView.height - coursewareButtonWidth) / 2;
    _coursewareButton.frame = CGRectMake(coursewareButtonX, coursewareButtonY, coursewareButtonWidth, coursewareButtonHeight);
    
    //播放时长蒙版
    CGFloat coursewareTimeDurationCoverViewWidth = (45.000 / 220) * _backgroundImageView.width;
    CGFloat coursewareTimeDurationCoverViewHeight = (20.000 / 166) * _backgroundImageView.height;
    CGFloat coursewareTimeDurationCoverViewX = (_backgroundImageView.width - coursewareTimeDurationCoverViewWidth - (8.000 / 220) * _backgroundImageView.width);
    CGFloat coursewareTimeDurationCoverViewY = (_coursewareImgView.height - (28.000 / 124) * _coursewareImgView.height);
    _coursewareTimeDurationCoverView.frame = CGRectMake(coursewareTimeDurationCoverViewX, coursewareTimeDurationCoverViewY, coursewareTimeDurationCoverViewWidth, coursewareTimeDurationCoverViewHeight);
    
    //播放时长
    CGFloat coursewareTimeDurationLabelWidth = (45.000 / 220) * _backgroundImageView.width;
    CGFloat coursewareTimeDurationLabelHeight = (20.000 / 166) * _backgroundImageView.height;
    CGFloat coursewareTimeDurationLabelX = (_backgroundImageView.width - coursewareTimeDurationCoverViewWidth - (8.000 / 220) * _backgroundImageView.width);
    CGFloat coursewareTimeDurationLabelY = (_backgroundImageView.height - (70.000 / 166) * _backgroundImageView.height);
    _coursewareTimeDurationLabel.frame = CGRectMake(coursewareTimeDurationLabelX, coursewareTimeDurationLabelY, coursewareTimeDurationLabelWidth, coursewareTimeDurationLabelHeight);
}

- (void)setCoursewareMediaTypeModel:(CoursewareMediaTypeModel *)coursewareMediaTypeModel {
    
    _coursewareMediaTypeModel = coursewareMediaTypeModel;
    switch (_coursewareMediaTypeModel.coursewareType) {//图片类型
        case 3:
            _coursewareImgView.image = [UIImage imageNamed:@"courselist_bg_jpg"];
            _coursewareImgCoverView.hidden = YES;
            _coursewareTimeDurationCoverView.hidden = YES;
            _coursewareTimeDurationLabel.hidden = YES;
            _coursewareButton.hidden = YES;
            break;
        case 4: //视频类型
            
            [_coursewareImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_coursewareMediaTypeModel.coursewareImg]] placeholderImage:[UIImage imageNamed:@"courselist_bg_vedio"]];
            
            _coursewareButton.hidden = NO;
            
            break;
        case 5: //音频类型
            _coursewareImgView.image = [UIImage imageNamed:@"courselist_bg_audio"];
            
            _coursewareButton.hidden = NO;
        default:
            break;
    }
    _coursewareNameLabel.text = [NSString stringWithFormat:@"%@",_coursewareMediaTypeModel.coursewareName];
    
    _coursewareTimeDurationLabel.text = [NSString stringWithFormat:@"%@",_coursewareMediaTypeModel.duration];
    
    
    if (_coursewareMediaTypeModel.visible == 2) {//课件的可见性
    } else {
    }
    
    if (_coursewareMediaTypeModel.uploadSource == 0) {//0表示不是录课视频
        _coursewareTimeDurationCoverView.hidden = YES;
        _coursewareTimeDurationLabel.hidden = YES;
    } else {
        _coursewareTimeDurationCoverView.hidden = NO;
        _coursewareTimeDurationLabel.hidden = NO;
    }
}

- (void)playButton {
    
    NSLog(@"dsjfjsajkf");
    
}


@end
