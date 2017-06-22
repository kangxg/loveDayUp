//
//  AXPCarouselViewLayout.h
//  test
//
//  Created by Li Kaining on 16/10/8.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HJCarouselAnim) {
    HJCarouselAnimLinear,
    HJCarouselAnimRotary,
    HJCarouselAnimCarousel,
    HJCarouselAnimCarousel1,
    HJCarouselAnimCoverFlow,
};

@interface AXPCarouselViewLayout : UICollectionViewLayout

- (instancetype)initWithAnim:(HJCarouselAnim)anim;

@property (readonly)  HJCarouselAnim carouselAnim;

@property (nonatomic) CGSize                          itemSize;
@property (nonatomic) NSInteger                       visibleCount;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) NSInteger                       selectedIndex;

@end
