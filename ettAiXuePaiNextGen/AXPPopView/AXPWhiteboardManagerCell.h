//
//  AXPWhiteboardManagerCell.h
//  test
//
//  Created by Li Kaining on 16/10/8.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#define kCellWidth 286
#define kCellHeight 224


#import <UIKit/UIKit.h>

@interface AXPWhiteboardManagerCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *imageView;

@property (nonatomic ,strong) UIButton    *deleteButton;

@property(nonatomic ,strong) UILabel      *pageLabel;

@end
