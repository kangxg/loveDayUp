//
//  ETTAboutView.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 2017/3/27.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTAboutView.h"
#import "UIView+DDAddition.h"

@implementation ETTAboutView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 60)];
    topLabel.font = [UIFont boldSystemFontOfSize:20];
    topLabel.backgroundColor = [UIColor whiteColor];
    topLabel.text = @"爱学派";
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:topLabel];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    topLabel.layer.mask = maskLayer;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, topLabel.height-0.5, topLabel.width, 0.5)];
    line.backgroundColor = kAXPTEXTCOLORf3;
    [topLabel addSubview:line];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-50)/2, topLabel.bottom + 20, 70, 70)];
    img.image = [UIImage imageNamed:@"爱学派logo"];
    [self addSubview:img];
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom + 10, 150, 20)];
    versionLabel.centerX = img.centerX;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:10];
    versionLabel.textColor = kAXPTEXTCOLORf3;
    NSDictionary *currentDic = [[NSBundle mainBundle] infoDictionary];
    // 当前使用的版本
    NSString *currentVersion = [currentDic objectForKey:@"CFBundleShortVersionString"];
    NSString *cfBundleVersion = [currentDic objectForKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"V%@(%@)",currentVersion,cfBundleVersion];
    [self addSubview:versionLabel];
    
    // 一大段描述
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, versionLabel.bottom + 15, self.width - 60, 230)];
    describeLabel.font = [UIFont systemFontOfSize:17];
    describeLabel.numberOfLines = 0;
    describeLabel.textColor = kAXPTEXTCOLORf2;
    describeLabel.text = @"爱学派是一款在线课堂同步教学软件，系统中配有海量的教学资源来满足教师的个性化教学需求。教师通过随堂测试、在线提问等方式快速了解每个学生目前课堂的学习情况，并对其进行针对性讲解。系统对学生提交的随堂答案自动打分，省略了收卷、判卷和人工统计等步骤便能够对学生近期表现进行整体把控，系统配置课程表现奖励机制,在给学生一种“人人都有参与感”的感觉之外激发学生的学习热情。";
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    CGFloat emptylen = describeLabel.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 8.0f;//行间距
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:describeLabel.text attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    describeLabel.attributedText = attrText;
    [self addSubview:describeLabel];
    
    // 网址
    UIButton *webButton = [UIButton buttonWithType:UIButtonTypeCustom];
    webButton.frame = CGRectMake((self.width - 200)/2, describeLabel.bottom + 30, 200, 25);
    [webButton setTitleColor:kAXPMAINCOLORc1 forState:UIControlStateNormal];
    [webButton setTitle:@"www.etiantian.com" forState:UIControlStateNormal];
    [webButton addTarget:self action:@selector(webClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:webButton];
    
    // 电话
    UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telButton.frame = CGRectMake((self.width - 180)/2, webButton.bottom + 15, 180, 20);
    [telButton setTitleColor:kAXPMAINCOLORc1 forState:UIControlStateNormal];
    [telButton setTitle:@"400-661-6666" forState:UIControlStateNormal];
    [self addSubview:telButton];
    
    
    // 版权描述
    UILabel *copyrightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 40, self.width, 20)];
    copyrightLabel.textColor = kAXPTEXTCOLORf3;
    copyrightLabel.font = [UIFont systemFontOfSize:9];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.text = @"Copyright@2017 北京龙之门教育集团";
    [self addSubview:copyrightLabel];
    
}

- (void)webClick:(UIButton *)button{
    NSURL *requestURL = [[NSURL alloc] initWithString:@"http://www.etiantian.com/"];
    [[UIApplication sharedApplication] openURL:requestURL];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
