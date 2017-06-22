//
//  ETTRedisTestViewController.m
//  ettAiXuePaiNextGen
//
//  Created by zhaiyingwei on 2016/12/12.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTRedisTestViewController.h"
#import "TestTwoViewController.h"
#import "ETTRedisServerManager.h"
#import "ETTRedisServerDelegate.h"
#import "UIView+Toast.h"
CGFloat kBtnWidth = 200.0;
CGFloat kBtnHeight = 100.0;
CGFloat kVSpan = 50.0;
CGFloat kHSpan = 20.0;

@interface ETTRedisTestViewController ()<ETTRedisBasisDelegate>

@property (nonatomic,weak) ETTRedisBasisManager     *redisMananger;
@property (nonatomic,retain)NSMutableDictionary  * homeDic;
@property (nonatomic,assign)BOOL                 haveLookTV;
@end

@implementation ETTRedisTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _haveLookTV = false;
    [self createUI];
    
    _redisMananger = [ETTRedisBasisManager sharedRedisManager];
    [_redisMananger     initWithServerHost:[AXPUserInformation sharedInformation].redisIp port:6379];
    _redisMananger.mDataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)appBecomeActive
{
    NSLog(@"返回前台!");
}

-(void)createUI
{
    UILabel * topTitel       = [[UILabel alloc]init];
    topTitel.text            = @"旧的";
    topTitel.frame           = CGRectMake(10, 20, kSCREEN_WIDTH-20, 20);
    topTitel.backgroundColor = [UIColor whiteColor];
    topTitel.textColor       = [UIColor redColor];
    topTitel.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:topTitel];

    UIButton *cBtn           = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cBtn setFrame:CGRectMake(kHSpan, kVSpan, kBtnWidth, kBtnHeight)];
    [cBtn setTitle:@"链接" forState:UIControlStateNormal];
    [cBtn setBackgroundColor:[UIColor yellowColor]];
    [cBtn addTarget:self action:@selector(oncBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cBtn];

    UIButton *dBtn           = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dBtn setFrame:CGRectMake(kHSpan*2+kBtnWidth, kVSpan, kBtnWidth, kBtnHeight)];
    [dBtn setTitle:@"C订阅AA" forState:UIControlStateNormal];
    [dBtn setBackgroundColor:[UIColor yellowColor]];
    [dBtn addTarget:self action:@selector(ondBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dBtn];

    UIButton *tABtn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tABtn setFrame:CGRectMake(kHSpan*3+kBtnWidth*2, kVSpan, kBtnWidth, kBtnHeight)];
    [tABtn setTitle:@"A推送消息" forState:UIControlStateNormal];
    [tABtn setBackgroundColor:[UIColor yellowColor]];
    [tABtn addTarget:self action:@selector(ontABtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tABtn];

    UIButton *taLBtn         = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [taLBtn setFrame:CGRectMake(kHSpan*4+kBtnWidth*3, kVSpan, kBtnWidth, kBtnHeight)];
    [taLBtn setTitle:@"C订阅BB" forState:UIControlStateNormal];
    [taLBtn setBackgroundColor:[UIColor yellowColor]];
    [taLBtn addTarget:self action:@selector(ontaLBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:taLBtn];

    UIButton *wBtn           = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [wBtn setFrame:CGRectMake(kHSpan, kVSpan*2+kBtnHeight, kBtnWidth, kBtnHeight)];
    [wBtn setTitle:@"添加" forState:UIControlStateNormal];
    [wBtn setBackgroundColor:[UIColor yellowColor]];
    [wBtn addTarget:self action:@selector(onwBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wBtn];


    UIButton *Btn            = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Btn setFrame:CGRectMake(kHSpan*2+kBtnWidth, kVSpan*2+kBtnHeight, kBtnWidth, kBtnHeight)];
    [Btn setTitle:@"结束" forState:UIControlStateNormal];
    [Btn setBackgroundColor:[UIColor yellowColor]];
    [Btn addTarget:self action:@selector(oldOver) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
    
    
    [self createNew];
    
    
}

-(void)oldOver{
    [[ETTRedisBasisManager sharedRedisManager]allQuit:^(id value, id error) {
        
    }];
}

-(void)oncBtnHandler:(UIButton *)sender
{
    NSLog(@"oncBtnHandler:");
    [[ETTRedisBasisManager sharedRedisManager]allObjectCreateConnectWithPassword:nil respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"connected was wrong!");
        }else{
            NSLog(@"connected was OK!");
        }
    }];
}

