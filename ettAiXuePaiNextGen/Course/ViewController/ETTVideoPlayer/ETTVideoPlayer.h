//
//  SSVideoPlayer.h
//  SSVideoPlayer
//
//  Created by Mrss on 16/1/9.
//  Copyright © 2016年 expai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@class ETTVideoPlayer;

@protocol ETTVideoPlayerDelegate <NSObject>

@optional

- (void)videoPlayerDidReadyPlay:(ETTVideoPlayer *)videoPlayer;

- (void)videoPlayerDidBeginPlay:(ETTVideoPlayer *)videoPlayer;

- (void)videoPlayerDidEndPlay:(ETTVideoPlayer *)videoPlayer;

- (void)videoPlayerDidSwitchPlay:(ETTVideoPlayer *)videoPlayer;

- (void)videoPlayerDidFailedPlay:(ETTVideoPlayer *)videoPlayer;

@end

typedef NS_ENUM(NSInteger,ETTVideoPlayerPlayState) {
    ETTVideoPlayerPlayStatePlaying,
    ETTVideoPlayerPlayStateStop,
};

typedef NS_ENUM(NSInteger,ETTVideoPlayerDisplayMode) {
    ETTVideoPlayerDisplayModeAspectFit,
    ETTVideoPlayerDisplayModeAspectFill
};

@interface ETTVideoPlayer : NSObject

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,  weak) id <ETTVideoPlayerDelegate> delegate;

@property (nonatomic,  copy) void (^progressBlock      ) (float progress);

@property (nonatomic,  copy) void (^bufferProgressBlock) (float progress);

@property (nonatomic,assign,readonly) ETTVideoPlayerPlayState   playState;

@property (nonatomic,  copy         ) NSString                  *path;//Support both local and remote resource.

@property (nonatomic,assign         ) BOOL                      pausePlayWhenMove;//Default YES.

@property (nonatomic,assign,readonly) float                     duration;

@property (nonatomic,assign         ) ETTVideoPlayerDisplayMode displayMode;

@property (nonatomic, copy) void (^currentTimeBlock) (float currentTime);

@property (nonatomic, copy) void (^totalTimeBlock  ) (float totalTime  );

- (void)playInContainer:(UIView *)container ;

- (void)play;

- (void)playAtTheBeginning;

- (void)moveTo:(float)to; //0 to 1.

- (void)pause;


@end
