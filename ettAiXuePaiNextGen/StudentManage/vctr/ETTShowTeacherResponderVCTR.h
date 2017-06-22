//
//  ETTShowTeacherResponderVCTR.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"
#import "ETTCollectionView.h"

@interface ETTShowTeacherResponderVCTR : ETTViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,retain)ETTCollectionView     *  EVCollectionView;
@end