-(void)ondBtnHandler:(UIButton *)sender
{
    NSLog(@"ondBtnHandler:");
    NSArray *arr = @[@"AA"];
    [[ETTRedisBasisManager sharedRedisManager]receivingSubcribtionDataWithObserver:nil channelNameArray:arr respondHandler:^(id value, id error) {
        if (error) {
            //NSLog(@"订阅频道 %@ 失败!",arr);
        }else{
            //NSLog(@"订阅频道 %@ 成功！%@",arr,value);
        }
    } subscribeMessage:^(NSString *message) {
        //NSLog(@"AA订阅监听接收到消息 %@ !!!!",message);
    }];
}

-(void)ontABtnHandler:(UIButton *)sender
{
    NSLog(@"ontABtnHandler:");
    [[ETTRedisBasisManager sharedRedisManager]publishMessageToChannel:@"AA" message:@"WQNMLGB" respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"AA推送消息报错!");
        }else{
            NSLog(@"AA成功推送消息~~%@",value);
        }
    }];
}

-(void)ontaLBtnHandler:(UIButton *)sender
{
    NSLog(@"ontaLBtnHandler:");
    NSArray *arr = @[@"AA",@"BB"];
    [[ETTRedisBasisManager sharedRedisManager]receivingSubcribtionDataWithObserver:nil channelNameArray:arr respondHandler:^(id value, id error) {
        if (error) {
            //NSLog(@"BB订阅频道 %@ 失败!",arr);
        }else{
            //NSLog(@"BB订阅频道 %@ 成功！%@",arr,value);
        }
    } subscribeMessage:^(NSString *message) {
        //NSLog(@"BB订阅监听接收到消息 %@ !!!!",message);
    }];
}

-(void)oncCBtnHandler:(UIButton *)sender
{
    NSLog(@"oncCBtnHandler:");
}

-(void)onwBtnHandler:(UIButton *)sender
{
    NSLog(@"onwBtnHandler:");
    TestTwoViewController *tVC = [[TestTwoViewController alloc]init];
    [self.navigationController pushViewController:tVC animated:YES];
}

-(void)processChannelMessage:(NSString *)message
{
    NSLog(@"processChannelMessage ----> %@",message);
}



