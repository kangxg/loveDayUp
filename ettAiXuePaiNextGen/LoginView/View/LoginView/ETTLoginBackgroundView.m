//
//  ETTLoginBackgroundView.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 16/9/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLoginBackgroundView.h"

@interface ETTLoginBackgroundView ()

@property (nonatomic,strong) ETTLoginView *loginView;
@property (nonatomic,strong) ETTImageView *imageView;
@property (nonatomic,copy  ) NSString     *type;
@property (nonatomic,strong) ETTView      *maskView;
@property (nonatomic,strong) ETTView      *containerView;


@end

@implementation ETTLoginBackgroundView 

-(instancetype)initWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        if (type == ETTLoginAfterUsing) {
            [self setAfterUsingBackgroundImage];
        }else{
            [self setupBackgroundImage];
        }
    }
    return self;
}



-(instancetype)setupContainerView
{
    ETTView *containerView = [[ETTView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    [self addSubview:containerView];
    _containerView         = containerView;
    [[self setupMaskView]setupLoginView];
    return self;
}

-(instancetype)setupLoginView
{
    ETTLoginView *loginView = [[ETTLoginView alloc]init];
    loginView.MDelegate     = self;
    [_containerView addSubview:loginView];
    _loginView = loginView;
    
    return self;
}

-(instancetype)setupMaskView
{
    ETTView *maskView = [[ETTView alloc]init];
    [maskView setBackgroundColor:[UIColor whiteColor]];
    maskView.alpha    = 0.5;
    [_containerView addSubview:maskView];
    _maskView         = maskView;
    
    return self;
}

-(instancetype)setupBackgroundImage
{
    ETTScrollView *bgScrollView                 = [[ETTScrollView alloc]initWithFrame:self.bounds];
    bgScrollView.contentSize                    = CGSizeMake(self.frame.size.width*4, self.frame.size.height);
    bgScrollView.backgroundColor                = [UIColor yellowColor];
    bgScrollView.alwaysBounceHorizontal         = NO;
    bgScrollView.alwaysBounceVertical           = NO;
    bgScrollView.bounces                        = NO;
    bgScrollView.pagingEnabled                  = YES;
    bgScrollView.scrollEnabled                  = YES;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.delegate                       = self;
    bgScrollView.userInteractionEnabled         = YES;
    [self addSubview:bgScrollView];
    CGSize scrSize                              = bgScrollView.frame.size;
    for (int i=1; i<=4; i++) {
        UIImage *image       = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_image_%d",i]];
        ETTImageView *backIV = [[ETTImageView alloc]initWithImage:image];
        backIV.frame         = CGRectMake((i-1)*scrSize.width, 0, scrSize.width, scrSize.height);
        [bgScrollView addSubview:backIV];
        
        if(4 == i)
        {
            UIImage *mImage               = [UIImage imageNamed:@"welcome_btn_login_pressed"];

            backIV.userInteractionEnabled = YES;

            ETTButton *btn                = [ETTButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"welcome_btn_login_default"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"welcome_btn_login_pressed"] forState:UIControlStateHighlighted];
            [btn setFrame:CGRectMake((backIV.size.width-mImage.size.width/2.0)/2.0, backIV.size.height-100, mImage.size.width/2.0, mImage.size.height/2.0)];
            [backIV addSubview:btn];
            [btn addTarget:self action:@selector(onClickHandler) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return self;
}

// 使用后进行加载登陆界面
- (void)setAfterUsingBackgroundImage{
    CGSize scrSize = self.frame.size;
    UIImage *image       = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_image_%d",4]];
    ETTImageView *backIV = [[ETTImageView alloc]initWithImage:image];
    backIV.frame         = CGRectMake(0, 0, scrSize.width, scrSize.height);
    [self addSubview:backIV];
    
    UIImage *mImage               = [UIImage imageNamed:@"welcome_btn_login_pressed"];
    
    backIV.userInteractionEnabled = NO;
    
    ETTButton *btn                = [ETTButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"welcome_btn_login_default"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"welcome_btn_login_pressed"] forState:UIControlStateHighlighted];
    [btn setFrame:CGRectMake((backIV.size.width-mImage.size.width/2.0)/2.0, backIV.size.height-100, mImage.size.width/2.0, mImage.size.height/2.0)];
    [backIV addSubview:btn];
    [self setupContainerView];
}

-(void)onClickHandler
{
    [self setupContainerView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    _maskView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
}

#pragma mark - ETTLoginViewDelegate
-(void)gotoTransition:(NSString *)type
{
    _type = type;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForJumpType object:_type];
}

-(void)dealloc
{
    _imageView = nil;
    _loginView = nil;
    _maskView  = nil;
    _containerView = nil;
}

@end
