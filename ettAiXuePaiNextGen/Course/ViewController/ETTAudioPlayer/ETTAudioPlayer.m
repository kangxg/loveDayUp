//
//  ETTAudioPlayer.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTAudioPlayer.h"

@interface ETTAudioPlayer ()

@property (nonatomic, strong) CABasicAnimation *basicAnimation;//中间转圈动画
@property (nonatomic, strong) UILabel          *currentTimeLabel;//播放当前时间
@property (nonatomic, strong) UILabel          *totalTimeLabel;//播放总时间
@property (nonatomic, strong) UISlider         *slider;
@property (nonatomic, strong) AVPlayerItem     *playerItem;
@property (nonatomic, strong) AVPlayerLayer    *playerLayer;
@property (nonatomic, strong) id               timeObser;
@property (nonatomic, assign) BOOL isEnd;


@end

@implementation ETTAudioPlayer

- (id)initWithFrame:(CGRect)frame andURL:(NSString *)url{
    if (self = [super initWithFrame:frame]) {
        _audioUrl = [NSURL URLWithString:url];
        [self setupTop];
        [self setupBottom];
        [self setupSubview];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        self.isEnd = NO;
    }
    return self;
}
-(void)pause
{
    [self.playOrPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)stopPlay
{
    [self.rotationImageView.layer removeAnimationForKey:@"rotation"];
    [self.avPlayer pause];
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"player_play_default"] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

//播放完成的监听
- (void)playDidEnd:(NSNotification *)notify {
    
    ETTLog(@"播放完了xx");
    self.isEnd = YES;
    [self.rotationImageView.layer removeAnimationForKey:@"rotation"];
    [self.avPlayer seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        
    }];
    self.playOrPauseButton.selected = YES;

}

//设置子控件
- (void)setupSubview {
    [self initAVPlayer];
    
}

/**
 设置上部部分
 上部部分有:
 1.背景图
 2.一直在转的
 
 */
- (void)setupTop {
    
    UIImageView *backgroundImageView = [[UIImageView alloc]init];
    backgroundImageView.image        = [UIImage imageNamed:@""];
    backgroundImageView.frame        = CGRectMake(0, 0, self.width, self.height - 44 - 64);
    [self addSubview:backgroundImageView];
    self.backgroundImageView         = backgroundImageView;

    UIImageView *rotationImageView   = [[UIImageView alloc]init];
    rotationImageView.image          = [UIImage imageNamed:@"pop_icon_audio"];
    rotationImageView.frame          = CGRectMake(0, 0, 200, 200);
    rotationImageView.centerX        = self.centerX;
    rotationImageView.centerY        = self.centerY - 64;
    [self addSubview:rotationImageView];
    self.rotationImageView           = rotationImageView;

    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue         = [NSNumber numberWithFloat:0.0];
    basicAnimation.toValue           = [NSNumber numberWithFloat:M_PI * 2.0];
    basicAnimation.repeatCount       = MAXFLOAT;
    basicAnimation.duration          = 5.0;
    basicAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    self.basicAnimation              = basicAnimation;
    
}

//设置下部部分
- (void)setupBottom {
    
    //底部容器
    UIView *bottomView                = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 44 - 64, self.width, 44)];
    //bottomView.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:0.5];
    [self addSubview:bottomView];

    //播放按钮
    UIButton *playOrPauseButton       = [[UIButton alloc]init];
    [playOrPauseButton setImage:[UIImage imageNamed:@"player_pause_default"] forState:UIControlStateNormal];
    [playOrPauseButton setImage:[UIImage imageNamed:@"player_play_default"] forState:UIControlStateSelected];
    playOrPauseButton.imageEdgeInsets = UIEdgeInsetsMake(9, 9, 9, 9);
    playOrPauseButton.selected        = YES;
    playOrPauseButton.frame           = CGRectMake(30, 0, 44, 44);
    [playOrPauseButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:playOrPauseButton];
    self.playOrPauseButton            = playOrPauseButton;


    //播放当前时间
    UILabel *currentTimeLabel         = [[UILabel alloc]init];
    currentTimeLabel.textColor        = [UIColor whiteColor];
    currentTimeLabel.text             = @"0:0";
    currentTimeLabel.frame            = CGRectMake(CGRectGetMaxX(playOrPauseButton.frame) + 10, 5, 60, 34);
    currentTimeLabel.textAlignment    = NSTextAlignmentRight;
    [bottomView addSubview:currentTimeLabel];
    self.currentTimeLabel             = currentTimeLabel;

    //进度条
    CGFloat sliderX                   = CGRectGetMaxX(currentTimeLabel.frame) + 10;
    UISlider  *slider                 = [[UISlider alloc]initWithFrame:CGRectMake(sliderX, 7, self.width - sliderX - 10 - 60, 30)];
    [slider addTarget:self action:@selector(dragSliderAction:) forControlEvents:UIControlEventValueChanged];
    [bottomView addSubview:slider];
    self.slider                       = slider;

    //播放当前时间
    UILabel *totalTimeLabel           = [[UILabel alloc]init];
    totalTimeLabel.textColor          = [UIColor whiteColor];
    totalTimeLabel.text               = @"0:0";
    totalTimeLabel.frame              = CGRectMake(CGRectGetMaxX(slider.frame) + 10, 5, 60, 34);
    totalTimeLabel.textAlignment      = NSTextAlignmentLeft;
    [bottomView addSubview:totalTimeLabel];
    self.totalTimeLabel               = totalTimeLabel;
    
}

