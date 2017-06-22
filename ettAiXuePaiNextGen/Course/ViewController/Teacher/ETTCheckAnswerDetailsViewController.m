//
//  ETTCheckAnswerDetailsViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCheckAnswerDetailsViewController.h"
#import "ETTStudentAnswerListView.h"
#import "AXPStudentAnswerListCollectionViewCell.h"
#import "AXPStudentSubjectViewController.h"
#import <UIImageView+WebCache.h>
#import "AXPRedisManager.h"
#import "AXPUserInformation.h"
#import "AXPWhiteboardViewController.h"
#import "AXPRedisSendMsg.h"
#import "ETTImageManager.h"
#import "AXPGetRootVcTool.h"
#import "ETTCoursewarePresentViewControllerManager.h"

@interface ETTCheckAnswerDetailsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UIButton                 *leftBackButton;

@property (nonatomic ,strong) UIButton                 *rightCommentButton;

@property (nonatomic        ) BOOL                     isMarkScore;

@property (nonatomic ,strong) NSMutableArray           *answerList;

@property (nonatomic ,strong) NSMutableArray           *scoreList;

@property (nonatomic ,strong) NSMutableDictionary      *scoreDict;

@property (nonatomic ,strong) ETTStudentAnswerListView *answerListView;

@property (nonatomic ,strong) NSMutableDictionary      *classroomDict;

@property (nonatomic ,strong) NSTimer                  *getStudentScoreTimer;

#pragma 修改主观题互批
@property (copy, nonatomic  ) NSString                 *itemId;//	主观题标识

@property (assign, nonatomic) BOOL isMarked;//是否互批

@end

@implementation ETTCheckAnswerDetailsViewController


/**
 主观题互批初始化方法 参数从107传过来的

 @param answerData <#answerData description#>
 @param classroomDict <#classroomDict description#>
 @return <#return value description#>
 */
-(instancetype)initWithAnswerData:(NSDictionary *)answerData classroomDict:(NSDictionary *)classroomDict
{
    self = [super init];
    
    if (self) {
    
        NSDictionary *data        = answerData[@"data"];
        NSArray *answerList       = data[@"answerList"];
        self.answerList           = answerList.mutableCopy;
        self.scoreList            = answerList.mutableCopy;

        self.classroomDict        = classroomDict.mutableCopy;

        self.itemId               = [data objectForKey:@"itemId"];

        NSDictionary *answerFirst = [answerList firstObject];
        NSDictionary *answerLast  = [answerList lastObject];
        NSString *markJid;
        
        /** 判断课堂重连有没有互批 下面是样例数组中元素
            
         <__NSArrayM 0x17164f6f0>(
         
         元素字典  first1
         {
         answerImgUrl = "http://10.20.30.254/ettschoolmitm/mitm2ettschool/localok//50043_20170112_3162002_1484192970652.png";
         userId = 3162002;
         userName = DL98;
         userPhoto = "http://attach.etiantian.com/ett20/study/common/upload/axpad_unknown.png";
         },
         
         元素字典  last2
         {
         answerImgUrl = "http://10.20.30.254/ettschoolmitm/mitm2ettschool/localok//50043_20170112_3161997_1484192967640.png";
         markJid = 3162002;
         markName = DL98;
         markPoint = 5;
         userId = 3161997;
         userName = DL93;
         userPhoto = "http://attach.etiantian.com/ett20/study/common/upload/axpad_unknown.png";
         }
            
        */
        if (answerFirst.count >= answerLast.count) {
            markJid = [answerFirst objectForKey:@"markJid"];
        } else {
            
            markJid = [answerLast objectForKey:@"markJid"];
        }
        
        CGSize itemSize;
            //没有互批
        if ([markJid isEqualToString:@""] || !markJid) {
            self.isMarkScore = NO;
            itemSize = CGSizeMake(220, 235);
        } else {
            //已经互批
            self.isMarkScore = YES;
            self.isMarked    = YES;
            itemSize         = CGSizeMake(220, 248);
        }
        
        /**
            更改部分
        */
        [self setUpPaperCheckDetailNavagationBar];
        
        /**
            设置collectionView
        */
        
        [self addStudentAnswerListViewWithItemSize:itemSize];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
        老师开始接收学生批阅信息
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherGetStudentPaperCommentInfo:) name:kREDIS_COMMAND_TYPE_SWB_04 object:nil];
}

/**
 老师开始接收学生批阅信息
 */
-(void)teacherGetStudentPaperCommentInfo:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    [self getStudentPTCommentData:userInfo];
}

