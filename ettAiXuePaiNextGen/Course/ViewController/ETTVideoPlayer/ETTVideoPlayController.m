//
//  SSVideoPlayController.m
//  SSVideoPlayer
//
//  Created by Mrss on 16/1/22.
//  Copyright © 2016年 expai. All rights reserved.
//

#import "ETTVideoPlayController.h"
#import "ETTVideoPlaySlider.h"
#import "ETTVideoPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Frame.h"

@implementation ETTVideoModel

- (instancetype)initWithName:(NSString *)name path:(NSString *)path {
    self = [super init];
    if (self) {
        _name = [name copy];
        _path = [path copy];
    }
    return self;
}

@end

@interface ETTVideoPlayController () <UITableViewDataSource,UITableViewDelegate,ETTVideoPlayerDelegate>

@property (nonatomic,strong) ETTVideoPlayer     *player;
@property (nonatomic,strong) ETTVideoPlaySlider *slider;
@property (nonatomic,strong) UIButton           *playButton;
@property (nonatomic,strong) UIButton           *previousItem;
@property (nonatomic,strong) UIButton *nextItem;

@property (nonatomic,strong) UISlider *volume;

@property (nonatomic,strong) UIView *navigationView;
@property (nonatomic,strong) UIView *bottomBar;
@property (nonatomic,strong) UIView *playContainer;


@property (nonatomic,strong) UITableView             *videoList;
@property (nonatomic,strong) NSMutableArray          *videoPaths;
@property (nonatomic,assign) BOOL                    hidden;
@property (nonatomic,assign) BOOL                    videoListHidden;
@property (nonatomic,assign) NSInteger               playIndex;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;

@property (nonatomic,assign) float currentTime;
@property (nonatomic,assign) float totalTime;

@property (nonatomic,strong) UILabel *currentDuration;
@property (nonatomic,strong) UILabel *totalDuration;

@property(nonatomic ) BOOL isFirstPlay;

@end

@implementation ETTVideoPlayController

- (instancetype)initWithVideoList:(NSArray<ETTVideoModel *> *)videoList {
    NSAssert(videoList.count, @"The playlist can not be empty!");
    self = [super init];
    if (self) {
        self.videoPaths = [videoList mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstPlay = YES;
    
    [self setup];
    [self setupNavigationBar];
    [self setupBottomBar];
    [self setupVideoList];
}

- (void)setup {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor                 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    self.indicator                            = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.indicator];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemVolumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)setupVideoList {
    self.videoList                 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.videoList.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    self.videoList.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.videoList.delegate        = self;
    self.videoList.dataSource      = self;
    self.videoList.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.videoList];
    self.videoListHidden = YES;
}

