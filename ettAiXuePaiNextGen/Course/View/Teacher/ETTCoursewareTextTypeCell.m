//
//  ETTCoursewareTextTypeCell.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/30.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCoursewareTextTypeCell.h"

@implementation ETTCoursewareTextTypeCell

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
    _backgroundImageView = [[UIImageView alloc]init];
    _backgroundImageView.image = [UIImage imageNamed:@"courseware_cell_background"];
    _backgroundImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_backgroundImageView];
    
    //coursewareIconView 文本图标
    _coursewareIconView = [[UIImageView alloc]init];
    _coursewareIconView.userInteractionEnabled = YES;
    _coursewareIconView.image = [UIImage imageNamed:@"courseware_icon_word"];
    [_backgroundImageView addSubview:_coursewareIconView];
    
    //coursewareIconCoverView 文本下载过程中的蒙版
    _coursewareIconCoverView= [[UIView alloc]init];
    _coursewareIconCoverView.backgroundColor = [UIColor blackColor];
    _coursewareIconCoverView.hidden = YES;
    _coursewareIconCoverView.alpha = 0.5;
    [_coursewareIconView addSubview:_coursewareIconCoverView];
    
    //cancelButton 取消
    _cancelButton = [[ETTDownloadButton alloc]init];
    [_cancelButton setHidden:YES];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [_cancelButton setTitleColor:kC1_COLOR forState:UIControlStateHighlighted];
    [_backgroundImageView addSubview:_cancelButton];
    
    //visibleImageView 是否可见
    _visibleImageView  = [[UIImageView alloc]init];
    _visibleImageView.image = [UIImage imageNamed:@"courseware_invisible"];
    [_backgroundImageView addSubview:_visibleImageView];
    
    
    //coursewareName 标题
    _coursewareNameLabel = [[UILabel alloc]init];
    _coursewareNameLabel.text = @"的领养木雕的中鲜明的人物形象的的";
    _coursewareNameLabel.textColor = kF9_COLOR;
    _coursewareNameLabel.textAlignment = NSTextAlignmentLeft;
    _coursewareNameLabel.font = [UIFont systemFontOfSize:12];
    [_backgroundImageView addSubview:_coursewareNameLabel];
    
    
    //coursewareProgressView 下载进度显示
    _coursewareProgressView = [[DACircularProgressView alloc]init];
    _coursewareProgressView.userInteractionEnabled = YES;
    _coursewareProgressView.hidden = YES;
    _coursewareProgressView.thicknessRatio = 0.05;
    _coursewareProgressView.trackTintColor = [UIColor clearColor];
    _coursewareProgressView.progress = 0.00;
    [_backgroundImageView addSubview:_coursewareProgressView];
    
    //coursewareButton 课件按钮:文本类型点击下载,暂停,等待;音视频点击直接播放
    _coursewareButton = [[ETTDownloadButton alloc]init];
    _coursewareButton.hidden = YES;
    [_coursewareButton setImage:[UIImage imageNamed:@"courseware_icon_play"] forState:UIControlStateNormal];
    [_coursewareButton setBackgroundColor:[UIColor clearColor]];
    [_coursewareProgressView addSubview:_coursewareButton];
    
    ////////////////////////////////////////////////////////
    /*
     new      : revise
     time     : 2017.4.7  11:00
     modifier : 刘传安
     version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
     branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
     
     describe : 学生端课件下载更换成AFN
     introduce: 按钮回调
     */
    [_cancelButton addTarget:self action:@selector(cancelButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_coursewareButton addTarget:self action:@selector(coursewareButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    ////////////////////////////////////////////////////////
}

-(void)cancelButtonDidClick:(UIButton *)button
{
    
    if (self.EVDelegate &&  [self.EVDelegate respondsToSelector:@selector(pCellEventHandle:withEvenType:withInfo:)])
    {
        [self.EVDelegate pCellEventHandle:self withEvenType:ETTCELLEVENTYPEDOWNCANNEL withInfo:nil];
    }
}

-(void)coursewareButtonDidClick:(UIButton *)button
{
    if (self.EVDelegate &&  [self.EVDelegate respondsToSelector:@selector(pCellEventHandle:withEvenType:withInfo:)])
    {
        [self.EVDelegate pCellEventHandle:self withEvenType:ETTCELLEVENTYPEDOWNSTART withInfo:nil];
    }
}


/**
 *  布局子控件
 */
- (void)layoutSubview {
    
    [super layoutSubviews];
    _backgroundImageView.frame = self.contentView.frame;
    
    //iconView
    CGFloat coursewareIconViewX = 0;
    CGFloat coursewareIconViewY = 0;
    CGFloat coursewareIconViewWidth = _backgroundImageView.width;
    CGFloat coursewareIconViewHeight = (124.000 / 166) * _backgroundImageView.height;
    _coursewareIconView.frame = CGRectMake(coursewareIconViewX, coursewareIconViewY, coursewareIconViewWidth, coursewareIconViewHeight);
    
    //_coursewareIconCoverView
    _coursewareIconCoverView.frame = _coursewareIconView.frame;
    
    //cancelButton
    CGFloat cancelButtonWdith = (25.000 / 220) *_backgroundImageView.width;
    CGFloat cancelButtonHeight = (20.000 / 166) *_backgroundImageView.height;
    CGFloat cancelButtonX = (_backgroundImageView.width - cancelButtonWdith - ((16.000 / 220) *_backgroundImageView.width));
    CGFloat cancelButtonY = (16.000 / 220) *_backgroundImageView.height;
    _cancelButton.frame = CGRectMake(cancelButtonX, cancelButtonY, cancelButtonWdith, cancelButtonHeight);
    
    //visibleImageView
    CGFloat visibleImageViewWidth = (32.000 / 220) * _backgroundImageView.width;
    CGFloat visibleImageViewheight = visibleImageViewWidth;
    CGFloat visibleImageViewX = (220 - visibleImageViewWidth - ((10.000 / 220) * _backgroundImageView.width));
    CGFloat visibleImageViewY = (10.000 / 166) * _backgroundImageView.height;
    _visibleImageView.frame = CGRectMake(visibleImageViewX, visibleImageViewY, visibleImageViewWidth, visibleImageViewheight);
    
    //_coursewareNameLabel
    CGFloat coursewareNameLabelX = (12.000 / 220) * _backgroundImageView.width;
    CGFloat coursewareNameLabelY = ((124.000 + 12.000) / 166) * _backgroundImageView.height;
    CGFloat coursewareNameLabelWidth = (180.000 / 220) * _backgroundImageView.width;
    CGFloat coursewareNameLabelHeight = ((42.000 - 24.000) / 166) * _backgroundImageView.height;
    _coursewareNameLabel.frame = CGRectMake(coursewareNameLabelX, coursewareNameLabelY, coursewareNameLabelWidth, coursewareNameLabelHeight);
    
    //_coursewareProgressView
    CGFloat coursewareProgressViewWidth = (84.000 / 166) *_backgroundImageView.height;
    CGFloat coursewareProgressViewHeight = coursewareProgressViewWidth;
    CGFloat coursewareProgressViewX = ((220 - coursewareProgressViewWidth) / 220) * _backgroundImageView.width / 2;
    CGFloat coursewareProgressViewY = ((124.000 / 166) * _backgroundImageView.height - coursewareProgressViewWidth) / 2;
    _coursewareProgressView.frame = CGRectMake(coursewareProgressViewX, coursewareProgressViewY, coursewareProgressViewWidth, coursewareProgressViewHeight);;
    
    //_coursewareButton
    _coursewareButton.frame = _coursewareProgressView.bounds;
    
}

- (void)setCoursewareTextTypeModel:(CoursewareTextTypeModel *)coursewareTextTypeModel {
    
    _coursewareTextTypeModel = coursewareTextTypeModel;
    
    switch (_coursewareTextTypeModel.coursewareType) {
        case 1:
            _coursewareIconView.image = [UIImage imageNamed:@"courseware_icon_word"];
            break;
        case 2:
            _coursewareIconView.image = [UIImage imageNamed:@"courselist_bg_pdf"];
            break;
        case 6:
            _coursewareIconView.image = [UIImage imageNamed:@"courselist_bg_ppt"];
            break;
        case 7:
            _coursewareIconView.image = [UIImage imageNamed:@"courselist_bg_excel"];
            break;
        case 8:
            _coursewareIconView.image = [UIImage imageNamed:@"courselist_bg_txt"];
            break;
        default:
            break;
    }
    
    _coursewareNameLabel.text = [NSString stringWithFormat:@"%@",coursewareTextTypeModel.coursewareName];
    
    [self hideVisibleIcon];
    
    ////////////////////////////////////////////////////////
    /*
     new      : revise
     time     : 2017.4.7  11:00
     modifier : 刘传安
     version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
     branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
     
     describe : 学生端课件下载更换成AFN
     */
    //[self.coursewareButton setImage:[UIImage imageNamed:[self stateImageWithState:_coursewareTextTypeModel.downloadModel.state]] forState:UIControlStateNormal];
    self.cancelButton.hidden           = YES;
    self.coursewareProgressView.hidden = YES;
    self.coursewareButton.hidden       = YES;
    self.coursewareIconCoverView.hidden = YES;
    
    ////////////////////////////////////////////////////////
    
}

-(void)noticeDownLoadTaskState:(ETTDownLoadTaskState )state
{
    switch (state)
    {
        case ETTDOWNLOADTASKSTATENONE:
        {
            
            
            
        }
            break;
        case ETTDOWNLOADTASKSTATECREATEFAILE:
        {
            self.coursewareProgressView.hidden = YES;
            self.coursewareProgressView.progress = 0.0;
            self.coursewareIconCoverView.hidden = YES;
            self.cancelButton.hidden = YES;
            [self downloadFailed];
            
        }
            break;
        case ETTDOWNLOADTASKSTATEMORETHANMAX:
        {
            self.coursewareProgressView.hidden = YES;
            self.coursewareProgressView.progress = 0.0;
            self.coursewareIconCoverView.hidden = YES;
            self.cancelButton.hidden = YES;
            [self downloadFailed];
        }
            break;
        case ETTDOWNLOADTASKSTATENONETWORK:
        {
            self.coursewareProgressView.hidden = YES;
            self.coursewareProgressView.progress = 0.0;
            self.coursewareIconCoverView.hidden = YES;
            self.cancelButton.hidden = YES;
            [self downloadFailed];
            
        }
            break;
        case ETTDOWNLOADTASKSTATEFAILURE:
        {
            self.coursewareProgressView.hidden = YES;
            self.coursewareProgressView.progress = 0.0;
            self.coursewareIconCoverView.hidden = YES;
            self.cancelButton.hidden = YES;
            [self downloadFailed];
        }
            break;
            
            
        default:
            break;
    }
    
}

-(void)downloadFailed
{
    if (self.coursewareButton.downloadModel)
    {
        [self.coursewareButton.downloadModel setDownloadState:ETTDownloadStateNone];
    }
}

-(void)updateDownLoadView:(ETTDownloadModel *)model
{
    if (model == nil || model.downloadURL == nil ||![_coursewareTextTypeModel.coursewareUrl isEqualToString:model.downloadURL])
    {
        return;
    }
    
    switch (model.state)
    {
        case ETTDownloadStateNone:
        {
            
            
        }
            break;
        case ETTDownloadStateCancel:
        {
            [self displayCancelView];
        }
            break;
        case ETTDownloadStateReadying:
        {
            [self displayReadyingView];
            
        }
            break;
        case ETTDownloadStateRunning:
        {
            [self displayRuningView:model];
            
        }
            break;
        case ETTDownloadStateSuspended: {
            [self displaySuspendedView:model];
            
        }
            break;
        case ETTDownloadStateCompleted:
        {
            [self displayCompletedView];
        }
            break;
            
        case ETTDownloadStateFailed:
        {
            [self displayFailedView];
        }
            break;
            
        default:
            break;
    }
    
}
////////////////////////////////////////////////////////
/*
 new      : revise
 time     : 2017.4.7  11:00
 modifier : 刘传安
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
 describe : 学生端课件下载更换成AFN
 introduce: 显示准备好下载视图
 */
-(void)displayReadyingView
{
    
    [self.coursewareButton setImage:[UIImage imageNamed:[self stateImageWithState:_coursewareTextTypeModel.downloadModel.state]] forState:UIControlStateNormal];
    
}
////////////////////////////////////////////////////////
/*
 new      : revise
 time     : 2017.4.7  11:00
 modifier : 刘传安
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
 describe : 学生端课件下载更换成AFN
 introduce: 显示正在下载视图
 */
-(void)displayRuningView:(ETTDownloadModel *)model
{
    if (model)
    {
        [self.coursewareButton setImage:[UIImage imageNamed:[self stateImageWithState:model.state]] forState:UIControlStateNormal];
        self.coursewareProgressView.progress = model.progress.progress;;
        self.cancelButton.hidden = false;
        self.coursewareIconCoverView.hidden = false;
        self.coursewareProgressView.hidden = NO;
        self.visibleImageView.hidden = YES;
        
    }
    
}
////////////////////////////////////////////////////////
/*
 new      : revise
 time     : 2017.4.7  11:00
 modifier : 刘传安
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
 describe : 学生端课件下载更换成AFN
 introduce: 显示暂停下载视图
 */
-(void)displaySuspendedView:(ETTDownloadModel *)model

{
    if (model)
    {
        [self.coursewareButton setImage:[UIImage imageNamed:[self stateImageWithState:_coursewareTextTypeModel.downloadModel.state]] forState:UIControlStateNormal];
        self.coursewareProgressView.progress = model.progress.progress;;
        
        self.coursewareProgressView.hidden = NO;
    }
}
////////////////////////////////////////////////////////
/*
 new      : revise
 time     : 2017.4.7  11:00
 modifier : 刘传安
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
 describe : 学生端课件下载更换成AFN
 introduce: 显示完成下载视图
 */
-(void)displayCompletedView
{
    
    self.coursewareProgressView.hidden = YES;
    self.coursewareIconCoverView.hidden = YES;
    self.cancelButton.hidden = YES;
    [self hideVisibleIcon];
    
}

////////////////////////////////////////////////////////
/*
 new      : revise
 time     : 2017.4.7  11:00
 modifier : 刘传安
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
 describe : 学生端课件下载更换成AFN
 introduce: 显示下载失败视图
 */
-(void)displayFailedView
{
    [self displayCancelView];
    
}
////////////////////////////////////////////////////////
/*
 new      : revise
 time     : 2017.4.7  11:00
 modifier : 刘传安
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
 
 describe : 学生端课件下载更换成AFN
 introduce: 显示取消下载视图
 */
-(void)displayCancelView
{
    [self displayCompletedView];
    self.coursewareProgressView.progress = 0;
}

////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.7  11:00
 modifier : 刘传安
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／ReFix-AIXUEPAIOS-1168
 
 describe : 教师端课件下载更换成AFN
 introduce: 是否隐藏可见图标
 */
- (void)hideVisibleIcon
{
    if (_coursewareTextTypeModel.visible == 1) {
        _visibleImageView.hidden = YES;
    }else{
        _visibleImageView.hidden = NO;
    }
}
////////////////////////////////////////////////////////



- (NSString *)stateImageWithState:(ETTDownloadState)state {
    
    switch (state) {
        case ETTDownloadStateNone: {
            return nil;
            break;
        }
        case ETTDownloadStateReadying: {
            return @"courselist_icon_waiting";
            break;
        }
        case ETTDownloadStateRunning: {
            self.coursewareProgressView.hidden = NO;
            self.coursewareProgressView.progress = _coursewareTextTypeModel.progress;
            return @"courseware_icon_pause";
            break;
        }
        case ETTDownloadStateSuspended: {
            self.coursewareProgressView.hidden = NO;
            self.coursewareProgressView.progress = _coursewareTextTypeModel.progress;
            return @"courseware_icon_play";
            break;
        }
        case ETTDownloadStateCompleted: {
            _coursewareTextTypeModel.isShowDownloadButton = NO;
            return nil;
            break;
        }
        case ETTDownloadStateFailed: {
            self.coursewareProgressView.hidden = NO;
            self.coursewareProgressView.progress = _coursewareTextTypeModel.progress;
            return @"courseware_icon_play";
            break;
        }
        default:
            return nil;
            break;
    }
}



@end
