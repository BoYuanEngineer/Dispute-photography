//
//  YBViewController.m
//  有点意思.
//
//  Created by Macx on 16/6/4.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "YBViewController.h"
#import "YBStealthPhotographyView.h"
#import "YBWatchVideoController.h"
#import "YBCamouflageWatchController.h"
#import <KYAlertView.h>

@interface YBViewController ()

@property (nonatomic,strong)UIButton *enterButton;
@property (nonatomic,strong)UIButton *watchBtn;
@end

@implementation YBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

-(void)setupUI {
    
    [self.view addSubview:self.enterButton];
    [self.view addSubview:self.watchBtn];
    
    [_watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15*UIScreenWidthScale);
        make.top.offset(15*UIScreenWidthScale+ZXNAVHEIGHT);
        make.width.offset(80*UIScreenWidthScale);
        make.height.offset(20*UIScreenWidthScale);
    }];
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [[UIButton alloc]initWithFrame:CGRectMake(15*UIScreenWidthScale, 15*UIScreenWidthScale+ZXNAVHEIGHT, 80*UIScreenWidthScale, 20*UIScreenWidthScale)];
        [_enterButton addTarget:self action:@selector(clickJump) forControlEvents:UIControlEventTouchUpInside];
        [_enterButton setTitle:@"Enter" forState:UIControlStateNormal];
        [_enterButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _enterButton;
}
- (UIButton *)watchBtn {
    if (!_watchBtn) {
        _watchBtn = [[UIButton alloc]init];
        [_watchBtn addTarget:self action:@selector(clickWatchBtn) forControlEvents:UIControlEventTouchUpInside];
        [_watchBtn setTitle:@"watch" forState:UIControlStateNormal];
        [_watchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _watchBtn;
}

-(void)clickJump {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set the title" message:@"Whether to set the title?" delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
    [[alert textFieldAtIndex:0] setSecureTextEntry:NO];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Please Enter The Title"];
    alert.alertViewClickedButtonAtIndexBlock = ^(UIAlertView *alert ,NSUInteger index) {
        
        YBStealthPhotographyView*videoView = [[YBStealthPhotographyView alloc]init];
        if (index == 1) {
            if (STRING_IS_NIL([alert textFieldAtIndex:0].text)) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter The Title" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                alert.alertViewClickedButtonAtIndexBlock = ^(UIAlertView *alert ,NSUInteger index) {
                };
                [alert show];
                return;
            }else {
                videoView.videoTitle = [alert textFieldAtIndex:0].text;
            }
        }
        [self.navigationController pushViewController:videoView animated:YES];
    };
    [alert show];
}

- (void)clickWatchBtn {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter the password" message:nil delegate:nil cancelButtonTitle:@"Cancle" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alert textFieldAtIndex:0] setPlaceholder:@"password"];
    alert.alertViewClickedButtonAtIndexBlock = ^(UIAlertView *alert ,NSUInteger index) {
        
        if (index == 1) {
            if ([[alert textFieldAtIndex:0].text isEqualToString:@"2032685"]) {
                YBWatchVideoController *videoView = [[YBWatchVideoController alloc]init];
                [self.navigationController pushViewController:videoView animated:YES];
            }else if ([[alert textFieldAtIndex:0].text isEqualToString:@"518520"]) {
                YBCamouflageWatchController *videoView = [[YBCamouflageWatchController alloc]init];
                [self.navigationController pushViewController:videoView animated:YES];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password mistake" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                alert.alertViewClickedButtonAtIndexBlock = ^(UIAlertView *alert ,NSUInteger index) {
                };
                [alert show];
            }
        }
    };
    [alert show];
}



@end
