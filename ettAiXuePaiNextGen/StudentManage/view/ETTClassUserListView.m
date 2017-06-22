//
//  ETTClassUserListView.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassUserListView.h"
#import "ETTClasssModel.h"
#import "ETTClassUserListHeaderView.h"
#import "ETTClassUserCell.h"
@implementation ETTClassUserListView
@synthesize EVIsLockView = _EVIsLockView;
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self createCollectionView];
        [self reginCollectionHeadView];
        
    }
    return self;
}

-(void)setEVIsLockView:(BOOL)EVIsLockView
{
    _EVIsLockView = EVIsLockView;
    [self.EVCollectionView reloadData];
}
-(void)createNostuView
{
    if (!self.EVNOStuView.superview)
    {
        [self addSubview:self.EVNOStuView];
    }
}
-(void)removeNostuview
{
    if (self.EVNOStuView.superview)
    {
        [self.EVNOStuView removeFromSuperview];
    }
}

-(ETTNoStudentView *)EVNOStuView
{
    if (_EVNOStuView == nil)
    {
        _EVNOStuView = [[ETTNoStudentView alloc]initWithFrame:self.bounds];
    
    }
    return _EVNOStuView;
}
-(void)createCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing      = 11;
    layout.minimumLineSpacing           = 20;
    layout.sectionInset                 = UIEdgeInsetsMake(23, 41, 0,41 );
    if(_EVCollectionView == nil)
    {
        _EVCollectionView                 = [[ETTCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-24) collectionViewLayout:layout];
        _EVCollectionView.backgroundColor = [UIColor whiteColor];
        _EVCollectionView.delegate        = self;
        _EVCollectionView.dataSource      = self;
        [self reginCollectCell];
        [self addSubview:_EVCollectionView];
    }
}

-(void)reginCollectCell
{
    [_EVCollectionView registerClass:[ETTClassUserCell class] forCellWithReuseIdentifier:@"Cell"];

}
-(void)reginCollectionHeadView
{
    
}


-(void)reloadView:(NSArray *)modelArr
{
  
}
-(void)reloadView:(NSArray *)modelArr lockScreen:(BOOL)isLockScreen
{
   
}
-(void)reloadViewWithObject:(id)Object lockScreen:(BOOL)isLockScreen
{
    
}
-(void)reloadViewWithObject:(id)Object
{
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize  = CGSizeZero;
    
    return itemSize;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize  = CGSizeZero;
    
    return itemSize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    CGSize itemSize  = CGSizeZero;
    
    return itemSize;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _EVCollectionView.frame = CGRectMake(0, 0, self.width, self.height-24);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation ETTOnlineClassUserListView

-(void)reloadView:(NSArray *)modelArr
{
    [self reloadView:modelArr lockScreen:false];
 
}
-(void)createNostuView
{
    [super createNostuView];
    self.EVNOStuView.EVTitlelabel.text = @"等待学生加入课堂";
}

-(void)reloadView:(NSArray *)modelArr lockScreen:(BOOL)isLockScreen
{
    if (!modelArr || !modelArr.count)
    {
        [self createNostuView];
        self.EVDataArr = modelArr;
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self.EVCollectionView.collectionViewLayout;
        layout.sectionInset = UIEdgeInsetsMake(23, 41, 0,41 );
        [self.EVCollectionView reloadData];
        
    }
    else
    {
        
        [self removeNostuview];
        self.EVDataArr = modelArr;
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self.EVCollectionView.collectionViewLayout;
        layout.sectionInset = UIEdgeInsetsMake(23, 41, 0,41 );
        self.EVIsLockView = isLockScreen;
    }
}

-(void)reginCollectCell
{
    [self.EVCollectionView registerClass:[ETTClassUserCell class] forCellWithReuseIdentifier:@"OnlineCell"];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.EVDataArr.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize  = CGSizeZero;
    itemSize = CGSizeMake(102, 120);
    return itemSize;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize  = CGSizeZero;
    return itemSize;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ETTClassUserCell * cell =  (ETTClassUserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"OnlineCell" forIndexPath:indexPath];
    [cell setUserModel:self.EVDataArr[indexPath.row]  lockScreen:self.EVIsLockView];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ETTClassUserModel  * model = self.EVDataArr[indexPath.row];
    if (!model.isOnline)
    {
        return;
    }
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector
                            (pEvenFunctionOperation:withCommandType:withInfo:)]) {
      
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDSHOWUERINFO withInfo:model];
    }
}
@end


