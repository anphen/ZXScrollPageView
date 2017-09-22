
//  ZXPageCollectionView.m
//  ZXPageScrollView
//
//  Created by anphen on 2017/3/29.
//  Copyright © 2017年 anphen. All rights reserved.
//

#import "ZXPageCollectionView.h"
#import <objc/runtime.h>

static char UIViewReuseIdentifier;
static char UIViewIsInScreen;

@implementation UIView(_reuseIdentifier)

- (void) setReuseIdentifier:(NSString *)reuseIdentifier {
    objc_setAssociatedObject(self, &UIViewReuseIdentifier, reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *) reuseIdentifier {
    return objc_getAssociatedObject(self, &UIViewReuseIdentifier);
}

- (void) setIsInScreen:(NSString *)isInScreen {
    objc_setAssociatedObject(self, &UIViewIsInScreen, isInScreen, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *) isInScreen {
    return objc_getAssociatedObject(self, &UIViewIsInScreen);
}


@end

@interface ZXPageCollectionView()<UIScrollViewDelegate>
{
    float lastContentOffset;
}

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, copy) NSString *currentIdentifier;
@property (nonatomic, strong) NSMutableArray *reUseViewArray;
@property (nonatomic, assign) NSInteger totolCount;
@property (nonatomic, assign) BOOL isPageMove;

@end

@implementation ZXPageCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lastContentOffset = 0;
        _reUseViewArray = [[NSMutableArray alloc]init];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)registerClass:(Class)viewClass forViewWithReuseIdentifier:(NSString *)identifier
{
    
}

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation{
    _isAnimation = animation;
    if (!animation) {
        lastContentOffset = index * self.frame.size.width;

    }
    else{
         lastContentOffset = self.currentIndex * self.frame.size.width;
    }
    self.currentIndex = index;
    _isPageMove = YES;
    if (index * self.frame.size.width == self.mainScrollView.contentOffset.x) {
        UIView *view = [self checkDataSourceViewAtIndex:index];
        if (![self checkIsExistInCache:view]) {
            self.currentView  = view;
            [self.mainScrollView addSubview:view];
            [self.reUseViewArray addObject:view];
        }
        [self endChangeIndex];
    }
    else{
        [self.mainScrollView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:animation];
    }
}



- (UIView *)dequeueReuseViewWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index
{
    for (UIView *view in self.reUseViewArray) {
        if ([view.reuseIdentifier isEqualToString:identifier]) {
            return view;
        }
    }
    return nil;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.pagingEnabled = YES;
    }
    return _mainScrollView;
}

- (void)setDataSource:(id<ZXPageCollectionViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _totolCount = [self.dataSource numberOfItemsInZXPageCollectionView:self];
    self.mainScrollView.contentSize = CGSizeMake(_totolCount * self.frame.size.width, 0);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
       NSInteger index = self.mainScrollView.contentOffset.x / self.frame.size.width;
        if (lastContentOffset < self.mainScrollView.contentOffset.x) {
            //            direction = @"向左";
            if (index * self.frame.size.width != self.mainScrollView.contentOffset.x) {
                index  = index + 1;
            }
        }else{
            //            direction = @"向右";
        }
        if (index >= _totolCount) {
            return;
        }
        self.currentView = [self checkDataSourceViewAtIndex:index];
        if (!self.currentView.reuseIdentifier) {
            return;
        }
        if (![self checkIsExistInCache: self.currentView]) {
            [self.reUseViewArray addObject: self.currentView];
            [self.mainScrollView addSubview: self.currentView];
        }
        else{
            if ( self.currentView.isInScreen.integerValue == 0) {
                 [self.mainScrollView addSubview: self.currentView];
            }
        }
        if (!self.isPageMove || self.isAnimation) {
          //没调用 moveindex 或者 有动画
        }
        else{
            [self endChangeIndex];
        }
        self.isPageMove = NO;
    }
}

#pragma mark - cache

- (BOOL)checkIsExistInCache:(UIView *)view{
    BOOL isExist = NO;
    for (UIView *view1 in self.reUseViewArray) {
        if ([view1.reuseIdentifier isEqualToString:view.reuseIdentifier]) {
            isExist = YES;
        }
    }
    return isExist;
}

#pragma mark - action

- (void)reloadPageView{
    for (UIView *view in self.reUseViewArray ) {
            [view removeFromSuperview];
    }
    [self.reUseViewArray removeAllObjects];
    _totolCount = [self.dataSource numberOfItemsInZXPageCollectionView:self];
    self.mainScrollView.contentSize = CGSizeMake(_totolCount * self.frame.size.width, 0);
 
}

- (void)endChangeIndex{
    if([self.delegate respondsToSelector:@selector(ZXPageViewDidEndChangeIndex:currentView:)]){
        [self.delegate ZXPageViewDidEndChangeIndex:self currentView: self.currentView];
        [self removeOutSideView];
    }
}

- (UIView *)checkDataSourceViewAtIndex:(NSInteger) index{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor grayColor];
    if ([self.dataSource respondsToSelector:@selector(ZXPageCollectionView:viewForItemAtIndex:)]) {
        UIView *dataSourceView = [self.dataSource ZXPageCollectionView:self viewForItemAtIndex:index];
        if (dataSourceView) {
            view = dataSourceView;
        }
    }
    view.frame = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    return view;
}

- (void)removeOutSideView{
    NSLog(@"====%s====", __func__);
    for (UIView *view in self.reUseViewArray) {
        if ([self viewIsInScreen:view.frame]) {
            view.isInScreen = @"1";
        }
        else{
            view.isInScreen = @"0";
            [view removeFromSuperview];
        }
    }
}

- (BOOL)viewIsInScreen:(CGRect)frame {
    CGFloat x = frame.origin.x;
    CGFloat ScreenWidth = self.mainScrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.mainScrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < ScreenWidth) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.currentView = [self checkDataSourceViewAtIndex:self.currentIndex];
    if (!self.currentView.reuseIdentifier) {
        return;
    }
    if (![self checkIsExistInCache: self.currentView]) {
        [self.reUseViewArray addObject: self.currentView];
        [self.mainScrollView addSubview: self.currentView];
    }
    else{
        if ( self.currentView.isInScreen.integerValue == 0) {
            [self.mainScrollView addSubview: self.currentView];
        }
    }
    [self endChangeIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSString *direction = @"";
    if (lastContentOffset < scrollView.contentOffset.x) {
        direction = @"向左";
    }else{
        direction = @"向右";
    }
    if ([self.delegate respondsToSelector:@selector(ZXPageViewDidScroll: direction:)]) {
        [self.delegate ZXPageViewDidScroll:scrollView direction:direction];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isPageMove = NO;
    lastContentOffset = scrollView.contentOffset.x;
    if ([self.delegate respondsToSelector:@selector(ZXPageViewWillBeginDragging:)]) {
        [self.delegate ZXPageViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.currentView = [self checkDataSourceViewAtIndex:self.currentIndex];
    if (lastContentOffset == scrollView.contentOffset.x) {
        [self removeOutSideView];
        return;
    }
    [self endChangeIndex];
}

- (void)dealloc
{
    [self.mainScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
