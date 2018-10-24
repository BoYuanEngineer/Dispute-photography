//
//  YBNavgationController.m
//  有点意思.
//
//  Created by Macx on 16/6/4.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "YBNavgationController.h"

@interface YBNavgationController ()

@end

@implementation YBNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back"];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}



@end