@implementation ETTEattendClassUserListView
-(void)reloadView:(NSArray *)modelArr
{
    [self reloadView:modelArr lockScreen:false];
    
}
-(void)createNostuView
{
    [super createNostuView];
    self.EVNOStuView.EVTitlelabel.text = @"无旁听生";
}
-(void)reloadView:(NSArray *)modelArr lockScreen:(BOOL)isLockScreen
{
    if (!modelArr || !modelArr.count)
    {
        [self createNostuView];
        self.EVDataArr = modelArr;
        [self.EVCollectionView reloadData];
        
    }
    else
    {
        
        [self removeNostuview];
        self.EVDataArr                      = modelArr;
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self.EVCollectionView.collectionViewLayout;
        layout.sectionInset                 = UIEdgeInsetsMake(23, 41, 0,41 );
        self.EVIsLockView                   = isLockScreen;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.EVDataArr.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize  = CGSizeZero;
    itemSize = CGSizeMake(102, 120);
    return itemSize;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize  = CGSizeZero;
    return itemSize;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ETTClassUserCell * cell =  (ETTClassUserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setUserModel:self.EVDataArr[indexPath.row] lockScreen:self.EVIsLockView ];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ETTClassUserModel  * model = self.EVDataArr[indexPath.row];
    if (!model.isOnline)
    {
        return;
    }
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector
                            (pEvenFunctionOperation:withCommandType:withInfo:)]) {
        
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDSHOWUERINFO withInfo:model];
    }
}
@end

#pragma mark ---------班级--------------
@interface ETTEstablishClassUserListView()
@property (nonatomic,weak)ETTClasssModel * MVViewModel;

@end

@implementation ETTEstablishClassUserListView

-(void)reloadView:(NSArray *)modelArr
{
    [self reloadView:modelArr lockScreen:false];
    
}

-(void)reloadView:(NSArray *)modelArr lockScreen:(BOOL)isLockScreen
{
    [self reloadViewWithObject:modelArr.firstObject lockScreen:isLockScreen];

}

-(void)reloadViewWithObject:(id)Object
{
    [self reloadViewWithObject:Object lockScreen:false];

}

-(void)createNostuView
{
    [super createNostuView];
    self.EVNOStuView.EVTitlelabel.text = @"暂无学生";
}

-(void)reloadViewWithObject:(id)Object lockScreen:(BOOL)isLockScreen
{
    _MVViewModel  = Object;
    if (!_MVViewModel  || ![_MVViewModel haveStudent] )
    {
        [self createNostuView];
        
        
    }
    else
    {
        if (_MVViewModel.groupList[0].groupId.integerValue>0)
        {
            [self reginCollectionHeadView];
        }
        else
        {
            UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self.EVCollectionView.collectionViewLayout;
            layout.sectionInset = UIEdgeInsetsMake(20, 41, 0,41 );
        }
        self.EVIsLockView = isLockScreen;
        [self removeNostuview];
        
        
        
        
    }

}
-(void)reginCollectionHeadView
{
      [self.EVCollectionView registerClass:[ETTClassUserListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_MVViewModel)
    {
        return _MVViewModel.groupList.count;
    }
    return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _MVViewModel.groupList[section].userList.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeZero;
    itemSize = CGSizeMake(102, 120);
    return itemSize;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize  = CGSizeZero;
    if (_MVViewModel && _MVViewModel.groupList[section].groupId.integerValue != -1)
    {
        itemSize = CGSizeMake(self.width, 34);
    }
  
    return itemSize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ETTClassUserCell * cell =  (ETTClassUserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  
    [cell setUserModel:_MVViewModel.groupList[indexPath.section].userList[indexPath.row] lockScreen:self.EVIsLockView ];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    CGSize itemSize  = CGSizeZero;
    
    return itemSize;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        ETTClassUserListHeaderView *  headview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        WS(weakSelf);
        [headview setHeadViewMessage:_MVViewModel.groupList[indexPath.row] withClick:^(id object) {
            [weakSelf groupUserRewardHandle:indexPath];
        }];
        return headview;
    }
    return nil;
}
-(void)groupUserRewardHandle:(NSIndexPath *)indexPath
{
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
    {
        
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDREWARDGROUP withInfo:[self getRewardGroupUserInfo:indexPath.section]];
    }
}
-(NSArray *)getRewardGroupUser:(NSInteger )index
{
    if (index<0) {
        return nil;
    }
    
    ETTClasssGroupModel * groupModel = _MVViewModel.groupList[index];
    
    return [groupModel getOnlineusersId];
}


-(NSDictionary  *)getRewardGroupUserInfo:(NSInteger)index
{
    if (index<0)
    {
        return  nil;
    }
    
    ETTClasssGroupModel * groupModel = _MVViewModel.groupList[index];
    
    return [groupModel setupOnlineRewardsAndReturnUsers];

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ETTClassUserModel  * model = _MVViewModel.groupList[indexPath.section].userList[indexPath.row];
    if (!model.isOnline)
    {
        return;
    }
    if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector
                            (pEvenFunctionOperation:withCommandType:withInfo:)]) {
        
        [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDSHOWUERINFO withInfo:model];
    }
}
@end