-(void)createNew
{
    UILabel * downTitel       = [[UILabel alloc]init];
    downTitel.text            = @"新的";
    downTitel.frame           = CGRectMake(10, kVSpan*2+kBtnHeight *2+20, kSCREEN_WIDTH-20, 20);
    downTitel.backgroundColor = [UIColor whiteColor];
    downTitel.textColor       = [UIColor redColor];
    downTitel.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:downTitel];

    UIButton *cBtn            = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cBtn setFrame:CGRectMake(kHSpan, kVSpan*3+kBtnHeight *2, kBtnWidth, kBtnHeight)];
    [cBtn setTitle:@"链接(新)" forState:UIControlStateNormal];
    [cBtn setBackgroundColor:[UIColor yellowColor]];
    [cBtn addTarget:self action:@selector(newoncBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cBtn];
    UIButton *dBtn            = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dBtn setFrame:CGRectMake(kHSpan*2+kBtnWidth, kVSpan*3+kBtnHeight *2, kBtnWidth, kBtnHeight)];
    [dBtn setTitle:@"订阅频道AAA " forState:UIControlStateNormal];
    [dBtn setBackgroundColor:[UIColor yellowColor]];
    [dBtn addTarget:self action:@selector(newondBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dBtn];

    UIButton *tABtn           = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tABtn setFrame:CGRectMake(kHSpan*3+kBtnWidth*2, kVSpan*3+kBtnHeight *2, kBtnWidth, kBtnHeight)];
    [tABtn setTitle:@"向频道AAA推送消息" forState:UIControlStateNormal];
    [tABtn setBackgroundColor:[UIColor yellowColor]];
    [tABtn addTarget:self action:@selector(newontABtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tABtn];

    UIButton *tABtnc          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tABtnc setFrame:CGRectMake(kHSpan*4+kBtnWidth*3, kVSpan*3+kBtnHeight *2, kBtnWidth, kBtnHeight)];
    [tABtnc setTitle:@"连续向频道AAA推送消息" forState:UIControlStateNormal];
    [tABtnc setBackgroundColor:[UIColor yellowColor]];
    [tABtnc addTarget:self action:@selector(conPushABtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tABtnc];


    UIButton *dBtn11          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dBtn11 setFrame:CGRectMake(kHSpan, kVSpan*4+kBtnHeight *3, kBtnWidth, kBtnHeight)];
    [dBtn11 setTitle:@"订阅频道BBB " forState:UIControlStateNormal];
    [dBtn11 setBackgroundColor:[UIColor yellowColor]];
    [dBtn11 addTarget:self action:@selector(subBBBHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dBtn11];

    UIButton *tABtn12         = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tABtn12 setFrame:CGRectMake(kHSpan*2+kBtnWidth, kVSpan*4+kBtnHeight *3, kBtnWidth, kBtnHeight)];
    [tABtn12 setTitle:@"向频道BBB推送消息" forState:UIControlStateNormal];
    [tABtn12 setBackgroundColor:[UIColor yellowColor]];
    [tABtn12 addTarget:self action:@selector(pubBBBBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tABtn12];


    UIButton *dBtn111         = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dBtn111 setFrame:CGRectMake(kHSpan*3+kBtnWidth*2, kVSpan*4+kBtnHeight *3, kBtnWidth, kBtnHeight)];
    [dBtn111 setTitle:@"订阅频道CCC " forState:UIControlStateNormal];
    [dBtn111 setBackgroundColor:[UIColor yellowColor]];
    [dBtn111 addTarget:self action:@selector(subCCCHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dBtn111];

    UIButton *tABtn121        = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tABtn121 setFrame:CGRectMake(kHSpan*4+kBtnWidth*3, kVSpan*4+kBtnHeight *3, kBtnWidth, kBtnHeight)];
    [tABtn121 setTitle:@"向频道CCC推送消息" forState:UIControlStateNormal];
    [tABtn121 setBackgroundColor:[UIColor yellowColor]];
    [tABtn121 addTarget:self action:@selector(pubCCCtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tABtn121];

    UIButton *Btn2            = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Btn2 setFrame:CGRectMake(kHSpan, kVSpan*5+kBtnHeight *4, kBtnWidth, kBtnHeight)];
    [Btn2 setTitle:@"连续获取在家休息状态" forState:UIControlStateNormal];
    [Btn2 setBackgroundColor:[UIColor yellowColor]];
    [Btn2 addTarget:self action:@selector(ContinuousGetHomeState) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn2];

    UIButton *Btn3            = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Btn3 setFrame:CGRectMake(kHSpan*2 +kBtnWidth, kVSpan*5+kBtnHeight *4, kBtnWidth, kBtnHeight)];
    [Btn3 setTitle:@"连续获取在家信息" forState:UIControlStateNormal];
    [Btn3 setBackgroundColor:[UIColor yellowColor]];
    [Btn3 addTarget:self action:@selector(getHomeState) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn3];


    UIButton *Btn4            = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Btn4 setFrame:CGRectMake(kHSpan*3 +kBtnWidth*2, kVSpan*5+kBtnHeight *4, kBtnWidth, kBtnHeight)];
    [Btn4 setTitle:@"连续设置家的状态" forState:UIControlStateNormal];
    [Btn4 setBackgroundColor:[UIColor yellowColor]];
    [Btn4 addTarget:self action:@selector(ContinuousSetHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn4];

    UIButton *Btn5            = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Btn5 setFrame:CGRectMake(kHSpan*4 +kBtnWidth*3, kVSpan*5+kBtnHeight *4, kBtnWidth, kBtnHeight)];
    [Btn5 setTitle:@"设置家看电视" forState:UIControlStateNormal];
    [Btn5 setBackgroundColor:[UIColor yellowColor]];
    [Btn5 addTarget:self action:@selector(SetHomelookTv) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn5];
}
-(void)lianxupushHomeChannel
{
    [[ETTRedisBasisManager sharedRedisManager] channelPublishMessage:@"AAA" message:@{@"channel":@"AAA",@"state":@"起床了"} intervalTime:5 respondHandler:^(id value, id error) {
        if (error)
        {
            NSLog(@"连续推送数据失败%@",error);
        }
        else
        {
            NSLog(@"连续推送数据成功%@",value);
        }
    }];
}
-(void)testCoder
{
    [[ETTRedisBasisManager sharedRedisManager] redisDataArchiving];
}


#pragma mark --- 设置在家看电视 操作  ----
-(void)SetHomelookTv
{
    _haveLookTV = !_haveLookTV;
    NSString * state = nil;
    if (_haveLookTV)
    {
        state =@"在家看电视看电视";
    }
    else
    {
        state = @"什么都没干！";
    }
    
    NSDictionary * dic = @{@"state":state,@"lookTV":@(_haveLookTV)};
    [[ETTRedisBasisManager sharedRedisManager] redisHMSET:@"homes" dictionary:dic respondHandler:^(id value, id error) {
        
    }];
}

