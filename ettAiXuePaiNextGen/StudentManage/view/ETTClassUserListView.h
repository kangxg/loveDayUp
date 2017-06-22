//
//  ETTClassUserListView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
//学生管理 右侧 学生列表视图展示
#import "ETTView.h"
#import "ETTCollectionView.h"
#import "ETTNoStudentView.h"
@interface ETTClassUserListView : ETTView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)ETTCollectionView     *  EVCollectionView;
@property (nonatomic,retain)NSArray              *  EVDataArr;
@property (nonatomic,retain)ETTNoStudentView     *  EVNOStuView;
@property (nonatomic,assign)BOOL                    EVIsLockView;
-(void)createCollectionView;
-(void)reginCollectionHeadView;
-(void)reginCollectCell;
-(void)reloadView:(NSArray *)modelArr ;
-(void)reloadView:(NSArray *)modelArr lockScreen:(BOOL )isLockScreen;
-(void)reloadViewWithObject:(id)Object;
-(void)reloadViewWithObject:(id)Object lockScreen:(BOOL )isLockScreen;

-(void)createNostuView;
-(void)removeNostuview;



@end

@interface ETTOnlineClassUserListView :  ETTClassUserListView

@end

@interface ETTEstablishClassUserListView :  ETTClassUserListView

@end
@interface ETTEattendClassUserListView :  ETTClassUserListView

@end