- (void)dragSliderAction:(UISlider *)slider {
    
    ETTLog(@"拖动了slider");
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval duration = self.slider.value * CMTimeGetSeconds(self.avPlayer.currentItem.duration);
        CMTime seekTime = CMTimeMake(duration, 1);
        [self.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
            
        }];
    }
}

- (void)playOrPauseAction:(UIButton *)button {
    
    button.selected = !button.selected;
    if (button.selected) {//暂停
        ETTLog(@"点击暂停了");
        [self.rotationImageView.layer removeAnimationForKey:@"rotation"];
        [self.avPlayer pause];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"player_play_default"] forState:UIControlStateSelected];
        
    } else {//播放
        ETTLog(@"点击播放了");
        if (self.isEnd == YES) {
            self.currentTimeLabel.text = @"0:0";
            self.isEnd = NO;
        } 
        [self.rotationImageView.layer addAnimation:self.basicAnimation forKey:@"rotation"];
        [self.avPlayer play];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"player_pause_default"] forState:UIControlStateNormal];
        
    }
    
}


/**
 初始化AVPlayer相关
 */
- (void)initAVPlayer {
    if (!self.avPlayer) {
        _playerItem        = [AVPlayerItem playerItemWithURL:self.audioUrl];
        self.avPlayer      = [AVPlayer playerWithPlayerItem:_playerItem];
        _playerLayer       = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
        _playerLayer.frame = CGRectMake(0, 0, 1, 1);
        [self.layer addSublayer:_playerLayer];
        [self addAudioKVOWithPlayerItem:_playerItem];
        [self addAudioTimerObserverWithObserver:_timeObser];
        
        
    }
}

- (void)addAudioKVOWithPlayerItem:(AVPlayerItem *)playerItem {
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addAudioTimerObserverWithObserver:(id)observer {
    
    __weak typeof(self)weakSelf = self;
    observer = [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //获得播放当前时间
        NSTimeInterval current = CMTimeGetSeconds(time);
        
        //获得总时间
        NSTimeInterval total = CMTimeGetSeconds(weakSelf.avPlayer.currentItem.duration);
        
        weakSelf.slider.value = current / total;
        
        NSString *currentTime = [NSString stringWithFormat:@"%@",[weakSelf formatPlayTime:current]];
        
        NSString *totalTime = [NSString stringWithFormat:@"%@",[weakSelf formatPlayTime:total]];
        
        weakSelf.currentTimeLabel.text = currentTime;
        weakSelf.totalTimeLabel.text = totalTime;
        
    }];
    
}

/**
 将时间转换成00:00:00格式
 
 @param NSString <#NSString description#>
 @return <#return value description#>
 */
- (NSString *)formatPlayTime:(NSTimeInterval)duration {
    int minute = 0,hour = 0, second = duration;
    minute = (second % 3600) / 60;
    hour = second / 3600;
    second = second % 60;
    if (minute < 60) {
        return [NSString stringWithFormat:@"%2d:%2d",minute,second];
    }else {
        return [NSString stringWithFormat:@"%2d:%2d:%2d",hour,minute,second];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerStatusReadyToPlay) {
            ETTLog(@"playItem is ready");
            [self.avPlayer pause];
        }
    }
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.avPlayer removeTimeObserver:_timeObser];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
