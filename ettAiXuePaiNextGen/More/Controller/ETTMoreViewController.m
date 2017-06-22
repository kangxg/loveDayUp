//
//  ETTMoreViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTMoreViewController.h"
#import "ETTSideNavigationViewController.h"
#import "ETTLCAButton.h"
#import "ETTAiXueClassViewController.h"
#import "ETTNetworkAixueManager.h"
#import <SafariServices/SafariServices.h>
#import "ETTSafariViewController.h"

@interface ETTMoreViewController ()<SFSafariViewControllerDelegate>

@property (copy, nonatomic) NSString *token;

@end

@implementation ETTMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupNavBar];
    
    [self setupSubview];
    
    //[self getToken];
    
    
}

- (void)getToken {
    
    NSString *urlString = [NSString stringWithFormat:GET_TOKEN];

    NSString *userType  = [AXPUserInformation sharedInformation].userType;
    if ([userType isEqualToString:@"teacher"]) {
        userType = @"1";
    }
    
    NSDictionary *params = @{
                             @"jid":[AXPUserInformation sharedInformation].jid,
                             @"appId":@"4",
                             @"userType":userType
                             };
    
    [[ETTNetworkAixueManager sharedInstance]POST:urlString Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        ETTLog(@"获取token");
        if (error) {
            ETTLog(@"%@",error);
        } else {
            NSNumber *result   = [responseDictionary objectForKey:@"result"];
            if ([result isEqual:@1]) {
            NSDictionary *data = [responseDictionary objectForKey:@"data"];
            self.token         = [data objectForKey:@"token"];
            }
        }
        
    }];
    
}

//设置左侧弹出菜单
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    
    UIView *leftView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label      = [[UILabel alloc]init];
    label.textColor     = [UIColor whiteColor];
    label.font          = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentLeft;
    label.frame         = CGRectMake(42+5-10, 7, 75, 30);
    label.text          = @"更多";
    
    //左侧菜单按钮
    UIButton *menuButton                  = [UIButton new];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_default"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateHighlighted];
    menuButton.frame                      = CGRectMake(-10, 2, 42, 41);

    [menuButton addTarget:self action:@selector(menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:label];
    [leftView addSubview:menuButton];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    
}

//设置子控件
- (void)setupSubview {
    
    UIImageView *backgroundImageView           = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.image                  = [UIImage imageNamed:@"course_list_background"];
    [self.view addSubview:backgroundImageView];
    
    //爱学
    ETTLCAButton *aixueButton            = [[ETTLCAButton alloc]init];
    [aixueButton setTitle:@"爱学" forState:UIControlStateNormal];
    
    /**
     *  @author LiuChuanan, 17-03-24 10:12:57
     *  
     *  @brief 把更多页面,跳转爱学的图标替换
     *
     *
     *  @since 
     */
    [aixueButton setImage:[UIImage imageNamed:@"aixue_logo"] forState:UIControlStateNormal];
    [aixueButton setTitleColor:kF2_COLOR forState:UIControlStateNormal];
    aixueButton.titleLabel.font          = [UIFont systemFontOfSize:16.0];
    aixueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    aixueButton.imageRect                = CGRectMake(0, 0, (130.0 / 1024) * k_MAINSCREEN_WIDTH, (120.0 / 768) * k_MAINSCREEN_HEIGHT);
    aixueButton.titleRect                = CGRectMake(0, (132.0 / 768) * k_MAINSCREEN_HEIGHT, (130.0 / 1024) * k_MAINSCREEN_WIDTH, (30.0 / 768) * k_MAINSCREEN_HEIGHT);
    CGFloat aixueButtonX                 = (55.0 / 1024) * k_MAINSCREEN_WIDTH;
    CGFloat aixueButtonY                 = (55.0 / 768) * k_MAINSCREEN_HEIGHT;
    CGFloat aixueButtonWidth             = (130.0 / 1024) * k_MAINSCREEN_WIDTH;
    CGFloat aixueButtonHeight            = (162.0 / 768) * k_MAINSCREEN_HEIGHT;
    aixueButton.frame                    = CGRectMake(aixueButtonX, aixueButtonY, aixueButtonWidth, aixueButtonHeight);
    [aixueButton addTarget:self action:@selector(aixueButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:aixueButton];
    
    //爱学课堂
    ETTLCAButton *aixueClassButton            = [[ETTLCAButton alloc]init];
    [aixueClassButton setTitle:@"爱学课堂" forState:UIControlStateNormal];
    [aixueClassButton setImage:[UIImage imageNamed:@"aixue_class"] forState:UIControlStateNormal];
    [aixueClassButton setTitleColor:kF2_COLOR forState:UIControlStateNormal];
    aixueClassButton.titleLabel.font          = [UIFont systemFontOfSize:16.0];
    aixueClassButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    aixueClassButton.imageRect                = CGRectMake(0, 0, (130.0 / 1024) * k_MAINSCREEN_WIDTH, (120.0 / 768) * k_MAINSCREEN_HEIGHT);
    aixueClassButton.titleRect                = CGRectMake(0, (132.0 / 768) * k_MAINSCREEN_HEIGHT, (130.0 / 1024) * k_MAINSCREEN_WIDTH, (30.0 / 768) * k_MAINSCREEN_HEIGHT);
    CGFloat aixueClassButtonX                 = CGRectGetMaxX(aixueButton.frame) + (68.0 / 1024) * k_MAINSCREEN_WIDTH;
    CGFloat aixueClassButtonY                 = aixueButton.y;
    CGFloat aixueClassButtonWidth             = aixueButton.width;
    CGFloat aixueClassButtonHeight            = aixueButton.height;
    aixueClassButton.frame                    = CGRectMake(aixueClassButtonX, aixueClassButtonY, aixueClassButtonWidth, aixueClassButtonHeight);
    [aixueClassButton addTarget:self action:@selector(aixueClassButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:aixueClassButton];
    
}

//爱学按钮的点击事件方法
- (void)aixueButtonDidClick:(ETTLCAButton *)button {

    NSString *urlString = [NSString stringWithFormat:GET_TOKEN];

    NSString *userType = [AXPUserInformation sharedInformation].userType;
    if ([userType isEqualToString:@"teacher"]) {
        userType = @"1";
    }
    
    NSDictionary *params = @{
                             @"jid":[AXPUserInformation sharedInformation].jid,
                             @"appId":@"4",
                             @"userType":userType
                             };
    
    [[ETTNetworkAixueManager sharedInstance]POST:urlString Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        /**
         *  @author LiuChuanan, 17-04-11 16:42:57
         *  
         *  @brief 网络问题/无法获得token 提示
         *
         *  branch origin/bugfix/AIXUEPAIOS-1199
         *   
         *  Epic   origin/bugfix/Epic-0411-AIXUEPAIOS-1176
         * 
         *  @since 
         */
        if (error) {
            ETTLog(@"%@",error);
            [self cannotGetTokenAlert];
        } else {
            NSNumber *result = [responseDictionary objectForKey:@"result"];
            if ([result isEqual:@1]) {
                NSDictionary *data = [responseDictionary objectForKey:@"data"];
                self.token = [data objectForKey:@"token"];
                
                if (self.token) {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"aixuepaiToAixueScheme://%@+%@",self.token,[AXPUserInformation sharedInformation].jid]];
                    
                    ETTLog(@"%@",url);
                    
                    BOOL canOpen = [[UIApplication sharedApplication]canOpenURL:url];
                    if (canOpen) {
                        [[UIApplication sharedApplication]openURL:url];
                    } else {
                        [self addAlertController];
                    }
                } else
                {
                    [self cannotGetTokenAlert];
                }
            }
        }
        
    }];
}

