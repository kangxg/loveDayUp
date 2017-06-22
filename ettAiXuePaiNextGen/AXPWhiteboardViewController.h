//
//  AXPWhiteboardViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"
#import "ETTUSERDefaultManager.h"

typedef void(^studentRespondImage)(UIImage *resondImage);

@interface AXPWhiteboardViewController : ETTViewController

@property(nonatomic ) NSInteger currentIndex;

@property(nonatomic ,strong) UIViewController *topVc;

@property(nonatomic ,strong) UIButton *menuButton;

-(void)studentGetClassMessage:(NSDictionary *)classMessage;

// 学生白板/试卷主观题作答
@property(nonatomic ,copy) NSString *currentRespondImageUrlStr;

-(void)addWhiteboardImageToPaperWithPaperImageHandle:(studentRespondImage)paperImageHandle;

@end
