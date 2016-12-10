//
//  XYHomePageController.m
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYHomePageController.h"
#import "XYHomeContainerView.h"
#import "UIView+XYExtension.h"
#import "XYCateTitleView.h"
#import "XYChannelCategoryController.h"

static NSString *const childViewControllersKey = @"childVCKey";

@interface XYHomePageController () <XYCateTitleViewDelegate, XYChannelCategoryControllerDelegate>

/** 将主页所有子控器的view添加到内容视图上 */
@property (nonatomic, strong) XYHomeContainerView *containerView;
/** 标题容器视图 */
@property (nonatomic, strong) XYCateTitleView *titleContainerView;
/** 需要创建的频道分类数组 */
@property (nonatomic, strong) NSMutableArray *cateTitles;
@end

@implementation XYHomePageController
@synthesize cateTitles = _cateTitles;

- (NSMutableArray *)cateTitles {
    if (_cateTitles == nil) {
        _cateTitles = [NSMutableArray array];
    }
    return _cateTitles;
}
- (void)setCateTitles:(NSMutableArray *)cateTitles {
    _cateTitles = cateTitles;
    
    /// 需求:无论怎么修改频道分类数组，都要保持标题栏的前两位一直是<精彩推荐>和<全部直播>
    /// 当每一次修改频道分类标题调用set方法时，进行判断，如果没有<精彩推荐>和<全部直播>就插入
    
    NSArray *tempArray = [NSArray arrayWithArray:cateTitles];
    
    NSInteger i = 0;
    for (NSDictionary *dict in tempArray) {
        NSString *value = [dict valueForKey:@"cname"];

        if (i == 0 && ![value isEqualToString:@"精彩推荐"]) {
            NSDictionary *dict1 = @{@"cname" : @"精彩推荐", @"ename": @"jctj"};
            [cateTitles insertObject:dict1 atIndex:0];
            
        }
        
        if (i == 1 && ![value isEqualToString:@"全部直播"]) {
            NSDictionary *dict2 = @{@"cname": @"全部直播", @"ename": @"alllive"};
            [cateTitles insertObject:dict2 atIndex:1];
        }
        
        i++;
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

- (void)setup {
    
    UIImageView *titleView =  [[UIImageView alloc] init];
    titleView.image = [UIImage imageNamed:@"title_image"];
    titleView.frame = CGRectMake(0, 0, 54, 33);
    self.navigationItem.titleView = titleView;
    
    /// 从偏好设置中查找子控制的数量
    self.cateTitles = [[[NSUserDefaults standardUserDefaults] arrayForKey:childViewControllersKey] mutableCopy];
    
    if (!self.cateTitles.count) {
        /// 只有第一次启动程序时才会加载下面这些数据
        NSDictionary *dict1 = @{@"cname": @"精彩推荐", @"ename": @"jctj"};
        NSDictionary *dict2 = @{@"cname": @"全部直播", @"ename": @"alllive"};
        NSDictionary *dict3 = @{@"cname": @"英雄联盟", @"ename": @"lol"};
        NSDictionary *dict4 = @{@"cname": @"熊猫星秀", @"ename": @"yzdr"};
        NSDictionary *dict5 = @{@"cname": @"守望先锋", @"ename": @"overwatch"};
        NSDictionary *dict6 = @{@"cname": @"户外直播", @"ename": @"hwzb"};
        NSDictionary *dict7 = @{@"cname": @"炉石传说", @"ename": @"hearthstone"};
        self.cateTitles = [@[dict1, dict2, dict3, dict4, dict5, dict6, dict7] mutableCopy];
        
    }
    for (NSInteger i = 0; i < self.cateTitles.count; ++i) {
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:vc];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createContainerView];
    [self createCateTitleView];
    
}

#pragma mark - XYCateTitleViewDelegate
/// cateTitleView上按钮被点击的时候调用
- (void)cateTitleView:(XYCateTitleView *)view didSelectedItem:(NSInteger)index {
    
    CGFloat x = index * CGRectGetWidth(self.containerView.frame);
    // 内容视图滚动到对应的位置
    self.containerView.contentOffset = CGPointMake(x, 0);
}

- (void)cateTitleView:(XYCateTitleView *)view didSelectedAddSubTitle:(UIButton *)addBtn {
    
    XYChannelCategoryController *vc = [XYChannelCategoryController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - XYChannelCategoryControllerDelegate
- (void)channelCategoryControllerWithCateTitles:(NSArray *)cateTitles {
    
    self.cateTitles = [cateTitles mutableCopy];
    [[NSUserDefaults standardUserDefaults] setObject:self.cateTitles forKey:childViewControllersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSLog(@"未操作之前--%ld", self.childViewControllers.count);
//    NSLog(@"%@", self.childViewControllers);
    /// 移除当前控制器中的子控制器
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        
    }
//    NSLog(@"移除之后--%ld", self.childViewControllers.count);
//    NSLog(@"%@", self.childViewControllers);
    
    /// 根据cateTitles数组中的数据创建对应的控制器
    for (id obj in self.cateTitles) {
        
        NSString *title = obj[@"cname"];
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = kRandomColor;
        vc.title = title;
        vc.tabBarItem.image = [UIImage new];
        [self addChildViewController:vc];

    }
    
//    NSLog(@"添加之后--%ld", self.childViewControllers.count);
//    NSLog(@"%@", self.childViewControllers);
    
    /// 重新创建titleContainerView
    [self.titleContainerView removeFromSuperview];
    self.titleContainerView = nil;
    [self createCateTitleView];
    /// 将新的子控制器数组赋值给containerView的
    self.containerView.childViewControllers = [self.childViewControllers mutableCopy];
    
}

- (void)createCateTitleView {
    
    CGFloat y = !self.navigationController.navigationBar || self.navigationController.navigationBar.translucent == NO ? 0 : 64;
    self.titleContainerView = [[XYCateTitleView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), 44) channelCates:self.cateTitles];
    [self.view addSubview:self.titleContainerView];
    self.titleContainerView.delegate = self;
    self.titleContainerView.homeCateTitleFont = [UIFont systemFontOfSize:15 weight:0.0];
    self.titleContainerView.itemScale = 0;
    self.titleContainerView.underLineBackgroundColor = [UIColor colorWithRed:57/255.0 green:217/255.0 blue:146/255.0 alpha:1.0];
    
}

- (void)createContainerView {
    
    self.containerView = [[XYHomeContainerView alloc] initWithFrame:self.view.bounds subVCs:self.childViewControllers];
    [self.view addSubview:self.containerView];
}


@end
