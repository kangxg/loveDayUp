//
//  ETTStudentCoursewareTextTypeCell.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/10.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCollectionViewCell.h"
#import "DACircularProgressView.h"
#import "CoursewareTextTypeModel.h"
#import "ETTDownloadButton.h"
#import "EttDownloadHeader.h"

@interface ETTStudentCoursewareTextTypeCell : ETTCollectionViewCell

@property (strong, nonatomic) CoursewareTextTypeModel              *coursewareTextTypeModel;

@property (strong, nonatomic) UIImageView                          *backgroundImageView;//item的背景图片

@property (strong, nonatomic) UILabel                              *coursewareNameLabel;//课件名称

@property (strong, nonatomic) ETTDownloadButton                    *cancelButton;//取消按钮

/**
 文本类型上部的部分,多媒体类型不用
 */
@property (strong, nonatomic) UIImageView                          *coursewareIconView;//课件icon 只有文本类型的


/**
 如果是文本类型,按钮应该有三种状态:开始,暂停,等待
 如果是多媒体类型,按钮点击后直接跳转到播放
 */
@property (strong, nonatomic) ETTDownloadButton                    *coursewareButton;//课件按钮

/**
 只有文本类型有
 */
@property (strong, nonatomic) DACircularProgressView               *coursewareProgressView;//下载进度

@property (strong, nonatomic) UIView *coursewareIconCoverView;//文本下载过程中的遮盖

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169

 describe : 学生端课件下载更换成AFN
 introduce: 通知文件下载状态
 
 */
-(void)noticeDownLoadTaskState:(ETTDownLoadTaskState )state;


/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169

 describe : 学生端课件下载更换成AFN
 introduce: 更新视图
 
 */
-(void)updateDownLoadView:(ETTDownloadModel *)model;
///////////////////////////////////////////////////////
@end
