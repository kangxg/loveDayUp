//
//  AXPWhiteboardManagerCollectionView.m
//  test
//
//  Created by Li Kaining on 16/10/8.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPWhiteboardManagerCollectionView.h"
#import "AXPWhiteboardManagerCell.h"
#import "AXPCarouselViewLayout.h"
#import "UIColor+RGBColor.h"

#define kAXPWhiteboardManagerCell @"AXPWhiteboardManagerCell"

@interface AXPWhiteboardManagerCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation AXPWhiteboardManagerCollectionView

- (instancetype)initWithWhiteboards:(NSArray *)whiteboards currentWhiteboard:(NSInteger)currentWhiteboard frame:(CGRect)frame
{
    AXPCarouselViewLayout *axpLayout = [[AXPCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
    axpLayout.itemSize               = CGSizeMake(kCellWidth, kCellHeight);
    axpLayout.scrollDirection        = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithFrame:frame collectionViewLayout:axpLayout];
    
    if (self) {
        
        self.dataSource      = self;
        self.delegate        = self;
        self.backgroundColor = kAXPCOLORblack_t60;

        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[AXPWhiteboardManagerCell class] forCellWithReuseIdentifier:kAXPWhiteboardManagerCell];
        
        self.whiteboards = whiteboards.mutableCopy;
        self.currentSelectedIndex = currentWhiteboard;
    }
    
    return self;
}

-(NSMutableArray *)whiteboards
{
    if (!_whiteboards) {
        _whiteboards = [NSMutableArray array];
    }
    return _whiteboards;
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.whiteboards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AXPWhiteboardManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAXPWhiteboardManagerCell forIndexPath:indexPath];

    UIImage *image                 = self.whiteboards[indexPath.row];
    cell.imageView.image           = image;
    cell.pageLabel.text            = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    NSInteger index;
    
    if (self.isScroll) {
        index = self.currentSelectedIndex;
    }else
    {
        CGFloat x = self.contentOffset.x;
        index = (x +540)/286;
    }
    
    if (index == indexPath.item) {
    
        cell.deleteButton.hidden = NO;
    }else
    {
        cell.deleteButton.hidden = YES;
    }
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectedWhiteboardView" object:indexPath];
    [collectionView removeFromSuperview];
}

@end
