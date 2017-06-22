//
//  ETTVideoAudioViewController.m
//  ettAiXuePaiNextGen
//
//  Created by qitong on 16/10/2.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherVideoAudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AXPRedisManager.h"
#import "ETTJSonStringDictionaryTransformation.h"
#import "ETTSynchronizeStatus.h"
#import "ETTRedisBasisManager.h"
#import <UIImageView+WebCache.h>
#import "ETTBackToPageManager.h"
#import "ETTAudioPlayer.h"

@interface ETTTeacherVideoAudioViewController ()

@property (strong, nonatomic) AVPlayer                *player;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;

@property (copy, nonatomic  ) NSString                *message;

@property (strong, nonatomic) UIImageView             *imageView;

@end

@implementation ETTTeacherVideoAudioViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor                      = [UIColor whiteColor];

    NSURL *url                                     = [NSURL URLWithString:self.urlString];

    MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc]initWithContentURL:url];
    moviePlayerController.view.frame               = CGRectMake(0, 0, self.view.width, self.view.height - 64);

    [self.view addSubview:moviePlayerController.view];

    self.moviePlayerController                     = moviePlayerController;

    [self setupNavBar];
    
    if ([self.coursewareImg isEqualToString:@""] ||!self.coursewareImg) {//打开音频
        
        UIView *audioCoverView                     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44)];

        audioCoverView.backgroundColor             = [[UIColor blackColor]colorWithAlphaComponent:0.3];

        ETTAudioPlayer *player                     = [[ETTAudioPlayer alloc]initWithFrame:self.view.frame andURL:self.urlString];

        player.backgroundImageView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:player];
        
    } else {//打开视频
        
        [self setupSubview];
        
    }
    
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

    if ([self.coursewareImg isEqualToString:@""]) {
    UIImageView *imageV              = [[UIImageView alloc]init];
    imageV.frame                     = CGRectMake(0, 0, 200, 200);
    imageV.centerX                   = coverView.centerX;
    imageV.centerY                   = coverView.centerY - 64;
    imageV.image                     = [UIImage imageNamed:@"pop_icon_audio"];
        [coverView addSubview:imageV];
    }

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

    self.navigationItem.title                                   = self.navigationTitle;

    //左边返回按钮
    UIButton *backButton                                        = [UIButton new];
    backButton.frame                                            = CGRectMake(15, 0, 80, 44);

    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.imageEdgeInsets                                  = UIEdgeInsetsMake(5, 0, 5, 50);
    backButton.titleEdgeInsets                                  = UIEdgeInsetsMake(5, -30, 5, 0);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    backButton.titleLabel.font                                  = [UIFont systemFontOfSize:17.0];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem                       = [[UIBarButtonItem alloc]initWithCustomView:backButton];

    //同步打开按钮
    UIButton *synchronousOpenButton                             = [UIButton new];
    CGFloat synchronousOpenButtonWidth                          = 100;
    CGFloat synchronousOpenButtonHeight                         = 44;
    [synchronousOpenButton setTitle:@"同步打开" forState:UIControlStateNormal];
    synchronousOpenButton.frame                                 = CGRectMake(0, 0, synchronousOpenButtonWidth, synchronousOpenButtonHeight);
    [synchronousOpenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [synchronousOpenButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    synchronousOpenButton.titleLabel.font                       = [UIFont systemFontOfSize:17.0];
    synchronousOpenButton.titleEdgeInsets                       = UIEdgeInsetsMake(5, 20, 5, 0);
    [synchronousOpenButton addTarget:self action:@selector(pushButtonDidClick) forControlEvents:UIControlEventTouchUpInside];

    if ([ETTBackToPageManager sharedManager].isPushing == YES) {
    self.navigationItem.rightBarButtonItem                      = nil;
    } else {
    self.navigationItem.rightBarButtonItem                      = [[UIBarButtonItem alloc]initWithCustomView:synchronousOpenButton];
    }
    
}

//返回按钮的事件方法
- (void)backButtonDidClick {
    
    [self.moviePlayerController stop];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//同步打开按钮的点击
- (void)pushButtonDidClick {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    //第一步发送请求先更改课件的可见性
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"classroomId":userInformation.classroomId,
                             @"courseId":self.courseId,
                             @"coursewareId":self.coursewareID
                             };
    
    ETTLog(@"推送按钮被点击了 这个视频的urlString是  %@",self.urlString);
    
    ETTLog(@"coursewareID%@",self.coursewareID);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_HOST,setCoursewareVisible];
    
    [[ETTNetworkManager sharedInstance]POST:urlStr Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        if (error) {
            [self.view toast:@"网络有问题"];
        }
        else
        {
            [self synchronizationOpenVideo];
            NSNumber *result = responseDictionary[@"result"];
            
            if ([result isEqual:@1]) {
                ETTLog(@"更改课件可见性成功");
            }
        }
       
    }];

}
////////////////////////////////////////////////
/*
 康晓光 2.22 下午1.59 将上边注释内容 添加到 此函数中
 */
///////////////////////////////////////////////
-(void)synchronizationOpenVideo
{
    [self.view toast:@"已同步给学生"];
    
    //第二步redis推送到学生端
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    
    NSDictionary *userInfo = @{@"coursewareUrl":[NSString stringWithFormat:@"%@*%@*%@",self.urlString,self.coursewareID,self.navigationTitle],
                               @"coursewareImg":self.coursewareImg
                               };
    
    NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_03",
                            @"userInfo":userInfo
                            };
    
    NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *messageJSON              = [ETTRedisBasisManager getJSONWithDictionary:dict];

    NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    NSDictionary *theUserInfo = @{
                                  @"type":@"CO_03",
                                  @"theUserInfo":dict
                                  };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        if (!error) {
            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                if (!error) {
                    [self.view toast:@"同步成功"];
                    //NSLog(@"成功发送消息%@",dict);
                }else{
                    NSLog(@"发送消息%@失败！",dict);
                }
            }];
        }else {
            ETTLog(@"课件结束推送错误原因:%@",error);
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)stopAVPlay
{
    [self.moviePlayerController stop];
}

- (void)dealloc {
    [self.moviePlayerController stop];
    ETTLog(@"控制器销毁了");
}


@end