#pragma mark ------连续 set 操作 回调-------
-(void)ContinuousSetOperation
{
    [[ETTRedisBasisManager sharedRedisManager] redisSet:@"ContinuousSet" value:@"就这样操作了" respondHandler:^(id value, id error) {
        if (error == nil)
        {
            NSLog(@"连续set操作成功 %@",value);
        }
        else
        {
            NSError *err = error;
            NSLog(@"连续set操作失败 %@",err.domain);
            
        }
    }];
}

#pragma mark ------连续get操作 回调-------

-(void)ContinuousGetOperation
{
    
    [[ETTRedisBasisManager sharedRedisManager] redisGet:@"ContinuousSet" respondHandler:^(id value, id error) {
        if (error == nil)
        {
            NSLog(@"连续set操作成功 %@",value);
        }
        else
        {
            NSError *err = error;
            NSLog(@"连续Get操作失败 %@",err.domain);
            
        }
        
    }];
    
}
#pragma mark ------连续设置在家状态 回调-------
-(void)ContinuousSetHome
{
    
    NSDictionary * dic = @{@"state":@"无状态",
                           @"lookTV":@(_haveLookTV),
                           @"eat":@"中午吃的盒饭",
                           @"mood":@"亚历山大",
                           @"time":@"2月10日 星期五 下午 15:00",
                           @"feel":@"就这样",
                           @"Indoor":@"good",
                           @"work":@"敲代码",
                           @"nextDay":@"2月11日 星期六",
                           @"nextDayStaus":@"加班",
                           @"state":@"还算顺利",
                           @"music":@"琵琶语",
                           @"want":@"八大处上香",
                           @"speak":@"无语",
                           @"end":@"就到这里了",
                           };
    
    [[ETTRedisBasisManager sharedRedisManager] redisHMSET:@"homes" dictionary:dic type:kREDIS_COMMAND_TYPE_MA_01 intervals:5 respondHandler:^(id value, id error) {
        if (error)
        {
            NSLog(@"连续设置家里情况失败\n");
        }
        else
        {
            NSLog(@"连续设置家里情况成功\n");
        }
        
    }];
    
}
#pragma mark --- 连续 获取在家状态 的所有信息 ---
-(void)getHomeState
{
    [[ETTRedisBasisManager sharedRedisManager]redisHGETALL:@"homes" intervals:5 respondHandler:^(id value, id error) {
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * dic = value;
            NSLog(@"---------------------------------------");
            NSLog(@"连续获取在家的所以状态");
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSLog(@"    key:%@- value%@",key,obj );
                //                 NSLog(@"在家state:%@-lookTv%d",[dic valueForKey:@"state"],[[dic valueForKey:@"lookTV"]boolValue] );
            }];
            NSLog(@"---------------------------------------\n");
            
        }
        else
        {
            NSLog(@"连续获取在家所有信息失败");
        }
        
    }];
    
    
    
}
#pragma mark ------------ 连续获取在家休息状态 ------------
-(void)ContinuousGetHomeState
{
    [[ETTRedisBasisManager sharedRedisManager]redisHGET:@"homes" field:@"state" intervals:5 respondHandler:^(id value, id error) {
        if (error)
        {
            NSLog(@"连续设置在家休息失败state:%@",error);
            
        }
        else
        {
            NSLog(@"**************************************");
            NSLog(@"连续设置在家休息成功state:%@",value);
            NSLog(@"**************************************\n");
        }
        
    }];
    
}
#pragma mark ------------ 结束回调 ------------
-(void)newOver
{
    [[ETTRedisBasisManager sharedRedisManager] allQuit:^(id value, id error) {
        NSLog(@"结束redis");
    }];
}
-(void)newoncBtnHandler:(UIButton *)sender
{
    NSLog(@"newoncBtnHandler:");
    [[ETTRedisBasisManager sharedRedisManager]allObjectCreateConnectWithPassword:nil respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"connected was wrong!");
        }else{
            NSLog(@"connected was OK!");
        }
    }];
}

