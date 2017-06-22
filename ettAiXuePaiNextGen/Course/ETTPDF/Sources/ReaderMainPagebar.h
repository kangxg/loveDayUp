//
//	ReaderMainPagebar.h
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-09-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

#import "ReaderThumbView.h"

@class ReaderMainPagebar;
@class ReaderTrackControl;
@class ReaderPagebarThumb;
@class ReaderDocument;

@protocol ReaderMainPagebarDelegate <NSObject>

@required // Delegate protocols

- (void)pagebar:(ReaderMainPagebar *)pagebar gotoPage:(NSInteger)page;

@end

@interface ReaderMainPagebar : UIView

@property (nonatomic, weak, readwrite) id <ReaderMainPagebarDelegate> delegate;

@property (nonatomic, copy) NSString *coursewareUrl;//课件url

@property (copy, nonatomic) NSString *navigationTitle;

@property (copy, nonatomic) NSString *coursewareID;//课件id

@property (copy, nonatomic) NSString *courseId;

@property(nonatomic, assign) NSInteger selectIndex;

@property(nonatomic, assign) NSInteger pushCurrentPage;//老师推送过来的当前页 结束推送后学生下面collectionView凸显到哪页

@property (nonatomic, assign) NSInteger endPushCurrentPage;//老师结束推送的当前页

@property (nonatomic, strong)UICollectionView *theCollectionView;

- (instancetype)initWithFrame:(CGRect)frame document:(ReaderDocument *)object;

- (void)updatePageNumberText:(NSInteger)page;

- (void)updatePagebar;

- (void)hidePagebar;
- (void)showPagebar;

@end

#pragma mark -

//
//	ReaderTrackControl class interface 容器(设置成红色的部分)
//

@interface ReaderTrackControl : UIControl

@property (nonatomic, assign, readonly) CGFloat value;

@end

#pragma mark -

//
//	ReaderPagebarThumb class interface 缩略图
//

@interface ReaderPagebarThumb : ReaderThumbView

- (instancetype)initWithFrame:(CGRect)frame small:(BOOL)small;

@end

#pragma mark -

//
//	ReaderPagebarShadow class interface  阴影 整个bar的阴影
//

@interface ReaderPagebarShadow : UIView

@end
