//
//  ETTRemindTestVCTR.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRemindTestVCTR.h"
#import "ETTRemindManager.h"
@interface ETTRemindTestVCTR ()

@end

@implementation ETTRemindTestVCTR

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"锁屏" forState:UIControlStateNormal];
    btn.frame = CGRectMake(40, 70, 60, 30);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(LockScreenEvenBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor blueColor];
    btn1.frame = CGRectMake(140, 70, 60, 30);
    [self.view addSubview:btn1];
    [btn1 setTitle:@"奖励" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(RewardsEvenBack:) forControlEvents:UIControlEventTouchUpInside];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor blueColor];
    btn1.frame = CGRectMake(210, 70, 60, 30);
    [self.view addSubview:btn1];
    [btn1 setTitle:@"提醒" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(remindEvenBack:) forControlEvents:UIControlEventTouchUpInside];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor blueColor];
    btn1.frame = CGRectMake(280, 70, 60, 30);
    [self.view addSubview:btn1];
    [btn1 setTitle:@"点名" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(rollCallEvenBack:) forControlEvents:UIControlEventTouchUpInside];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor blueColor];
    btn1.frame = CGRectMake(360, 70, 60, 30);
    [self.view addSubview:btn1];
    [btn1 setTitle:@"抢答" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(ResponderEvenBack:
                                          ) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
//锁屏
-(void)LockScreenEvenBack:(UIButton *)btn
{
    if (btn.selected)
    {
        [[ETTRemindManager shareRemindManager]removeRemindView];
    }
    else
    {
         [[ETTRemindManager shareRemindManager]createRemindView:ETTLOCKSCREEViEW];
    }
   
   
}

//奖励
-(void)RewardsEvenBack:(UIButton *)btn
{
    if (btn.selected)
    {
        [[ETTRemindManager shareRemindManager]removeRemindView];
    }
    else
    {
         [[ETTRemindManager shareRemindManager]createRemindView:ETTREWARDSVIEW withCount:2];
    }
//    btn.selected = !btn.selected;
    
}
//提醒
-(void)remindEvenBack:(UIButton *)btn
{
    [[ETTRemindManager shareRemindManager]createRemindView:ETTREMINDVIEW];
}
//奖励
-(void)rollCallEvenBack:(UIButton *)btn
{
     [[ETTRemindManager shareRemindManager]createRemindView:ETTROLLCALLVIEW];
}
//抢答
-(void)ResponderEvenBack:(UIButton *)btn
{
    if (btn.selected)
    {
        [[ETTRemindManager shareRemindManager]removeRemindView];
    }
    else
    {
        [[ETTRemindManager shareRemindManager]createRemindView:ETTRESPONDERVIEW];
    }
//    btn.selected = !btn.selected;
    
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
