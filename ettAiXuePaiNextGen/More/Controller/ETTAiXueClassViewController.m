//
//  ETTAiXueClassViewController.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTAiXueClassViewController.h"
#import <WebKit/WebKit.h>

@interface ETTAiXueClassViewController ()

@end

@implementation ETTAiXueClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupNavBar];
    [self setupSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubview {
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 30)];
    [self.view addSubview:webView];
    
    if (self.aixueClassUrl) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.aixueClassUrl]]];
    }
}

- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    self.navigationItem.title  = @"爱学课堂";

    //左边返回试卷列表按钮 pop上个控制器
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

- (void)backButtonDidClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
