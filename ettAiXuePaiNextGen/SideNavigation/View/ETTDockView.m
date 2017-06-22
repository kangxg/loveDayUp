//
//  ETTDockView.m
//  ettAiXuePaiNextGen
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
//  Created by zhaiyingwei on 16/9/13.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTDockView.h"

@interface ETTDockView ()

@property (nonatomic,assign)ETTSideNavigationViewIdentity identity;

@end

@implementation ETTDockView

-(instancetype)initWithIdentity:(ETTSideNavigationViewIdentity)identity
{
    if (self = [super init]) {
        self.backgroundColor = kETTRGBCOLOR(43, 45, 45);
        self.identity = identity;
        [[[self setupTopMenu]setupTabBar]setupBottomMeun];
    }
    
    return self;
}

-(instancetype)initWithModel:(ETTStudentSelectTeacherModel *)model ForIdentity:(ETTSideNavigationViewIdentity)identity
{
    if (self = [super init]) {
        self.backgroundColor = kETTRGBCOLOR(43, 45, 45);
        _model = model;
        self.identity = identity;
        [[[self setupTopMenu]setupTabBar]setupBottomMeun];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kETTRGBCOLOR(43, 45, 45);
        
        //[[[self setupTopMenu]setupTabBar]setupBottomMeun];
    }
    return self;
}

-(instancetype)setupTopMenu
{
    ETTTopMenu *topMenu       = [[ETTTopMenu alloc]init];
    [self addSubview:topMenu];
    _topMenu                  = topMenu;

    ETTIconButton *iconButton = [[ETTIconButton alloc]initWithLayoutStryle:ETTButtonLayoutStyleVertical];
    [iconButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [iconButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [topMenu addSubview:iconButton];
    _iconButton = iconButton;
    
    return self;
}

-(instancetype)setupTabBar
{
    ETTTabBar *tabBar = [[ETTTabBar alloc]init];
    [self addSubview:tabBar];
    _tabBar = tabBar;
    if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"student"]||[[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"ObserveStudents"]) {
        [_tabBar setMessageLableText:_model.titlName];
    }
    
    return self;
}

-(instancetype)setupBottomMeun
{
    ETTBottomMenu *bottomMenu = [[ETTBottomMenu alloc]init];
    [self addSubview:bottomMenu];
    _bottomMenu = bottomMenu;
    
    return self;
}

-(void)rotateToLandscape:(BOOL)isLandscape
{
    self.width            = isLandscape ? kDockLandscapeWidth : kDockPortraitWidth;
    self.height           = self.superview.height;
    self.x                = isLandscape? -kDockLandscapeWidth : -kDockPortraitWidth;

    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    [_topMenu rotateToLandscape:isLandscape];

    [self.bottomMenu rotateToLandscape:isLandscape];

    [self.tabBar rotateToLandscape:isLandscape];
    self.tabBar.y = self.superview.height - self.bottomMenu.height - self.tabBar.height - (self.superview.height - self.bottomMenu.height - self.tabBar.height -self.topMenu.height)/2;
    
    
    [self.iconButton rotateToLandscape:isLandscape];
}

@end