-(void)newondBtnHandler:(UIButton *)sender
{
    NSLog(@"ondBtnHandler:");
    
    NSArray *arr = @[@"AAA"];
    [[ETTRedisBasisManager sharedRedisManager]receivingSubcribtionDataWithObserver:nil channelNameArray:arr respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"订阅频道 %@ 失败!",arr);
        }else{
            NSLog(@"订阅频道 %@ 成功！%@",arr,value);
        }
    } subscribeMessage:^(NSString *message) {
        //NSLog(@"AAA订阅监听接收到消息 %@ !!!!",message);
    }];
}

-(void)subCCCHandler:(UIButton *)sender
{
    NSLog(@"ontaLBtnHandler:");
    NSArray *arr = @[@"CCC"];
    [[ETTRedisBasisManager sharedRedisManager]receivingSubcribtionDataWithObserver:nil channelNameArray:arr respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"CCC订阅频道 %@ 失败!",arr);
        }else{
            NSLog(@"CCC订阅频道 %@ 成功！%@",arr,value);
        }
    } subscribeMessage:^(NSString *message) {
        //NSLog(@"BBB订阅监听接收到消息 %@ !!!!",message);
    }];
    
}
-(void)pubCCCtnHandler:(UIButton *)sender
{
    NSLog(@"ontABtnHandler:");
    [[ETTRedisBasisManager sharedRedisManager]publishMessageToChannel:@"CCC" message:@"频道CCC推送消息" respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"CCC推送消息报错!");
        }else{
            NSLog(@"成功向频道CCC 推送 家里休息状态~~%@",value);
        }
    }];
}

-(void)subBBBHandler:(UIButton *)sender
{
    NSLog(@"ontaLBtnHandler:");
    NSArray *arr = @[@"AAA",@"BBB"];
    [[ETTRedisBasisManager sharedRedisManager]receivingSubcribtionDataWithObserver:nil channelNameArray:arr respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"BBB订阅频道 %@ 失败!",arr);
        }else{
            NSLog(@"BBB订阅频道 %@ 成功！%@",arr,value);
        }
    } subscribeMessage:^(NSString *message) {
        //NSLog(@"BBB订阅监听接收到消息 %@ !!!!",message);
    }];
    
}
-(void)pubBBBBtnHandler:(UIButton *)sender
{
    NSLog(@"ontABtnHandler:");
    [[ETTRedisBasisManager sharedRedisManager]publishMessageToChannel:@"BBB" message:@"频道BBB推送消息" respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"BBB推送消息报错!");
        }else{
            NSLog(@"成功向频道BBB 推送 家里休息状态~~%@",value);
        }
    }];
}
-(void)newontABtnHandler:(UIButton *)sender
{
    NSLog(@"ontABtnHandler:");
    [[ETTRedisBasisManager sharedRedisManager]publishMessageToChannel:@"AAA" message:@"频道AAA推送消息" respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"AAA推送消息报错!");
        }else{
            NSLog(@"成功向频道AAA 推送 家里休息状态~~%@",value);
        }
    }];
}
-(void)conPushABtnHandler:(UIButton *)sender
{
    [[ETTRedisBasisManager sharedRedisManager] channelPublishMessage:@"AAA" message:@{@"channel":@"AAA",@"state":@"起床了"} intervalTime:5 respondHandler:^(id value, id error) {
        if (error)
        {
            NSLog(@"连续推送数据失败%@",error);
        }
        else
        {
            NSLog(@"连续推送数据成功%@",value);
        }
    }];
}
-(void)newontaLBtnHandler:(UIButton *)sender
{
    NSLog(@"ontaLBtnHandler:");
    NSArray *arr = @[@"AAA"];
    [[ETTRedisBasisManager sharedRedisManager]receivingSubcribtionDataWithObserver:nil channelNameArray:arr respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"接收AAA订阅频道消息 %@ 失败!",arr);
        }else{
            NSLog(@"接收AAA订阅频道消息 %@ 成功！%@",arr,value);
        }
    } subscribeMessage:^(NSString *message) {
        NSLog(@"AAA订阅监听接收到消息 %@ !!!!",message);
    }];
}

-(void)newoncCBtnHandler:(UIButton *)sender
{
    NSLog(@"oncCBtnHandler:");
}
#pragma mark --- 添加操作  ----
-(void)newonwBtnHandler:(UIButton *)sender
{
    NSLog(@"onwBtnHandler:");
    TestTwoViewController *tVC = [[TestTwoViewController alloc]init];
    [self.navigationController pushViewController:tVC animated:YES];
}

-(void)newprocessChannelMessage:(NSString *)message
{
    NSLog(@"processChannelMessage ----> %@",message);
}

@end
