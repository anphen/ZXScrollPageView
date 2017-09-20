//
//  ZXCategorySliderBar.h
//  ZXCollectionSliderBar
//
//  Created by zhaoxu on 2017/4/18.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXCategorySliderBarDelegate <NSObject>

- (void)didSelectedIndex:(NSInteger)index;

@end

@interface ZXCategorySliderBar : UIView

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, assign) NSInteger originIndex;
@property (nonatomic, weak) id<ZXCategorySliderBarDelegate> delegate;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, assign) BOOL isMoniteScroll;
@property (nonatomic, strong) UIScrollView *moniterScrollView;

@property (nonatomic, assign) CGFloat scrollViewLastContentOffset;

- (void)setSelectIndex:(NSInteger)index;

- (void)adjustIndicateViewX:(UIScrollView *)scrollView direction:(NSString *)direction;

@end
