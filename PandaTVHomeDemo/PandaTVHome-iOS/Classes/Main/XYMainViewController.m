//
//  XYMainViewController.m
//  PandaTVHome-iOS
//
//  Created by mofeini on 16/12/9.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYMainViewController.h"
#import "XYHomePageController.h"
#import "XYGameViewController.h"
#import "XYYuleViewController.h"
#import "XYGoddessViewController.h"
#import "XYMineViewController.h"
#import "XYNavigationController.h"

@interface XYMainViewController ()

@end

@implementation XYMainViewController

+ (void)load {

    UITabBar *bar = [UITabBar appearanceWhenContainedIn:[XYMainViewController class], nil];
    
    bar.tintColor = kAppGlobalColor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildVC];
}


- (void)addChildVC {
    
    XYHomePageController *homePageVc = [XYHomePageController new];
    XYNavigationController *homePageNav = [[XYNavigationController alloc] initWithRootViewController:homePageVc];
    homePageNav.tabBarItem.image = [UIImage xy_imageWithOrignalModeImageName:@"menu_homepage"];
    homePageNav.tabBarItem.selectedImage = [UIImage xy_imageWithOrignalModeImageName:@"menu_homepage_sel"];
    homePageNav.title = @"首页";
    [self addChildViewController:homePageNav];
    
    XYGameViewController *gameVc = [XYGameViewController new];
    XYNavigationController *gameNav = [[XYNavigationController alloc] initWithRootViewController:gameVc];
    gameNav.tabBarItem.image = [UIImage xy_imageWithOrignalModeImageName:@"menu_youxi"];
    gameNav.tabBarItem.selectedImage = [UIImage xy_imageWithOrignalModeImageName:@"menu_youxi_sel"];
    gameNav.title = @"游戏";
    [self addChildViewController:gameNav];
    
    XYYuleViewController *yuleVc = [XYYuleViewController new];
    XYNavigationController *yuleNav = [[XYNavigationController alloc] initWithRootViewController:yuleVc];
    yuleNav.tabBarItem.image = [UIImage xy_imageWithOrignalModeImageName:@"menu_yule"];
    yuleNav.tabBarItem.selectedImage = [UIImage xy_imageWithOrignalModeImageName:@"menu_yule_sel"];
    yuleNav.title = @"娱乐";
    [self addChildViewController:yuleNav];
    
    XYGoddessViewController *goddessVc = [XYGoddessViewController new];
    XYNavigationController *goddessNav = [[XYNavigationController alloc] initWithRootViewController:goddessVc];
    goddessNav.tabBarItem.image = [UIImage xy_imageWithOrignalModeImageName:@"menu_goddess_normal"];
    goddessNav.tabBarItem.selectedImage = [UIImage xy_imageWithOrignalModeImageName:@"menu_goddess"];
    goddessNav.title = @"女神";
    [self addChildViewController:goddessNav];
    
    XYMineViewController *mineVc = [XYMineViewController new];
    XYNavigationController *mineNav = [[XYNavigationController alloc] initWithRootViewController:mineVc];
    mineNav.tabBarItem.image = [UIImage xy_imageWithOrignalModeImageName:@"menu_mine"];
    mineNav.tabBarItem.selectedImage = [UIImage xy_imageWithOrignalModeImageName:@"menu_mine_sel"];
    mineNav.title = @"我的";
    [self addChildViewController:mineNav];
    
}


@end
