//
//  AXPWhiteboardManagerCollectionView.h
//  test
//
//  Created by Li Kaining on 16/10/8.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXPWhiteboardManagerCollectionView : UICollectionView

@property(nonatomic ,strong) NSMutableArray *whiteboards;

@property(nonatomic) NSInteger currentSelectedIndex;
@property(nonatomic) BOOL isScroll;

- (instancetype)initWithWhiteboards:(NSArray *)whiteboards currentWhiteboard:(NSInteger)currentWhiteboard frame:(CGRect)frame;

@end
