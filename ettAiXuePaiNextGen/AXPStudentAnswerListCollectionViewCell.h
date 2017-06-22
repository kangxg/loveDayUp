//
//  AXPStudentAnswerListCollectionViewCell.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXPStudentAnswerListCollectionViewCell : UICollectionViewCell

-(void)setUpAttributesWithDict:(NSDictionary *)dict isMarkScore:(BOOL)isMarkScore;

-(void)setUpPaperAnswerDetailWithDict:(NSDictionary *)dict isMarkScore:(BOOL)isMarkScore;

@end
