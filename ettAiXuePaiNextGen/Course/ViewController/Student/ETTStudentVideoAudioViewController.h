//
//  ETTStudentVideoAudioViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ETTAudioPlayer.h"

@interface ETTStudentVideoAudioViewController : ETTViewController

@property (strong, nonatomic) ETTAudioPlayer          *player;

@property (copy, nonatomic  ) NSString                *navigationTitle;

@property (copy, nonatomic  ) NSString                *urlString;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;

@property (copy, nonatomic  ) NSString                *coursewareImg;

- (NSString *)getCurrentPlayUrlString;

-(void)stopPlay;

@end
