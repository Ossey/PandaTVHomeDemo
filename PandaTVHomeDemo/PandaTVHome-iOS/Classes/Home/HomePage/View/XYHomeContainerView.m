//
//  XYHomeContainerView.m
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  主页子控制器view容器视图

#import "XYHomeContainerView.h"

@interface XYHomeContainerView () <UICollectionViewDataSource, XYHomeContainerViewDelegate>

@property (nonatomic, strong) XYHomeContainerViewLayout *layout;

@end

@implementation XYHomeContainerView
@synthesize childViewControllers = _childViewControllers;

- (void)setChildViewControllers:(NSMutableArray *)childViewControllers {
    _childViewControllers = childViewControllers;
    
    [self reloadData];
}

- (NSMutableArray *)childViewControllers {
    if (_childViewControllers == nil) {
        _childViewControllers = [NSMutableArray arrayWithCapacity:0];
    }
    return _childViewControllers;
}

- (XYHomeContainerViewLayout *)layout {
    if (_layout == nil) {
        _layout = [[XYHomeContainerViewLayout alloc] init];
    }
    return _layout;
}

static NSString *const cellIdentifier = @"XYHomeContainerView";

- (instancetype)initWithFrame:(CGRect)frame subVCs:(NSArray *)subVCs {
    
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        [self.childViewControllers addObjectsFromArray:subVCs];;
        self.bounces = NO;  // 弹簧
        self.pagingEnabled = YES; // 分页
        self.showsVerticalScrollIndicator = NO; // 指示器
        self.scrollsToTop = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(subVCs.count * CGRectGetWidth(self.frame), 0);
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    
    return self;
}


#pragma mark - UICollectionView代理和数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
//    NSLog(@"childViewControllers.count--%ld", self.childViewControllers.count);
    
    UIViewController *vc = [self.childViewControllers objectAtIndex:indexPath.row];
    vc.view.frame = cell.bounds;
    [cell.contentView addSubview:vc.view];
    return cell;
}

#pragma mark - UIScrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 计算索引
    NSInteger i = scrollView.contentOffset.x / CGRectGetWidth(self.frame);
    
    if (self.containerViewDelegate && [self.delegate respondsToSelector:@selector(containerView:indexAtContainerView:)]) {
        
        [self.containerViewDelegate containerView:self indexAtContainerView:i];
    }
    
    /// 发布scrollView减速完成的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeContainerViewDidEndDeceleratingNote" object:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /// 发布scrollView滚动的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"homeContainerViewDidScrollNote" object:scrollView];
}


- (void)selectIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }];
}

@end

@implementation XYHomeContainerViewLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.itemSize = self.collectionView.frame.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

@end