-(void)getStudentPTCommentData:(NSDictionary *)scoreDict
{
    // 在作答列表数据中增加互批(打分)数据.
    [self.answerList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableDictionary *answerDict = dict.mutableCopy;
        
        [scoreDict enumerateKeysAndObjectsUsingBlock:^(NSString *jid, NSDictionary *pointDict, BOOL * _Nonnull stop) {
                        
            if ([jid isEqualToString:answerDict[kmarkJid]]) {
                
                [answerDict setObject:pointDict[kpoint] forKey:kmarkPoint];
                [answerDict setObject:pointDict[kPaperCommentImg] forKey:kPaperCommentImg];
                
                /**更改部分
                    增加字段itemId
                    
                */
                [answerDict setObject:self.itemId forKey:@"itemId"];
                
                
                [self.scoreList addObject:answerDict];
                
                *stop = YES;
            }
        }];
    }];
    
    if (self.scoreList.count > 0) {
        [self changeStatuesWhenGetStudentAnswers];
    }
    
    /**
     更改部分
     获得学生批阅信息后更改状态
     */
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    ETTLog(@"%@",self.scoreList);
    
    
    NSMutableArray *markArray = [NSMutableArray array];
    
    NSDictionary *dic = [self.scoreList firstObject];
    
    if (self.scoreList.count > 0 && self.isMarkScore && [dic objectForKey:@"itemId"]) {
        
        for (NSDictionary *dict in self.scoreList) {
            NSMutableDictionary *markDict = [NSMutableDictionary dictionary];
            
            [markDict setObject:[dict objectForKey:@"itemId"] forKey:@"itemId"];
            [markDict setObject:[dict objectForKey:@"userId"] forKey:@"jid"];
            [markDict setObject:[dict objectForKey:@"markJid"] forKey:@"markJid"];
            [markDict setObject:[dict objectForKey:@"markName"] forKey:@"markName"];
            [markDict setObject:[dict objectForKey:@"markPoint"] forKey:@"markPoint"];
            
            [markArray addObject:markDict];
        }
        
        
        /**更改部分
         提交学生批阅信息
         */
        [ETTCoursewarePresentViewControllerManager sharedManager].markArray = markArray;
    }
        
    
    ETTLog(@"%@",markArray);
    
    
}

//初始化进来后的式样
-(void)addStudentAnswerListViewWithItemSize:(CGSize)itemSize
{
    [self.answerListView removeFromSuperview];

    ETTStudentAnswerListView *answerListView                     = [[ETTStudentAnswerListView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT - 64)];
    self.answerListView                                          = answerListView;
    [self.view addSubview:answerListView];

    UICollectionViewFlowLayout *layout                           = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset                                          = UIEdgeInsetsMake(38, 30, 30, 28);
    layout.minimumLineSpacing                                    = 30;

    layout.itemSize                                              = itemSize;

    // 显示学生作答界面
    AXPStudentAnswerListCollectionView *answerListCollectionView = [[AXPStudentAnswerListCollectionView alloc] initWithFrame:answerListView.frame collectionViewLayout:layout];

    [answerListCollectionView registerClass:[AXPStudentAnswerListCollectionViewCell class] forCellWithReuseIdentifier:@"axpStudentAnswerListCollectionViewCell"];

    answerListCollectionView.delegate                            = self;
    answerListCollectionView.dataSource                          = self;

    answerListView.answerListCollectionView                      = answerListCollectionView;
    [answerListView addSubview:answerListCollectionView];

    answerListView.placeholderView.hidden                        = YES;
    answerListCollectionView.hidden                              = NO;

    [answerListCollectionView reloadData];
}

//手动批阅后collectionView
-(void)afterMarkStudentAnswerListViewWithItemSize:(CGSize)itemSize
{
    [self.answerListView removeFromSuperview];
    
    ETTStudentAnswerListView *answerListView                     = [[ETTStudentAnswerListView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT - 64)];
    self.answerListView                                          = answerListView;
    [self.view addSubview:answerListView];

    UICollectionViewFlowLayout *layout                           = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset                                          = UIEdgeInsetsMake(38, 30, 30, 28);
    layout.minimumLineSpacing                                    = 30;

    layout.itemSize                                              = itemSize;

    // 显示学生作答界面
    AXPStudentAnswerListCollectionView *answerListCollectionView = [[AXPStudentAnswerListCollectionView alloc] initWithFrame:answerListView.frame collectionViewLayout:layout];

    [answerListCollectionView registerClass:[AXPStudentAnswerListCollectionViewCell class] forCellWithReuseIdentifier:@"axpStudentAnswerListCollectionViewCell"];

    answerListCollectionView.delegate                            = self;
    answerListCollectionView.dataSource                          = self;

    answerListView.answerListCollectionView                      = answerListCollectionView;
    [answerListView addSubview:answerListCollectionView];


    answerListView.placeholderView.hidden                        = NO;
    answerListView.explainLabel.text                             = @"暂时无人互批";
    answerListCollectionView.hidden                              = YES;

}

