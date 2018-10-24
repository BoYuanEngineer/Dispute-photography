//
//  YBLoginViewController.m
//  有点意思.
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "YBLoginViewController.h"
#import "WSLoginView.h"
#import "YBNavgationController.h"
#import "YBViewController.h"

@interface YBLoginViewController ()

@end

@implementation YBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatLoginView];
}

- (void)creatLoginView {
    
    WSLoginView *wsLoginV = [[WSLoginView alloc]initWithFrame:self.view.bounds];
    wsLoginV.titleLabel.text = @"Welcome To Photography";
    wsLoginV.titleLabel.textColor = [UIColor grayColor];
    wsLoginV.hideEyesType = AllEyesHide;
    [self.view addSubview:wsLoginV];
    
    [wsLoginV setClickBlock:^(NSString *textField1Text, NSString *textField2Text,UIButton *loginBtn) {
        if ([textField1Text isEqualToString:@"yuanbo"] && [textField2Text isEqualToString:@"123456"]) {
            
            YBViewController *vc = [[YBViewController alloc]init];
            YBNavgationController* nav= [[YBNavgationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }else {
            [loginBtn setTitle:@"账号或密码错误" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor colorWithHexString:@"#FF8C69"] forState:UIControlStateNormal];
            [UIView animateWithDuration:1.5 animations:^{
                loginBtn.titleLabel.alpha = 0;
            } completion:^(BOOL finished) {
                loginBtn.titleLabel.alpha = 1;
                [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
                [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }];
        }
    }];

}

@end