//顶部bar
- (void)setupNavigationBar {
    
    self.navigationController.navigationBar.hidden = YES;

    self.navigationView                            = [[UIView alloc]init];
    self.navigationView.backgroundColor            = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [self.view addSubview:self.navigationView];

    //返回按钮
    UIButton *backBtn                              = [UIButton new];
    backBtn.frame                                  = CGRectMake(20, 10, 80, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setImage:[self imageWithName:@"player_quit"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];

    //标题label
    UILabel *titleLabel                            = [UILabel new];
    titleLabel.frame                               = CGRectMake(0, 0, 120, 44);
    titleLabel.font                                = [UIFont systemFontOfSize:17.0];
    titleLabel.textColor                           = [UIColor whiteColor];
    titleLabel.textAlignment                       = NSTextAlignmentCenter;
    titleLabel.text                                = self.titleString;
    titleLabel.centerX                             = self.view.centerX;
    [self.navigationView addSubview:titleLabel];

    //声音图标
    UIImageView *volumeImage                       = [[UIImageView alloc]init];
    volumeImage.frame                              = CGRectMake(665, 10, 30, 30);
    volumeImage.image                              = [self imageWithName:@"player_play"];
    [self.navigationView addSubview:volumeImage];

    //声音调节条
    self.volume                                    = [[UISlider alloc]initWithFrame:CGRectMake(704, 10, 150, 20)];
    self.volume.value                              = [[MPMusicPlayerController applicationMusicPlayer]volume];
    [self.volume setThumbImage:[self imageWithName:@"player_volume"] forState:UIControlStateNormal];
    [self.volume addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.navigationView addSubview:self.volume];

    //同步打开按钮
    UIButton *synchronousOpenButton                = [UIButton new];
    CGFloat synchronousOpenButtonWidth             = 100;
    CGFloat synchronousOpenButtonHeight            = 44;
    [synchronousOpenButton setTitle:@"同步打开" forState:UIControlStateNormal];
    synchronousOpenButton.frame                    = CGRectMake(900, 0, synchronousOpenButtonWidth, synchronousOpenButtonHeight);
    [synchronousOpenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [synchronousOpenButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    synchronousOpenButton.titleLabel.font          = [UIFont systemFontOfSize:17.0];
    synchronousOpenButton.titleEdgeInsets          = UIEdgeInsetsMake(5, 20, 5, 0);
    [synchronousOpenButton addTarget:self action:@selector(pushButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:synchronousOpenButton];
    
    
}

//同步打开按钮的点击
- (void)pushButtonDidClick {
    
    NSLog(@"推送按钮被点击了 这个视频的urlString是  ");
    
}

- (void)backAction:(UIButton *)button {
    
    
    [[NSUserDefaults standardUserDefaults] setFloat:self.currentTime forKey:self.coursewareUrl];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillLayoutSubviews {
    self.navigationView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
    self.bottomBar.frame      = CGRectMake(0, self.view.bounds.size.height-95, self.view.bounds.size.width, 95);
    self.videoList.frame      = CGRectMake(self.view.bounds.size.width, 64, 300, self.view.bounds.size.height- 64 - 95);
    self.indicator.center = self.view.center;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.player playInContainer:self.view];
    [self.view bringSubviewToFront:self.navigationView];
    [self.view bringSubviewToFront:self.bottomBar];
    [self.view bringSubviewToFront:self.videoList];
    [self.view bringSubviewToFront:self.indicator];
    [self.view bringSubviewToFront:self.playButton];
    [self.view bringSubviewToFront:self.previousItem];
    [self.view bringSubviewToFront:self.nextItem];
    
    [self startIndicator];
    [self hide];
}

//底部bar
- (void)setupBottomBar {
    
    self.bottomBar                 = [[UIView alloc]init];
    self.bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [self.view addSubview:self.bottomBar];

    //播放按钮
    self.playButton                = [UIButton new];
    self.playButton.frame          = CGRectMake(200, 200, 60, 60);
    [self.playButton setBackgroundImage:[self imageWithName:@"player_pause"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[self imageWithName:@"player_play"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.centerX        = self.view.centerX;
    [self.view addSubview:self.playButton];

    //上一个播放按钮
    self.previousItem              = [UIButton new];
    self.previousItem.frame        = CGRectMake(120, 200, 60, 60);
    [self.previousItem setBackgroundImage:[self imageWithName:@"player_play"] forState:UIControlStateNormal];
    [self.previousItem addTarget:self action:@selector(previous:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.previousItem];

    //下一个播放按钮
    self.nextItem                  = [UIButton new];
    self.nextItem.frame            = CGRectMake(720, 200, 60, 60);
    [self.nextItem setBackgroundImage:[self imageWithName:@"player_play"] forState:UIControlStateNormal];
    [self.nextItem addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextItem];

    //播放进度条
    self.slider                    = [[ETTVideoPlaySlider alloc]initWithFrame:CGRectMake(50, 10, [UIScreen mainScreen].bounds.size.width-100, 20)];
    //设置进度条上的图片
    self.slider.thumbImage         = [self imageWithName:@"player_slider"];
    [self.slider addTarget:self action:@selector(playProgressChange:) forControlEvents:UIControlEventValueChanged];
    [self.bottomBar addSubview:self.slider];

    //播放菜单按钮
    UIButton *menuBtn              = [[UIButton alloc]init];
    menuBtn.frame                  = CGRectMake(CGRectGetMaxX(self.slider.frame) + 10, 10, 30, 30);
    [menuBtn setImage:[self imageWithName:@"player_menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:menuBtn];

    //当前时长
    UILabel *currentDuration       = [[UILabel alloc]init];
    currentDuration.font           = [UIFont systemFontOfSize:17.0];
    currentDuration.textColor      = [UIColor whiteColor];
    currentDuration.frame          = CGRectMake(50, 40, 160, 30);
    currentDuration.textAlignment  = NSTextAlignmentRight;
    currentDuration.text           = [NSString stringWithFormat:@"%@/",[self formatPlayTime:self.currentTime]];
    [self.bottomBar addSubview:currentDuration];
    self.currentDuration           = currentDuration;

    //播放总时长
    UILabel *totalDuration         = [[UILabel alloc]init];
    totalDuration.font             = [UIFont systemFontOfSize:17.0];
    totalDuration.textColor        = [UIColor whiteColor];
    totalDuration.text             = [NSString stringWithFormat:@"%@",[self formatPlayTime:self.totalTime]];
    totalDuration.frame            = CGRectMake(CGRectGetMaxX(currentDuration.frame), 40, 160, 30);
    totalDuration.textAlignment    = NSTextAlignmentLeft;
    [self.bottomBar addSubview:totalDuration];
    self.totalDuration             = totalDuration;

    //播放尺寸放大  暂留
    UIButton *displayButton        = [UIButton buttonWithType:UIButtonTypeCustom];
    displayButton.frame            = CGRectMake(0, 0, 30, 30);
    [displayButton setBackgroundImage:[self imageWithName:@"player_fill"] forState:UIControlStateNormal];
    [displayButton setBackgroundImage:[self imageWithName:@"player_fit"] forState:UIControlStateSelected];
    [displayButton addTarget:self action:@selector(displayModeChanged:) forControlEvents:UIControlEventTouchUpInside];
   
}

//将时间转换成00:00:00格式
- (NSString *)formatPlayTime:(NSTimeInterval)duration
{
    int minute = 0, hour = 0, secend = duration;
    minute     = (secend % 3600)/60;
    hour       = secend / 3600;
    secend     = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.videoListHidden) {
        self.videoListHidden = YES;
        [UIView animateWithDuration:0.15 animations:^{
            self.videoList.frame = CGRectMake(self.view.bounds.size.width, 64, 300, self.view.bounds.size.height- 64 - 95);
        } completion:^(BOOL finished) {
            
        }];
    }
    if (self.hidden) {
        [UIView animateWithDuration:0.15 animations:^{
            self.navigationView.alpha = 1;
            self.bottomBar.alpha      = 1;
            self.playButton.alpha     = 1;
            self.previousItem.alpha   = 1;
            self.nextItem.alpha       = 1;
            
        } completion:^(BOOL finished) {
            self.hidden = NO;
            [self hide];
        }];
    }
    else {
        [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBar) object:self];
        
        [self hideBar];
    }
}

- (void)hide {
    [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBar) object:self];
    [self performSelector:@selector(hideBar) withObject:self afterDelay:4];
}

- (void)hideBar {
    if (!self.videoListHidden) {
        return;
    }
    [UIView animateWithDuration:0.15 animations:^{
        self.navigationView.alpha = 0;
        self.bottomBar.alpha      = 0;
        self.playButton.alpha     = 0;
        self.previousItem.alpha   = 0;
        self.nextItem.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - Action
- (void)volumeChanged:(UISlider *)slider {
    [[MPMusicPlayerController applicationMusicPlayer]setVolume:slider.value];
    
    //可以根据声音的大小调节
}

- (void)displayModeChanged:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.player.displayMode = ETTVideoPlayerDisplayModeAspectFill;
    }
    else {
        self.player.displayMode = ETTVideoPlayerDisplayModeAspectFit;
    }
}

- (void)playProgressChange:(ETTVideoPlaySlider *)slider {
    [self.player moveTo:slider.value];
    if (!self.playButton.selected) {
        [self.player play];
    }
}

- (void)menu:(UIBarButtonItem *)item {
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat offset       = self.videoListHidden ? -300 : 0;
        self.videoList.frame = CGRectMake(self.view.bounds.size.width+offset, 64, 300, self.view.bounds.size.height- 64 - 95);
    } completion:^(BOOL finished) {
        self.videoListHidden = !self.videoListHidden;
    }];
}
- (void)playAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player pause];
    }
    else {
        [self.player play];
    }
}

- (void)next:(UIBarButtonItem *)item {
    if (self.playIndex >= self.videoPaths.count-1) {
        return;
    }
    self.playIndex++;
    [self.videoList reloadData];
    ETTVideoModel *model = self.videoPaths[self.playIndex];
    [self playVideoWithPath:model.path];
}

- (void)previous:(UIBarButtonItem *)item {
    if (self.playIndex <= 0) {
        [self.player playAtTheBeginning];
        return;
    }
    self.playIndex--;
    [self.videoList reloadData];
    ETTVideoModel *model = self.videoPaths[self.playIndex];
    [self playVideoWithPath:model.path];
}

- (void)playVideoWithPath:(NSString *)path {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.player.path = path;
    });
}

- (void)startIndicator {
    if (![self.indicator isAnimating]) {
        [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.indicator withObject:nil];
    }
}

- (void)stopIndicator {
    if ([self.indicator isAnimating]) {
        [NSThread detachNewThreadSelector:@selector(stopAnimating) toTarget:self.indicator withObject:nil];
    }
}

- (void)systemVolumeChanged:(NSNotification *)not {
    float new = [not.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    self.volume.value = new;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoPaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell                 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        UIButton *del        = [UIButton buttonWithType:UIButtonTypeCustom];
        del.frame            = CGRectMake(0, 0, 40, 40);
        [del setImage:[self imageWithName:@"player_delete"] forState:UIControlStateNormal];
        [del addTarget:self action:@selector(delVideo:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView   = del;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryView.tag = indexPath.row;
    ETTVideoModel *model = self.videoPaths[indexPath.row];
    if (self.playIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    }
    else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.playIndex) {
        return;
    }
    self.playIndex = indexPath.row;
    [self.videoList reloadData];
    ETTVideoModel *model = self.videoPaths[indexPath.row];
    [self playVideoWithPath:model.path];
}

- (void)delVideo:(UIButton *)sender {
    if (self.videoPaths.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (self.playIndex > sender.tag) {
        self.playIndex--;
    }
    else if (self.playIndex == sender.tag) {
        [self.player pause];
        if (self.playIndex == self.videoPaths.count-1) {
            ETTVideoModel *model = self.videoPaths[0];
            [self playVideoWithPath:model.path];
            self.playIndex = 0;
        }
        else {
            ETTVideoModel *model = self.videoPaths[self.playIndex+1];
            [self playVideoWithPath:model.path];
        }
    }
    [self.videoPaths removeObjectAtIndex:sender.tag];
    [self.videoList reloadData];
}



- (ETTVideoPlayer *)player {
    if (_player == nil) {
        _player = [[ETTVideoPlayer alloc]init];
        _player.delegate = self;
        __weak ETTVideoPlayController *weakSelf = self;
        _player.bufferProgressBlock = ^(float f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.slider.bufferValue = f;
            });
        };
        _player.progressBlock = ^(float f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf.slider.slide) {
                    weakSelf.slider.value = f;
                }
            });
        };
        _player.currentTimeBlock = ^(float currentTime){
        dispatch_async(dispatch_get_main_queue(), ^{
           
            weakSelf.currentTime = currentTime;
            
            weakSelf.currentDuration.text = [NSString stringWithFormat:@"%@/",[weakSelf formatPlayTime:weakSelf.currentTime]];
            
        });
        
        };
        
        _player.totalTimeBlock = ^(float totalTime){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.totalTime = totalTime;
                
                weakSelf.totalDuration.text = [NSString stringWithFormat:@"%@",[weakSelf formatPlayTime:weakSelf.totalTime]];
                
            });
        };
        
        
        ETTVideoModel *model = self.videoPaths[0];
        _player.path = model.path;
    }
    return _player;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
    self.player = nil;
}


#pragma mark - SSVideoPlayerDelegate

- (void)videoPlayerDidReadyPlay:(ETTVideoPlayer *)videoPlayer {
    [self stopIndicator];
    
    if (self.isFirstPlay) {
        
        float lastTime = [[NSUserDefaults standardUserDefaults]floatForKey:self.coursewareUrl];
        [self.player.player seekToTime:CMTimeMakeWithSeconds(lastTime, 1000)];
        
        self.isFirstPlay = NO;
    }
    
    [self.player play];
}

- (void)videoPlayerDidBeginPlay:(ETTVideoPlayer *)videoPlayer {
    self.playButton.selected = NO;
}

- (void)videoPlayerDidEndPlay:(ETTVideoPlayer *)videoPlayer {
    self.playButton.selected = YES;
}

- (void)videoPlayerDidSwitchPlay:(ETTVideoPlayer *)videoPlayer {
    [self startIndicator];
}

- (void)videoPlayerDidFailedPlay:(ETTVideoPlayer *)videoPlayer {
    [self stopIndicator];
    [[[UIAlertView alloc]initWithTitle:@"该视频无法播放" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
}

- (UIImage *)imageWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"SSVideoPlayer" ofType:@"bundle"];
    NSString *imagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