-(void)setUpPaperCheckDetailNavagationBar
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(dismissFromSuperView) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(-16, 0, 50, 44);
    self.leftBackButton = backButton;
    [leftView addSubview:backButton];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    self.rightCommentButton = [self creatNavigationBarButtonWithTitle:@"学生互批"];
    self.rightCommentButton.frame = CGRectMake(16, 2, 90, 41);
    [self.rightCommentButton addTarget:self action:@selector(rightCommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //隐藏学生互批按钮
    //[rightView addSubview:self.rightCommentButton];
    
    /**
    更改部分:
    如果学生作答数组大于2并且目前还没有批阅
    */
    if ([self.classroomDict[@"state"] isEqualToString:@"13"] && self.answerList.count >= 2 && self.isMarkScore == NO) {
        
        self.rightCommentButton.hidden = NO;
    }else
    {
        self.rightCommentButton.hidden = YES;
    }

    UIBarButtonItem *leftBarItem           = [[UIBarButtonItem alloc] initWithCustomView:leftView];

    UIBarButtonItem *rightBarItem          = [[UIBarButtonItem alloc] initWithCustomView:rightView];

    self.navigationItem.leftBarButtonItem  = leftBarItem;
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)studentMutuallyComment:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"学生互批"]) {
        
        //解决教师在分发完互批后，点击返回，再点击查看详情进来后，显示的是学生互批问题
        [self.leftBackButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateNormal];
        
        self.leftBackButton.enabled = NO;
        /**
            没有结束互批之前,返回按钮不可以点击
            
         */
        
        
        // 学生互批
        self.isMarkScore = YES;
        
        /**更改部分
            清空所有之前的数据
        */
        [self.scoreList removeAllObjects];
        
        button.enabled = NO;
        [button setTitle:@"互批结束" forState:UIControlStateNormal];
        [button setTitle:@"互批结束" forState:UIControlStateHighlighted];
        
        // 1. 修改课堂状态为试卷互批状态: state:26
        [self.classroomDict setObject:@"26" forKey:kstate];

        // 分发互批数据. 1->2, 2->3, 3->4, ... 4->1;互批算法
        
        NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
        
        [self.answerList enumerateObjectsUsingBlock:^(NSMutableDictionary *currentDict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *forwardDict,*nextDict;
            
            if (idx == 0) {
                
                forwardDict = self.answerList.lastObject;
            }else
            {
                forwardDict = self.answerList[idx-1];
            }
            
            if (idx == self.answerList.count - 1) {
                
                nextDict = self.answerList.firstObject;
                
            }else
            {
                nextDict = self.answerList[idx + 1];
            }
            
            // 1. 更改白板作答数据表.
            [currentDict setObject:nextDict[kuserName] forKey:kmarkName];
            [currentDict setObject:nextDict[kuserId] forKey:kmarkJid];

            // 2.
            NSString *field = currentDict[kuserId];
            
            
            NSDictionary *markedDict = @{kmarkedJid:forwardDict[kuserId],kmarkedPoint:@"-1",kwbImgUrl:forwardDict[kAnswerImgUrl]};
            
            NSDictionary *mutuallyDict = @{kuserId:currentDict[kuserId],kuserName:currentDict[kuserName],kuserPhoto:currentDict[kuserPhoto],kmarkedBean:markedDict};
            
            NSString *jsonStr = [self getJsonStrWithDict:mutuallyDict];
            
            [commentDict setObject:jsonStr forKey:field];
        }];
        
        /**更改部分
            把作答信息分发给学生
        */
        NSString *redisKey = [NSString stringWithFormat:@"%@%@%@",CACHE_CLASSROOM_MATE_TCH,[AXPUserInformation sharedInformation].classroomId,self.classroomDict[@"pushId"]];
        
        [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict redisValueDict:commentDict type:@"WB_01" redisKey:redisKey successHandle:nil failHandle:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            button.enabled = YES;
        });
        
        //开始获取学生批阅分数
        [self beiganGetStudentMarkScoreData];
        
    }else if ([button.currentTitle isEqualToString:@"互批结束"])
    {   
        /**
            结束互批后恢复返回功能
        */
        self.leftBackButton.enabled = YES;
        [self.leftBackButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
        [self.leftBackButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];

        button.enabled              = NO;
        [button setTitle:@"已结束" forState:UIControlStateNormal];
        button.frame                = CGRectMake(36, 2, 70, 41);

        // 1. 修改课堂状态为试卷互批结束状态: state:27
        [self.classroomDict setObject:@"27" forKey:kstate];

        [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:@"WB_01" successHandle:nil failHandle:nil];
    }
}

/**
    右边按钮的点击事件方法
*/
-(void)rightCommentButtonClick:(UIButton *)button
{
    [self studentMutuallyComment:button];
}

