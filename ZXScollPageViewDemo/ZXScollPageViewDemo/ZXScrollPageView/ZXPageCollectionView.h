//
//  ZXPageCollectionView.h
//  ZXPageScrollView
//
//  Created by anphen on 2017/3/29.
//  Copyright © 2017年 anphen All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(_reuseIdentifier)

@property (nonatomic, copy) NSString *reuseIdentifier;          //复用标识
@property (nonatomic, copy) NSString *isInScreen;

@end

@class ZXPageCollectionView;

@protocol ZXPageCollectionViewDelegate <NSObject>

@optional
- (void)ZXPageViewDidEndChangeIndex:(ZXPageCollectionView *)pageView currentView:(UIView *)view;

- (void)ZXPageViewDidScroll:(UIScrollView *)scrollView direction:(NSString *)direction;

- (void)ZXPageViewWillBeginDragging:(ZXPageCollectionView *)pageView;

@end

@protocol ZXPageCollectionViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInZXPageCollectionView:(ZXPageCollectionView *)ZXPageCollectionView;
- (UIView *)ZXPageCollectionView:(ZXPageCollectionView *)ZXPageCollectionView
              viewForItemAtIndex:(NSInteger)index;

@end

@interface ZXPageCollectionView : UIView

@property (nonatomic, weak) id<ZXPageCollectionViewDelegate> delegate;
@property (nonatomic, weak) id<ZXPageCollectionViewDataSource> dataSource;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *noAnimationIndex;
@property (nonatomic, assign) BOOL isAnimation;

- (void)reloadPageView;

- (void)registerClass:(Class)viewClass forViewWithReuseIdentifier:(NSString *)identifier;

- (UIView *)dequeueReuseViewWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation;

@end
