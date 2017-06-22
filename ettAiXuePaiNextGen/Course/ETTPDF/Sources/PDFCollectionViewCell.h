//
//  CollectionViewCell.h
//  Reader
//
//  Created by Liu Chuanan on 16/8/31.
//
//

#import <UIKit/UIKit.h>
#import "ReaderThumbView.h"
#import "ReaderMainPagebar.h"

//@class ReaderPagebarThumb;

@interface PDFCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ReaderPagebarThumb *readerPagerThumb;

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UILabel *pageNumb;

@property (strong, nonatomic) UIImageView *imageView;

@end