/**
    获得学生批阅信息后更新UI
*/
-(void)beiganGetStudentMarkScoreData
{
    // 创建打分UI
    [self afterMarkStudentAnswerListViewWithItemSize:CGSizeMake(220, 248)];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
    更改部分
    获得学生批阅信息后更改状态
*/
-(void)changeStatuesWhenGetStudentAnswers
{
    self.answerListView.placeholderView.hidden          = YES;//隐藏占位图
    self.answerListView.answerListCollectionView.hidden = NO;//显示collectionView
    [self.answerListView.answerListCollectionView reloadData];//刷新collectionView
}

-(id)getDictWithStr:(NSString *)jsonStr
{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    return dict;
}

-(NSString *)getJsonStrWithDict:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
        
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        return jsonStr;
    }else
    {
        return nil;
    }
}

-(void)dismissFromSuperView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIButton *)creatNavigationBarButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    return button;
}

-(NSMutableArray *)scoreList
{
    if (!_scoreList) {
        _scoreList = [NSMutableArray array];
    }
    return _scoreList;
}

-(void)setCurrentRespondImageUrlStr:(NSString *)urlStr
{
    ETTSideNavigationViewController *rootVc   = [AXPGetRootVcTool getCurrentWindowRootViewController];

    ETTNavigationController *nv               = rootVc.childViewControllers[2];

    AXPWhiteboardViewController *whiteboardVc = (AXPWhiteboardViewController *)nv.topViewController;

    whiteboardVc.currentRespondImageUrlStr    = urlStr;
}

#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AXPPaperStudentSubjectViewController *vc = [[AXPPaperStudentSubjectViewController  alloc] init];
    
    vc.classroomDict = self.classroomDict;
    
    NSDictionary *dict;
    
    if (self.isMarkScore) {
        
        dict                   = self.scoreList[indexPath.item];

        NSString *answerImgUrl = dict[kAnswerImgUrl];//http://10.20.30.254/ettschoolmitm/mitm2ettschool/localok//50043_20170106_3162002_1483673996921.png

        NSString *imageUrl     = answerImgUrl.lastPathComponent;//50043_20170106_3162002_1483673996921.png

        NSArray *array         = [imageUrl componentsSeparatedByString:@"."];

        NSString *imageU       = [array firstObject];

        imageUrl               = [NSString stringWithFormat:@"%@_p.jpg",imageU];//50043_20170106_3162002_1483673996921_p.png

        answerImgUrl           = [answerImgUrl stringByDeletingLastPathComponent];//http://10.20.30.254/ettschoolmitm/mitm2ettschool/localok//

        answerImgUrl           = [NSString stringWithFormat:@"%@//%@",answerImgUrl,imageUrl];
        
        
        [vc.imageView sd_setImageWithURL:[NSURL URLWithString:answerImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //
            UIImage *smallImage = [ETTImageManager drawSmallImageWithOriginImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT-64)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                CGFloat X          = (kWIDTH - smallImage.size.width)/2;
                CGFloat Y          = (kHEIGHT - 64 - smallImage.size.height)/2;

                vc.imageView.frame = CGRectMake(X, Y, smallImage.size.width, smallImage.size.height);
                vc.imageView.image = smallImage;
            });
        }];
        vc.imageUrlStr = answerImgUrl;
        vc.answerJid = dict[kuserId];
        
        [self setCurrentRespondImageUrlStr:dict[kAnswerImgUrl]];
        
    }else
    {
        dict = self.answerList[indexPath.item];
        
        [vc.imageView sd_setImageWithURL:[NSURL URLWithString:dict[kAnswerImgUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
            UIImage *smallImage = [ETTImageManager drawSmallImageWithOriginImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT-64)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                CGFloat X          = (kWIDTH - smallImage.size.width)/2;
                CGFloat Y          = (kHEIGHT - 64 - smallImage.size.height)/2;

                vc.imageView.frame = CGRectMake(X, Y, smallImage.size.width, smallImage.size.height);
                vc.imageView.image = smallImage;
            });
        }];
        vc.imageUrlStr = dict[kAnswerImgUrl];
        vc.answerJid   = dict[kuserId];

    }
    
    vc.title = dict[@"userName"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isMarkScore) {
        
        return self.scoreList.count;
        
    }else
    {
        return self.answerList.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AXPStudentAnswerListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axpStudentAnswerListCollectionViewCell" forIndexPath:indexPath];
    
    //已经批阅过得展示
    if (self.isMarkScore) {
        
        [cell setUpPaperAnswerDetailWithDict:self.scoreList[indexPath.item] isMarkScore:self.isMarkScore];
    }else
    {   //没有批阅的展示
        [cell setUpPaperAnswerDetailWithDict:self.answerList[indexPath.item] isMarkScore:self.isMarkScore];
    }
    
    return cell;
}

@end
