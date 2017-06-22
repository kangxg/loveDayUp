//
//	ReaderMainToolbar.h
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "UIXToolbarView.h"
#import "ETTPerformEntityInterface.h"
@class ReaderMainToolbar;
@class ReaderDocument;

@protocol ReaderMainToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar thumbsButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar exportButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar printButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar emailButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar markButton:(UIButton *)button;
- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar pushButton:(UIButton *)button;


@end

@interface ReaderMainToolbar : UIXToolbarView<ETTPerformEntityInterface>
@property (strong, nonatomic) UIButton *pushBtn;//推送按钮
@property (strong, nonatomic) UIButton *endPushBtn;//结束推送按钮

@property(nonatomic ,weak) ETTViewController *currentVC;

@property (nonatomic, weak, readwrite) id <ReaderMainToolbarDelegate> delegate;

@property (copy, nonatomic  ) NSString  *navigationTitle;

@property (strong, nonatomic) UILabel   *titleLabel;

@property (copy, nonatomic  ) NSString  *coursewareID;//课件id

@property (copy, nonatomic  ) NSString  *coursewareUrl;

@property (copy, nonatomic  ) NSString  *courseId;

@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) NSInteger endPushCurrentPage;//结束推送的当前页

- (instancetype)initWithFrame:(CGRect)frame document:(ReaderDocument *)document;

- (void)setBookmarkState:(BOOL)state;

- (void)hideToolbar;
- (void)showToolbar;

- (void)setPushButtonViewHiden:(BOOL)hiden;

@end
