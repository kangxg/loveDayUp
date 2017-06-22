//
//  ETTAudioPlayer.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"
#import <AVFoundation/AVFoundation.h>

@interface ETTAudioPlayer : ETTView

@property (nonatomic, strong) UIButton    *playOrPauseButton;

@property (nonatomic, strong) AVPlayer    *avPlayer;

/** 音频url */
@property (nonatomic, strong) NSURL       *audioUrl;

/** 背景图 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/** 转圈图 */
@property (nonatomic, strong) UIImageView *rotationImageView;


- (instancetype)initWithFrame:(CGRect)frame andURL:(NSString *)url;

-(void)pause;

-(void)stopPlay;

@end
