//
//  ETTLoginView.m
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

#import "ETTLoginView.h"
#import "AXPUserInformation.h"
#import <SDWebImageManager.h>
@interface ETTLoginView ()

@property (nonatomic,strong) ETTImageView        *avatarImageView;

@property (nonatomic,strong) ETTView             *backView;

@property (nonatomic,strong) ETTLoginInputView   *loginInputView;

@property (nonatomic,strong) ETTLoginButton      *okBtn;

@property (nonatomic,strong) ETTErrorMessageView *messageView;

@property (nonatomic,strong) UIImage             *defaultImage;
@property (nonatomic,strong) UIImage             *userImge;

/**
 *  用户信息，@"id",@"password".
 */
@property (nonatomic,weak) NSMutableDictionary *userMessageDic;

@end

@implementation ETTLoginView

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor                                         = [[UIColor blackColor]colorWithAlphaComponent:0];
        self.frame                                                   = CGRectMake(kSCREEN_WIDTH/2 - kLoginBackgroundViewWidth/2, kSCREEN_HEIGHT/2 - kLoginBackgroundViewHeight/2, kLoginBackgroundViewWidth, kLoginBackgroundViewHeight);
        self.layer.masksToBounds                                     = YES;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        [[[[[self setupBackView]setupAvatarImageView]setupLoginInputView]setupOKBtn]setupErrorMessageView];
    }
    return self;
}

-(instancetype)setupAvatarImageView
{
    UIImage *defaultImage               = [UIImage imageNamed:@"login_default_icon"];
    _defaultImage                       = defaultImage;
    ETTImageView *avatarImageView       = [[ETTImageView alloc]initWithImage:defaultImage];
    avatarImageView.layer.borderColor   = [UIColor whiteColor].CGColor;
    avatarImageView.layer.borderWidth   = 5.0;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius  = 44;
    [self addSubview:avatarImageView];
    _avatarImageView = avatarImageView;
    
    NSDictionary *userDic = [ETTUSERDefaultManager getUSERMessage];
    if (userDic[@"icon"]) {
        UIImage *userImge = [UIImage imageWithData:[userDic objectForKey:@"icon"]];
        _userImge = userImge;
        
        //NSDictionary *userMessage = [ETTUSERDefaultManager getUSERMessage];
        if ([[userDic objectForKey:@"selected"]isEqualToString:@"YES"])
        {
      
            [avatarImageView setImage:userImge];
        }
    };
    
    return self;
}

-(instancetype)setupBackView
{
    ETTView *backView           = [[ETTView alloc]init];
    backView.layer.cornerRadius = kLoginCornerRadius;
    backView.backgroundColor    = [UIColor whiteColor];
    [self addSubview:backView];
    _backView = backView;
    
    return self;
}

-(instancetype)setupLoginInputView
{
    ETTLoginInputView *loginInputView = [[ETTLoginInputView alloc]init];
    loginInputView.MDelegate          = self;
    [self addSubview:loginInputView];
    _loginInputView = loginInputView;
    
    return self;
}

-(instancetype)setupOKBtn
{
    ETTLoginButton *okBtn = [[ETTLoginButton alloc]initWithTitle:@"登录"];
    [okBtn setButtonType:ETTLoginButtonTypeUnavailable];
    okBtn.MDelegate = self;
    [self addSubview:okBtn];
    _okBtn = okBtn;
    
    if (ETTLoginInputViewTypeAvailable == [_loginInputView getStatus]) {
        [self.okBtn setButtonType:ETTLoginButtonTypeAvailable];
    }else{
        [self.okBtn setButtonType:ETTLoginButtonTypeUnavailable];
    }
    
    return self;
}

-(instancetype)setupErrorMessageView
{
    ETTErrorMessageView *messageView = [[ETTErrorMessageView alloc]init];
    [self addSubview:messageView];
    _messageView = messageView;
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_avatarImageView setFrame:CGRectMake(self.frame.size.width/2 - kAvatarImageViewWidth/2, 0, kAvatarImageViewWidth, kAvatarImageViewHeight)];
    [_backView setFrame:CGRectMake(0, kAvatarImageViewHeight/2, self.frame.size.width, self.frame.size.height - kAvatarImageViewHeight/2)];
    [_loginInputView setFrame:CGRectMake(50, 135 + kLoginInputVInterval - kAvatarImageViewHeight/2, self.frame.size.width - 2*50, 150)];
    [_okBtn setFrame:CGRectMake(50, self.height-94, 300, 44)];
}

#pragma mark - ETTLoginButtonDelegate
-(void)loginButtonClickHandler:(ETTLoginButton *)sender
{
    
    NSDictionary *userMessage = [_loginInputView getUSERMessage];
    if ([ETTUSERDefaultManager setUSERMessageForId:[userMessage objectForKey:@"id"] passwordStr:[userMessage objectForKey:@"password"] isSelected:[userMessage objectForKey:@"selected"]]) {
        WS(weakSelf);
        [ETTLoginViewVM login:userMessage callBack:^(NSDictionary *dic, NSError *error) {
            if (error) {
                NSString *errMessStr = nil;
                if ([[error.userInfo objectForKey:@"NSLocalizedDescription"]isEqualToString:@"似乎已断开与互联网的连接。"]) {
                    errMessStr = @"与网络链接已中断。";
                }else{
                    errMessStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                }
                [weakSelf.messageView showErrorMessage:errMessStr];
            }else{
                [weakSelf dealWithLoginMessage:dic];
            }
        }];
    }else{
        NSLog(@"userdefault was wrong!!!");
    }
}

-(instancetype)dealWithLoginMessage:(NSDictionary *)dictionary
{
    WS(weakSelf);
    if ([[dictionary objectForKey:@"result"]intValue]==1) {
    
    NSDictionary *data = [dictionary objectForKey:@"data"];
    
    NSArray *identityList = [data objectForKey:@"identityList"];
    
        for (NSDictionary *dic in identityList) {
            [AXPUserInformation sharedInformation].redisIp = [dic objectForKey:@"redisIp"];
        }
        
    
    //登录成功
        if ([ETTUSERDefaultManager initAllUserMessage:dictionary])
        {
            [ETTUSERDefaultManager clearClassStateCache];
            
            NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[ETTUSERDefaultManager getUserTypeDictionary]];
            NSString *jumpStr;
            switch ([[userDic objectForKey:@"userType"]intValue]) {
                case 1:         //Teacher
                    jumpStr = @"Teacher";
                    break;
                case 3:         //Student
                    jumpStr = @"Student";
                    break;
                case 6:         //All
                    jumpStr = @"All";
                    break;
                default:
                    break;
            }
            if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(gotoTransition:)]) {
                [self.MDelegate gotoTransition:jumpStr];
            }
        }else{
            
        }
    }else{
        [weakSelf.messageView showErrorMessage:[dictionary objectForKey:kMsg]];
    }
    return self;
}

#pragma mark - ETTLoginInputViewDelegate
-(void)judgmentStatus:(NSDictionary *)dic
{
    NSLog(@"输入的USERMESSAGER %@",dic);
    if ([[dic objectForKey:@"status"]isEqualToString:@"YES"]) {
        NSLog(@"可用!!!");
        [self.okBtn setButtonType:ETTLoginButtonTypeAvailable];
    }else{
        NSLog(@"不可用!!!");
        [self.okBtn setButtonType:ETTLoginButtonTypeUnavailable];
    }
}

-(void)updateDefaultIcon
{
    [_avatarImageView setImage:_defaultImage];
}

-(void)updateUserIcon
{
    [_avatarImageView setImage:_userImge];
}

@end
