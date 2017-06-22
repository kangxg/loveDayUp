//
//  ETTStudentAnswerListView.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXPStudentAnswerListCollectionView.h"

@interface ETTStudentAnswerListView : UIView

@property(nonatomic ,strong) UIView *placeholderView;

@property(nonatomic ,strong) UILabel *explainLabel;

@property(nonatomic ,strong) AXPStudentAnswerListCollectionView *answerListCollectionView;

@end
