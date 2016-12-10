//
//  XYCateTitleView.h
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  分类标题内容视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XYCateTitleView;
@protocol XYCateTitleViewDelegate <NSObject>

@optional
/**
 * @explain 分类子标题按钮已全部创建完毕的通知
 
 * @param   view  XYCateTitleView实例对象
 * @param   itemCount  子标题按钮的个数
 */
- (void)cateTitleView:(XYCateTitleView *)view cateTitleItemDidCreated:(NSInteger)itemCount;
/**
 * @explain 点击`添加频道分类`按钮时调用
 *
 */
- (void)cateTitleView:(XYCateTitleView *)view didSelectedAddSubTitle:(UIButton *)addBtn;

@required
/**
 * @explain 点击标题按钮时调用，并把点击标题按钮的索引传递出去
 *
 * @param   view  XYCateTitleView的实例对象
 * @param   index  选中标题按钮的索引
 */
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(NSInteger)index;

@end

@interface XYCateTitleView : UIView

/** 分类标题内容视图 */
@property (nonatomic, weak, readonly) UIScrollView *cateTitleView;
/** 选中标题按钮的索引, 默认为0, 当外界设置的索引大于子控制器的总数时，设置的索引无效，变为默认值0 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 标题按钮缩放比例, 默认为0, 有效范围0.0~1.0 */
@property (nonatomic, assign) CGFloat itemScale;
/** 存放标题按钮的数组 */
@property (nonatomic, strong, readonly) NSMutableArray *items;
/** 标题按钮的字体 */
@property (nonatomic, strong) UIFont *homeCateTitleFont;
@property (nonatomic, strong) UIColor *currentItemBackgroundColor;
@property (nonatomic, strong) UIColor *otherItemBackgroundColor;
@property (nonatomic, strong) UIColor *underLineBackgroundColor;
@property (nonatomic, strong) UIImage *underLineImage;
@property (nonatomic, strong) UIImage *separatorImage;
@property (nonatomic, strong) UIColor *separatorBackgroundColor;
@property (nonatomic, weak) id<XYCateTitleViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame channelCates:(NSArray *)channelCates;

@end
NS_ASSUME_NONNULL_END
