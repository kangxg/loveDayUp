//
//  AXPStudentSubjectViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"

@interface AXPStudentSubjectViewController : ETTViewController

@property(nonatomic ,copy) NSString *answerJid;

@property(nonatomic ,copy) NSString *imageUrlStr;

@property(nonatomic ,strong) NSMutableDictionary *classroomDict;

@property(nonatomic ,strong) UIImageView *imageView;

-(void)pushFinished;

-(void)pushImageToStudentWithSuccessHandle:(void(^)())successHandle failHandle:(void(^)())failHandle;
-(void)originPushFinished;

-(void)sendMessageWithUserInfo:(NSDictionary *)dic withType:(NSString *)type SuccessHandle:(void(^)())successHandle failHandle:(void(^)())failHandle;
@end


@interface AXPPaperStudentSubjectViewController : AXPStudentSubjectViewController

@end