//alertcontroller
- (void)addAlertController {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备中暂无此应用,请前往应用商店下载?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = [NSString stringWithFormat: 
                         @"https://itunes.apple.com/cn/app/ai-xue/id915711237?mt=8"];  
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:alertAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

/**
 *  @author LiuChuanan, 17-04-11 16:42:57
 *  
 *  @brief 网络问题/无法获得token 提示
 *
 *  branch origin/bugfix/AIXUEPAIOS-1199
 *   
 *  Epic   origin/bugfix/Epic-0411-AIXUEPAIOS-1176
 * 
 *  @since 
 */
- (void)cannotGetTokenAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络有异常,请您待会重试" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    //预留  2秒让alert自己消失
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //[alertController dismissViewControllerAnimated:YES completion:nil];
        
    //});
}

//爱学课堂的事件点击方法
- (void)aixueClassButtonDidClick:(ETTLCAButton *)button {
    
    
    NSString *urlString = [NSString stringWithFormat:GET_TOKEN];
    
    NSString *userType = [AXPUserInformation sharedInformation].userType;
    if ([userType isEqualToString:@"teacher"]) {
        userType = @"1";
    }
    
    NSDictionary *params = @{
                             @"jid":[AXPUserInformation sharedInformation].jid,
                             @"appId":@"4",
                             @"userType":userType
                             };
    
    [[ETTNetworkAixueManager sharedInstance]POST:urlString Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        /**
         *  @author LiuChuanan, 17-04-11 16:42:57
         *  
         *  @brief 网络问题/无法获得token 提示
         *
         *  branch origin/bugfix/AIXUEPAIOS-1199
         *   
         *  Epic   origin/bugfix/Epic-0411-AIXUEPAIOS-1176
         * 
         *  @since 
         */
        if (error) {
            ETTLog(@"%@",error);
            [self cannotGetTokenAlert];
        } else {
            NSNumber *result = [responseDictionary objectForKey:@"result"];
            if ([result isEqual:@1]) {
                NSDictionary *data = [responseDictionary objectForKey:@"data"];
                self.token = [data objectForKey:@"token"];
                
                if (self.token && [AXPUserInformation sharedInformation].netClassUrl) {
                    ETTSafariViewController *safariViewController = [[ETTSafariViewController alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@",[AXPUserInformation sharedInformation].netClassUrl,self.token]]];
                    safariViewController.delegate                 = self;
                    safariViewController.navigationItem.title     = @"爱学课堂";
                    [self.navigationController pushViewController:safariViewController animated:YES];

                } else
                {
                    [self cannotGetTokenAlert];
                }
                
            }
        }
        
    }];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    
    /**
     *  @author LiuChuanan, 17-03-23 11:02:57
     *  
     *  @brief 点击完成按钮后,返回到更多页面
     *
     *
     *  @since 
     */
    
    [self.navigationController popViewControllerAnimated:YES];
}


//左边我的课程菜单
- (void)menuButtonDidClick {
    
    [[ETTSideNavigationManager sharedSideNavigationManager]changeNavigaitonsStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
