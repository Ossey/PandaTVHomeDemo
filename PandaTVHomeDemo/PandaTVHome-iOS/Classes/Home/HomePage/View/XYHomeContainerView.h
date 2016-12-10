//
//  XYHomeContainerView.h
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYHomeContainerView;
@protocol XYHomeContainerViewDelegate <UICollectionViewDelegate>

@optional
/**
 * @explain 滚动containerView时对应的索引, 从0开始
 */
- (void)containerView:(XYHomeContainerView *)containerView indexAtContainerView:(NSInteger)index;

@end

@interface XYHomeContainerView : UICollectionView

/** 子控制器数组, 当外界的子控制器发生改变时，要把子控制器数组重新赋值以下即可，当有新值时，内部会自动刷新 */
@property (nonatomic, strong) NSMutableArray *childViewControllers;

/** 代理 */
@property (nonatomic, weak) id<XYHomeContainerViewDelegate> containerViewDelegate;

/**
 * @explain 手动选择某个页面, 从0开始
 *
 */
- (void)selectIndex:(NSInteger)index;
/**
 * @explain 创建并初始化当前类对象
 *
 * @param   frame  frame
 * @param   subVCs  子控制对象数组
 * @return  实例化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame subVCs:(NSArray *)subVCs;
@end

@interface XYHomeContainerViewLayout : UICollectionViewFlowLayout

@end
