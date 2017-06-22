//
//  AXPCheckOriginalSubjectView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPCheckOriginalSubjectView.h"
#import "AXPWhiteboardPromptView.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import "ETTImageManager.h"
#import "ETTScenePorter.h"
@interface AXPCheckOriginalSubjectView ()

@property(nonatomic ) BOOL canClosed;

@property(nonatomic ,copy) currentPushStateBlock currentStateHandle;

@property(nonatomic ,copy) NSString *answerImageUrl;
@property(nonatomic ,copy) NSString *commentImageUrl;

@end


@implementation AXPCheckOriginalSubjectView

-(void)showPromptWithStr:(NSString *)promptStr
{
    if ([self.subviews.lastObject isKindOfClass:[AXPWhiteboardPromptView class]]) {
        
        AXPWhiteboardPromptView *promptView = self.subviews.lastObject;
        [promptView removeFromSuperview];
    }
    
    AXPWhiteboardPromptView *promptView = [[AXPWhiteboardPromptView alloc] initWithPromptStr:promptStr];

    promptView.frame                    = CGRectMake(0, 0, kAXPWhiteboardPromptW, kAXPWhiteboardPromptH);

    promptView.center                   = CGPointMake(kWIDTH/2,0);
    
    [self addSubview:promptView];
    [self bringSubviewToFront:promptView];
    
    [UIView animateWithDuration:0.5 animations:^{
        //
        promptView.center = CGPointMake(kWIDTH/2, 8+47/2);
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
            [UIView animateWithDuration:0.5 animations:^{
                //
                promptView.center = CGPointMake(kWIDTH/2, 0);
                
            } completion:^(BOOL finished) {
                //
                [promptView removeFromSuperview];
            }];
        });
    }];
}

+(instancetype)showPushingImage:(UIImage *)image currentPushState:(currentPushStateBlock)pushState
{
    AXPCheckOriginalSubjectView *originView = [self createShowViewWithImage:image];
    
    originView.currentStateHandle = pushState;
    
    return originView;
}

+(instancetype)showOriginSubjectImage:(UIImage *)image canClosed:(BOOL)canClosed
{
    AXPCheckOriginalSubjectView *originView = [self createShowViewWithImage:image];
    
    originView.canClosed = canClosed;
    
    return originView;
}

+(instancetype)showPaperAnswerImageWithUrlString:(NSString *)imageUrl
{
    AXPCheckOriginalSubjectView *originView = [[AXPCheckOriginalSubjectView alloc] init];

    [originView downloadAndShowImageWithUrlStr:imageUrl];

    originView.backgroundColor              = [UIColor whiteColor];

    originView.frame                        = CGRectMake(0, 0, kWIDTH, kHEIGHT);

    originView.answerImageUrl               = imageUrl;

    NSArray *array                          = [imageUrl componentsSeparatedByString:@".png"];

    originView.commentImageUrl              = [NSString stringWithFormat:@"%@_p.png",array.firstObject];

    originView.canClosed                    = YES;

    [originView addCheckCommentOrAnswerImageButton];
    
    return originView;
}

-(void)downloadAndShowImageWithUrlStr:(NSString *)urlStr
{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if (image) {
                
                UIImage *smallImage = [ETTImageManager drawSmallImageWithOriginImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT)];
                
                self.imageView                        = [[UIImageView alloc] initWithImage:smallImage];

                self.imageView.center                 = self.center;

                self.imageView.userInteractionEnabled = YES;
                
                [self insertSubview:self.imageView belowSubview:self.checkCommentOrAnswerButton];
            }
        });
    }];
}



// 查看批阅或者查看作答按钮
-(void)addCheckCommentOrAnswerImageButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"查看批阅" forState:UIControlStateNormal];
    [button setTitle:@"查看批阅" forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    button.backgroundColor = kAXPMAINCOLORc12;
    
    [button addTarget:self action:@selector(checkCommentOrAnswerImage:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(kWIDTH - 116 + 10, 100, 116, 37);
    
    button.layer.cornerRadius = 5;
    
    self.checkCommentOrAnswerButton = button;
    
    [self addSubview:button];
}

-(void)checkCommentOrAnswerImage:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"查看批阅"]) {
    
        [button setTitle:@"学生作答" forState:UIControlStateNormal];
        [button setTitle:@"学生作答" forState:UIControlStateHighlighted];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.commentImageUrl]];
        
    }else if([button.currentTitle isEqualToString:@"学生作答"])
    {
        [button setTitle:@"查看批阅" forState:UIControlStateNormal];
        [button setTitle:@"查看批阅" forState:UIControlStateHighlighted];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.answerImageUrl]];
    }
}


