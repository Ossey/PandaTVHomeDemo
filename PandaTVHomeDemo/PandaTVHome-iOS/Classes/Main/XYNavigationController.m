//
//  XYNavigationController.m
//  PandaTVHome-iOS
//
//  Created by mofeini on 16/12/9.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYNavigationController.h"

@interface XYNavigationController ()

@end

@implementation XYNavigationController

+ (void)load {
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 当设置子控制器push时viewController.hidesBottomBarWhenPushed = YES;导航条右上角会有短暂黑阴影，设置一下属性解决
//    self.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        if ([viewController isKindOfClass:NSClassFromString(@"XYChannelCategoryController")]) {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage xy_imageWithOrignalModeImageName:@"ChannelCategory_back"] style:UIBarButtonItemStylePlain target:self action:@selector(ChannelCategory_backClick)];
            
            __weak typeof(viewController) weakViewController = viewController;
            self.interactivePopGestureRecognizer.delegate = (id)weakViewController;
        }
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    /// 发布Pop通知
    [[NSNotificationCenter defaultCenter] postNotificationName:XYVCPopNotification object:nil userInfo:nil];
    return [super popViewControllerAnimated:animated];
}

- (void)ChannelCategory_backClick {
    
    if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self popViewControllerAnimated:YES];
    }
}


@end
