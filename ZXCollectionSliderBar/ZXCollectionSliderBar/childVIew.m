//
//  childVIew.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/29.
//  Copyright © 2017年 SUNING. All rights reserved.
//

#import "childVIew.h"
#import "MBProgressHUD.h"

@implementation childVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        self.backgroundColor = [UIColor yellowColor];
        _dataArray = [[NSArray alloc]init];
        if (_dataArray.count == 0) {
            [self fetchData];
        }
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _label.font = [UIFont systemFontOfSize:24];
        _label.textColor = [UIColor redColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.label.text = [NSString stringWithFormat:@"%ld",(long)index];
}

- (void)fetchData
{
//    NSLog(@"====%@====", self.label.text);
    self.dataArray = @[@"1", @"2", @"3"];
    [MBProgressHUD showHUDAddedTo:self animated:NO];
    [self performSelector:@selector(hiddenHUD) withObject:nil afterDelay:1];
}

- (void)hiddenHUD{
    [MBProgressHUD hideHUDForView:self animated:NO];
    self.label.text = [NSString stringWithFormat:@"%@ == 已加载数据",  self.label.text];
}

@end
