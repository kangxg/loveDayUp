//
//  AXPStudentSubjectViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPStudentSubjectViewController.h"
#import "AXPRewardManagerView.h"
#import "AXPRedisManager.h"
#import "AXPUserInformation.h"
#import "AXPRedisSendMsg.h"
#import "ETTUserInformationProcessingUtils.h"

@interface AXPStudentSubjectViewController ()

@property(nonatomic ,strong) UIButton *pushToStudentButton;

@property(nonatomic ,strong) UIButton *pushFinishedButton;

@property(nonatomic ,copy) NSString *currentState;

@property(nonatomic ,strong) UIView *leftBackView;

@property (strong, nonatomic) AXPRewardManagerView *rewardManagerView;

@end

@implementation AXPStudentSubjectViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpWhiteboardNavagationBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [self.rewardManagerView hiddenRewardManagerView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *buttonTypes;
    
    // 学生白板作答/互批 结束 已结束 试卷作答/结束
    NSString *classState = self.classroomDict[@"state"];
    
    switch (classState.integerValue) {
        case 2: // 白板作答中
            
            buttonTypes = @[@"查看原题"];
            
            break;
            
        case 3: // 白板作答结束
            
            buttonTypes = @[@"奖励",@"查看原题",@"推给学生"];
            
            break;
            
        case 5: // 白板互批中
            
            buttonTypes = @[@"查看原题",@"学生作答"];
            
            break;
            
        case 20: // 白板互批结束
            
            buttonTypes = @[@"奖励",@"查看原题",@"学生作答",@"推给学生"];
            
            break;
            
        case 13: // 试卷答题结束
            
            buttonTypes = @[@"奖励",@"推给学生"];
            
            break;
            
        case 26: // 试卷互批
            
            buttonTypes = @[@"学生作答"];
            
            break;
            
        case 27: // 试卷互批结束
        
            buttonTypes = @[@"奖励",@"学生作答",@"推给学生"];
            
            break;
        case 22:
        {
            self.leftBackView.hidden = YES;
            self.currentState  = @"20";
            buttonTypes = @[@"奖励",@"查看原题",@"学生作答",@"结束推送"];
        }
            break;
        case 21:
        {
            self.leftBackView.hidden = YES;
            self.currentState  = @"3";
            buttonTypes = @[@"奖励",@"查看原题",@"结束推送"];
        }

            break;
        case 24:
        {
             buttonTypes = @[@"奖励",@"结束推送"];
        }
            break;
        default:
            break;
    }
    
    self.rewardManagerView = [[AXPRewardManagerView alloc] initWithButtonType:buttonTypes];
    
    __weak typeof(self)wself = self;
    
    // 推送/结束推送 学生作答图片给全体学生
    [self.rewardManagerView pushImageToStudentHandle:^{
        //
        [self pushImageToStudentWithSuccessHandle:^{
            //
            self.rewardManagerView.pushImageSuccessHandle();
            
        } failHandle:^{
            //
            self.rewardManagerView.pushImageFailHandle();
        }];
        
    } endPushImageToStudentHandle:^{
        //
        [wself pushFinished];
    }];
    
    // 奖励
    [self.rewardManagerView rewardStudent:^{
        
        [ETTUserInformationProcessingUtils publishMessageType:@"MA_02" toJid:wself.answerJid];
    }];
    
    
    [self.view addSubview:self.rewardManagerView];
}

-(instancetype)init
{
    self = [super init];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT - 64)];
    
    [self.view addSubview:self.imageView];
    
    return self;
}

-(void)pushImageToStudentWithSuccessHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    if (!self.currentState) {
        self.currentState = self.classroomDict[@"state"];
    }
    
    // 学生白板作答/互批 结束 已结束 试卷作答/结束
    NSString *classState = self.currentState;
    
    switch (classState.integerValue) {
    
        case 3: // 推送白板作答图片
        {
            [self.classroomDict setObject:@"21" forKey:@"state"];
            [self.classroomDict setObject:self.imageUrlStr forKey:kAnswerImg];
        }
            break;
            
        case 13: // 推送学生试卷作答图片
        {
            [self.classroomDict setObject:@"24" forKey:@"state"];
            [self.classroomDict setObject:self.imageUrlStr forKey:kPaperAnswerImg];
        }
            break;
            
        case 20: // 推送学生白板批阅图片
        {
            [self.classroomDict setObject:@"22" forKey:@"state"];
            [self.classroomDict setObject:self.imageUrlStr forKey:kCommentImg];
        }
            break;
            
        case 27: // 推送学生试卷批阅图片
        {
            [self.classroomDict setObject:@"25" forKey:@"state"];
            [self.classroomDict setObject:self.imageUrlStr forKey:kPaperCommentImg];
        }
            break;

        default:
            break;
    }
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:self.classroomDict];
    [self.classroomDict setObject:self.title forKey:@"userName"];
    [self.classroomDict setObject:self.answerJid forKey:kuserId];
   
    [self sendMessageWithUserInfo:self.classroomDict withType:@"WB_01" SuccessHandle:successHandle failHandle:failHandle];
    
}

-(void)sendMessageWithUserInfo:(NSDictionary *)dic withType:(NSString *)type SuccessHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    [AXPRedisSendMsg sendMessageWithUserInfo:dic type:type successHandle:^{
        //
        if (successHandle) {
            successHandle();
            self.leftBackView.hidden = YES;
        }
    } failHandle:^{
        //
        if (failHandle) {
            failHandle();
            self.leftBackView.hidden = NO;
        }
    }];
}

-(void)originSendRedisMsgWithSuccessHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    NSString *redisIp     = [AXPUserInformation sharedInformation].redisIp;
    NSString *classroomId = [AXPUserInformation sharedInformation].classroomId;

    NSString *redisKey    = [NSString stringWithFormat:@"%@%@",CACHE_CLASSROOM_STATE,classroomId];

    NSString *dataStr     = [self getJsonStrWithDict:self.classroomDict];
    WS(weakSelf);
    [AXPRedisManager setRedisvalueWithHost:redisIp key:redisKey value:dataStr completionHandle:^(id message) {
        
        if ([message isKindOfClass:[NSString class]]&&[message isEqualToString:@"OK"]) {
            
            NSLog(@"推送成功");
            if (successHandle) {
                successHandle();
                weakSelf.leftBackView.hidden = YES;
            }
            
        }else
        {
            NSLog(@"推送失败");
            if (failHandle) {
                failHandle();
                weakSelf.leftBackView.hidden = NO;
            }
        }
    }];
}


-(void)pushFinished
{
    [self.classroomDict setObject:@"23" forKey:@"state"];
    [self.classroomDict setObject:[NSString stringWithFormat:@"%@",self.currentState] forKey:@"lastState"];
    [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:@"WB_01" successHandle:^{
        //
        self.leftBackView.hidden = NO;
        
    } failHandle:nil];
}

-(void)originPushFinished
{
    NSString *redisIp     = [AXPUserInformation sharedInformation].redisIp;
    NSString *classroomId = [AXPUserInformation sharedInformation].classroomId;

    NSString *redisKey    = [NSString stringWithFormat:@"%@%@",CACHE_CLASSROOM_STATE,classroomId];

    [self.classroomDict setObject:@"23" forKey:@"state"];

    NSString *dataStr     = [self getJsonStrWithDict:self.classroomDict];
    WS(weakSelf);
    [AXPRedisManager setRedisvalueWithHost:redisIp key:redisKey value:dataStr completionHandle:^(id message) {
        
        if ([message isKindOfClass:[NSString class]]&&[message isEqualToString:@"OK"]) {
            
            NSLog(@"结束推送图片成功");
            weakSelf.leftBackView.hidden = NO;
        }
    }];
}

-(void)dismissFromSuperView
{
    
    if (!self.currentState) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self.classroomDict setObject:self.currentState forKey:@"state"];
    
    [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:@"WB_01" successHandle:^{
        //
        [self.navigationController popViewControllerAnimated:YES];

    } failHandle:nil];
}