+(instancetype)createShowViewWithImage:(UIImage *)image
{
    AXPCheckOriginalSubjectView *originView = [[AXPCheckOriginalSubjectView alloc] init];
    
    originView.backgroundColor                  = [UIColor whiteColor];

    originView.frame                            = CGRectMake(0, 0, kWIDTH, kHEIGHT);

    UIImage *smallImage                         = [ETTImageManager drawSmallImageWithOriginImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT)];

    originView.imageView                        = [[UIImageView alloc] initWithImage:smallImage];

    originView.imageView.center                 = originView.center;

    originView.imageView.userInteractionEnabled = YES;
    
    [originView addSubview:originView.imageView];
    
    return originView;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.canClosed) { // 允许关闭
    
        ////////////////////////////////////////////////////////
        /*
         new      : Modify
         time     : 2017.3.17  14:01
         modifier : 康晓光
         version  ：Epic_0314_AIXUEPAIOS-1068
         branch   ：AIXUEPAIOS-1008
         describe :  白板互批后，点击查看原题和查看学生作答，需要点击两次，且最后一次页面的内容显示的是上次的推送信息 2倍
         */
        //[self removeFromSuperview];
        [self closeSelfView];
        /////////////////////////////////////////////////////
        
    }else // 不允许关闭
    {
        if (self.currentStateHandle) { // 判断当前推送状态
            
            NSString *currentState = self.currentStateHandle();
            
            // 如果当前推送状态是白板答案或者白板批阅的推送中,不允许自己手动关闭
            if ([currentState isEqualToString:@"21"] || [currentState isEqualToString:@"22"] || [currentState isEqualToString:@"24"] || [currentState isEqualToString:@"25"]) {
                
                [self showPromptWithStr:@"正在推送中..."];
                
            }else // 如果学生答题/批阅图片已经推送结束,可以手动关闭.
            {
                
                ////////////////////////////////////////////////////////
                /*
                 new      : Modify
                 time     : 2017.3.17  14:01
                 modifier : 康晓光
                 version  ：Epic_0314_AIXUEPAIOS-1068
                 branch   ：AIXUEPAIOS-1008
                 describe :  白板互批后，点击查看原题和查看学生作答，需要点击两次，且最后一次页面的内容显示的是上次的推送信息 2倍
                 */
                //[self removeFromSuperview];
                [self closeSelfView];
                /////////////////////////////////////////////////////
            }
        }else
        {
            ////////////////////////////////////////////////////////
            /*
             new      : Modify
             time     : 2017.3.17  14:01
             modifier : 康晓光
             version  ：Epic_0314_AIXUEPAIOS-1068
             branch   ：AIXUEPAIOS-1008
             describe :  白板互批后，点击查看原题和查看学生作答，需要点击两次，且最后一次页面的内容显示的是上次的推送信息 2倍
             */
             //[self removeFromSuperview];
            [self closeSelfView];
            /////////////////////////////////////////////////////
           
        }
    }
}

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.3.17  14:01
 modifier : 康晓光
 version  ：Epic_0314_AIXUEPAIOS-1068
 branch   ：AIXUEPAIOS-1008
 describe :  白板互批后，点击查看原题和查看学生作答，需要点击两次，且最后一次页面的内容显示的是上次的推送信息 2倍
 */

-(void)closeSelfView
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.20  14:41
     modifier : 康晓光
     version  ：Epic_0314_AIXUEPAIOS-1068
     branch   ：AIXUEPAIOS-1008
     describe :  白板互批后，点击查看原题和查看学生作答，需要点击两次，且最后一次页面的内容显示的是上次的推送信息 2倍  2017.3.17 修改后 产看原题不是原题图片
     if ([[ETTScenePorter shareScenePorter].EDViewRecordManager viewHadRecord:NSStringFromClass([AXPCheckOriginalSubjectView class])])
     {
     [[ETTScenePorter shareScenePorter].EDViewRecordManager  undoRecores:NSStringFromClass([AXPCheckOriginalSubjectView class])];
     }
     */

    [self removeFromSuperview];
}

/////////////////////////////////////////////////////
@end
