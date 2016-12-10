//
//  XYChannelCategoryController.h
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  频道分类控制器

#import <UIKit/UIKit.h>

@protocol XYChannelCategoryControllerDelegate <NSObject>

@optional

- (void)channelCategoryControllerWithCateTitles:(NSArray *)cateTitles;

@end

@interface XYChannelCategoryController : UIViewController

@property (nonatomic, weak) id<XYChannelCategoryControllerDelegate> delegate;

@end

@interface XYChannelCategoryLayout : UICollectionViewFlowLayout

@end


@interface XYChannelCategoryHeaderView : UICollectionReusableView

@property (nonatomic, strong) NSString *sectionHeaderTitle;

@end

@interface XYChannelCategoryCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *subcate;
@property (nonatomic, weak, readonly) UILabel *label;

@end
