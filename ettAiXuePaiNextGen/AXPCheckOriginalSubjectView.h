//
//  AXPCheckOriginalSubjectView.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"

typedef NSString *(^currentPushStateBlock)();

@interface AXPCheckOriginalSubjectView : ETTView

@property(nonatomic ,strong) UIButton *checkCommentOrAnswerButton;

@property(nonatomic ,strong) UIImageView *imageView;

+(instancetype)showOriginSubjectImage:(UIImage *)image canClosed:(BOOL)canClosed;

+(instancetype)showPushingImage:(UIImage *)image currentPushState:(currentPushStateBlock)pushState;

+(instancetype)showPaperAnswerImageWithUrlString:(NSString *)imageUrl;

@end
