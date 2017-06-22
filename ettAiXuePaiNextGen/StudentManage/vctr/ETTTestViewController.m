
//
//  ETTTestViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/1.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTestViewController.h"
#import "AppDelegate.h"
#import "ETTSideNavigationViewController.h"
#import "ETTLoginViewController.h"

@interface ETTTestViewController ()

@end

@implementation ETTTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame     = CGRectMake(200, 200, 200,200);
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(showReaderViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)showReaderViewController {
    
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;

    ETTSideNavigationViewController *rootVc = (ETTSideNavigationViewController *)appDele.window.rootViewController;
    
    [rootVc presentViewControllerToIndex:1 title:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
