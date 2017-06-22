//
//  ETTStudentVideoAudioViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentVideoAudioViewController.h"
#import "ETTScenePorter.h"
#import "ETTRedisManagerConst.h"
#import "ETTSynchronizeStatus.h"
#import <UIImageView+WebCache.h>
#import "ETTCoursewarePresentViewControllerManager.h"


@interface ETTStudentVideoAudioViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ETTStudentVideoAudioViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor                      = [UIColor whiteColor];

    NSURL *url                                     = [NSURL URLWithString:self.urlString];

    MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc]initWithContentURL:url];
    moviePlayerController.view.frame               = CGRectMake(0, 0, self.view.width, self.view.height - 64);


    [self.view addSubview:moviePlayerController.view];

    self.moviePlayerController = moviePlayerController;
    
    [self setupNavBar];
    if ([self.coursewareImg isEqualToString:@""] ||!self.coursewareImg) {//打开音频
        
        UIView *audioCoverView                     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44)];

        audioCoverView.backgroundColor             = [[UIColor blackColor]colorWithAlphaComponent:0.3];



        ETTAudioPlayer *player                     = [[ETTAudioPlayer alloc]initWithFrame:self.view.frame andURL:self.urlString];

        player.backgroundImageView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:player];

        self.player = player;
        
    } else {//打开视频
        
        [self setupSubview];
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pauseVideo:) name:kANSWER_PAUSER_VIDEO object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pauseVideo:) name:kLOCK_SCREEN_PAUSE_VIDEO object:nil];
    
    // 注册 老师白板推送 消息  康晓光  2.21 下午 16:14 添加  //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reviceWBPushingNotify:) name:ETTWBPushingNotification  object:nil];
    ///////////////////////////////////////////////////////////////
}
-(void)reviceWBPushingNotify:(NSNotification *)notify
{
    if (self.player)
    {
        [self.player.avPlayer pause];
    }
    if (self.moviePlayerController)
    {
        [self.moviePlayerController pause];
    }
}
//锁屏/抢答暂停视频
- (void)pauseVideo:(NSNotification *)notify {
    
    [self.player.avPlayer pause];
    [self.player.rotationImageView.layer removeAnimationForKey:@"rotation"];
    [self.player.playOrPauseButton setSelected:YES];
    [self.moviePlayerController pause];
}

//设置蒙版
- (void)setupSubview {
    
    UIImageView *imageView           = [[UIImageView alloc]init];
    imageView.frame                  = self.view.frame;
    imageView.userInteractionEnabled = YES;

    [imageView sd_setImageWithURL:[NSURL URLWithString:self.coursewareImg] placeholderImage:[UIImage imageNamed:@""]];
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:imageView];
    self.imageView                   = imageView;

    UITapGestureRecognizer *tap      = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];

    UIView *coverView                = [[UIView alloc]initWithFrame:imageView.frame];
    coverView.backgroundColor        = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [imageView addSubview:coverView];
    coverView.userInteractionEnabled = YES;
    [coverView addGestureRecognizer:tap];

    UIButton *playButton             = [UIButton new];
    playButton.frame                 = CGRectMake(0, 0, 120, 120);
    playButton.centerX               = coverView.centerX;
    playButton.centerY               = coverView.centerY - 64;
    [playButton setImage:[UIImage imageNamed:@"courseware_icon_play"] forState:UIControlStateNormal];
    [playButton addGestureRecognizer:tap];
    [coverView addSubview:playButton];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [self.moviePlayerController prepareToPlay];
    [self.moviePlayerController play];
    [UIView animateWithDuration:1.5 animations:^{
        [self.imageView removeFromSuperview];
    }];
}


//设置导航栏
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    self.navigationItem.title = self.navigationTitle;
    
    //左边返回按钮
    UIButton *backButton       = [UIButton new];
    backButton.frame           = CGRectMake(15, 0, 80, 44);

    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 50);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, 0);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
}

- (NSString *)getCurrentPlayUrlString
{
    
    return self.urlString;
}

//返回按钮的事件方法
- (void)backButtonDidClick {
    
    [self.moviePlayerController stop];
    
    self.urlString = nil;
    
    [ETTSynchronizeStatus sharedManager].lastUrlString = nil;
    
    //返回的时候取消订阅
    [[NSNotificationCenter defaultCenter]postNotificationName:kREDIS_UNSUBCRIBTION_CLASSROOM object:[NSString stringWithFormat:@"pcl_channel_tch_in_class:%@",[AXPUserInformation sharedInformation].classroomId] userInfo:nil];
    [[ETTScenePorter shareScenePorter]removeGurad:self.EVGuardModel];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)stopPlay
{
    if (self.moviePlayerController) {
        [self.moviePlayerController stop];
    }
    if (self.player) {
//        [self.player pause];
        [self.player stopPlay];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    ETTLog(@"控制器销毁了");
    [self.moviePlayerController stop];
//    [self.player pause];
    [self.player stopPlay];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kLOCK_SCREEN_PAUSE_VIDEO object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kANSWER_PAUSER_VIDEO object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
