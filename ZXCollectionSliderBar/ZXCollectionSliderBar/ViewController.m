//
//  ViewController.m
//  ZXCollectionSliderBar
//
//  Created by zhaoxu on 2017/4/18.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "ViewController.h"
#import "ZXCategorySliderBar.h"
#import "ZXPageCollectionView.h"
#import "childVIew.h"

@interface ViewController ()<ZXCategorySliderBarDelegate, ZXPageCollectionViewDelegate, ZXPageCollectionViewDataSource>
@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) ZXPageCollectionView *pageVC;
@property (nonatomic, strong) ZXCategorySliderBar *sliderBar;

@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    self.itemArray =@[@"家电", @"大家电", @"小家电", @"厨房电器", @"生活用品",@"家电",@"家电", @"大家电", @"小家电", @"厨房电器", @"生活用品",@"家电",@"家电", @"大家电", @"小家电", @"厨房电器", @"生活用品",@"家电"];
    self.sliderBar.originIndex = 0;
    self.sliderBar.itemArray = self.itemArray;
    [self.view addSubview:self.sliderBar];
    [self.view addSubview:self.pageVC];
    [self.view addSubview:self.reloadButton];
    self.sliderBar.moniterScrollView = self.pageVC.mainScrollView;
}

- (UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame  = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 80, 60, 60);
        _reloadButton.backgroundColor = [UIColor redColor];
        [_reloadButton setTitle:@"reload" forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (void)reload{
    self.itemArray = @[@"家电", @"大家电", @"小家电", @"厨房电器", @"生活用品",@"家电"];
    [self.pageVC reloadPageView];
    self.sliderBar.originIndex = arc4random() % 6;
    self.sliderBar.isMoniteScroll = NO;
    self.sliderBar.itemArray = self.itemArray;
    self.sliderBar.moniterScrollView = self.pageVC.mainScrollView;
}

- (ZXCategorySliderBar *)sliderBar
{
    if (!_sliderBar) {
        _sliderBar = [[ZXCategorySliderBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
        _sliderBar.delegate = self;
    }
    return _sliderBar;
}


- (ZXPageCollectionView *)pageVC
{
    if (!_pageVC) {
        _pageVC = [[ZXPageCollectionView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        _pageVC.mainScrollView.bounces = NO;
    }
    return _pageVC;
}

- (NSInteger)numberOfItemsInZXPageCollectionView:(ZXPageCollectionView *)ZXPageCollectionView{
    return self.itemArray.count;
}

- (void)ZXPageViewDidScroll:(UIScrollView *)scrollView direction:(NSString *)direction{
    [self.sliderBar adjustIndicateViewX:scrollView direction:direction];
}

- (UIView *)ZXPageCollectionView:(ZXPageCollectionView *)ZXPageCollectionView
              viewForItemAtIndex:(NSInteger)index{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"childView%ld", (long)index];
    childVIew *childView1 = (childVIew *)[ZXPageCollectionView dequeueReuseViewWithReuseIdentifier:reuseIdentifier forIndex:index];
    if (!childView1) {
        childView1 = [[childVIew alloc]initWithFrame:CGRectMake(0, 0, ZXPageCollectionView.frame.size.width, ZXPageCollectionView.frame.size.height)];
        childView1.reuseIdentifier = reuseIdentifier;
        childView1.index = index;
    }
    return childView1;
}

- (void)ZXPageViewDidEndChangeIndex:(ZXPageCollectionView *)pageView currentView:(UIView *)view{
    NSLog(@"=====%s=====", __func__);
    //滚动结束后加载页面
//    childVIew *cv = (childVIew *)view;
//    if (cv.dataArray.count == 0) {
//        [cv fetchData];
//    }
    [self.sliderBar setSelectIndex:pageView.currentIndex];
}

- (void)ZXPageViewWillBeginDragging:(ZXPageCollectionView *)pageView
{
    self.sliderBar.isMoniteScroll = YES;
    self.sliderBar.scrollViewLastContentOffset = pageView.mainScrollView.contentOffset.x;
}

- (void)didSelectedIndex:(NSInteger)index{
    [self.pageVC moveToIndex:index animation:NO];
}

@end