-(void)originDismissFromSuperView
{
    if (!self.currentState) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSString *redisIp     = [AXPUserInformation sharedInformation].redisIp;
    NSString *classroomId = [AXPUserInformation sharedInformation].classroomId;

    NSString *redisKey    = [NSString stringWithFormat:@"%@%@",CACHE_CLASSROOM_STATE,classroomId];

    [self.classroomDict setObject:self.currentState forKey:@"state"];

    NSString *dataStr     = [self getJsonStrWithDict:self.classroomDict];
    
    [AXPRedisManager setRedisvalueWithHost:redisIp key:redisKey value:dataStr completionHandle:^(id message) {
        
        if ([message isKindOfClass:[NSString class]]&&[message isEqualToString:@"OK"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


-(void)setUpWhiteboardNavagationBar
{
    UIView *leftView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    leftView.backgroundColor = [UIColor clearColor];

    UIButton *backButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(dismissFromSuperView) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame         = CGRectMake(-16, 0, 50, 44);
    [leftView addSubview:backButton];

    self.leftBackView        = backButton;

    UIView *rightView        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    [rightView addSubview:self.pushFinishedButton];
    [rightView addSubview:self.pushToStudentButton];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

-(UIButton *)creatNavigationBarButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    return button;
}

-(UIButton *)pushFinishedButton
{
    if (!_pushFinishedButton) {
        
        _pushFinishedButton        = [self creatNavigationBarButtonWithTitle:@"结束推送"];
        _pushFinishedButton.hidden = YES;
        _pushFinishedButton.frame  = CGRectMake(26, 2, 80, 41);
        [_pushFinishedButton addTarget:self action:@selector(pushFinished) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushFinishedButton;
}

-(UIButton *)pushToStudentButton
{
    if (!_pushToStudentButton) {
     
        _pushToStudentButton = [self creatNavigationBarButtonWithTitle:@"推送到学生"];
        _pushToStudentButton.hidden = YES;
        _pushToStudentButton.frame = CGRectMake(16, 2, 90, 41);
    }
    return _pushToStudentButton;
}

-(id)getDictWithStr:(NSString *)jsonStr
{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    return dict;
}
     
-(NSString *)getJsonStrWithDict:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
        
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        return jsonStr;
    }else
    {
        return nil;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end


@implementation AXPPaperStudentSubjectViewController

-(void)pushImageToStudentWithSuccessHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    if (!self.currentState) {
        self.currentState = self.classroomDict[@"state"];
    }
 
    // 学生白板作答/互批 结束 已结束 试卷作答/结束
    NSString *classState = self.currentState;
    
    switch (classState.integerValue) {
            
            
        case 13: // 推送学生试卷作答图片
        {
            [self.classroomDict setObject:@"24" forKey:@"state"];
            [self.classroomDict setObject:self.imageUrlStr forKey:kPaperAnswerImg];
        }
            break;
        case 24:
        {
            [self.classroomDict setObject:@"13" forKey:@"state"];
            [self.classroomDict setObject:self.imageUrlStr forKey:kCommentImg];
        }
          break;
            
        default:
            break;
    }
    //    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:self.classroomDict];
    [self.classroomDict setObject:self.title forKey:@"userName"];
    [self.classroomDict setObject:self.answerJid forKey:kuserId];
    
    [self sendMessageWithUserInfo:self.classroomDict withType:@"WB_01" SuccessHandle:successHandle failHandle:failHandle];
    
}

-(void)sendMessageWithUserInfo:(NSDictionary *)dic withType:(NSString *)type SuccessHandle:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    [AXPRedisSendMsg sendStudentSubjecMessageWithUserInfo:dic type:type successHandle:^{
        //
        if (successHandle) {
            successHandle();
            self.leftBackView.hidden = YES;
        }
    } failHandle:^{
        //
        if (failHandle) {
            failHandle();
            self.leftBackView.hidden = NO;
        }
    }];
}


-(void)pushFinished
{
    [self.classroomDict setObject:@"23" forKey:@"state"];
    [self.classroomDict setObject:[NSString stringWithFormat:@"%@",self.currentState] forKey:@"lastState"];
    [AXPRedisSendMsg sendStudentSubjecMessageWithUserInfo:self.classroomDict type:@"WB_01" successHandle:^{
        //
        [self.classroomDict setObject:@"13" forKey:@"state"];
        self.leftBackView.hidden = NO;
        
    } failHandle:nil];

}

@end
