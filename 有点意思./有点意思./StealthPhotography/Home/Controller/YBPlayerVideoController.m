
//
//  YBPlayerVideoController.m
//  有点意思.
//
//  Created by mac on 2017/6/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "YBPlayerVideoController.h"
#import "ZFPlayer.h"
#import <AVFoundation/AVFoundation.h>


@interface YBPlayerVideoController ()<ZFPlayerDelegate>

/** 播放器View的父视图*/
@property (strong, nonatomic) UIView *gPlayerFatherView;
/// 播放器
@property (strong, nonatomic) ZFPlayerView *gPlayerView;
/// 离开页面时候是否在播放
@property (nonatomic, assign,getter=isPlaying) BOOL playing;
/// 播放的model
@property (nonatomic, strong) ZFPlayerModel *gPlayerModel;

@end

@implementation YBPlayerVideoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(BOOL)prefersStatusBarHidden {
    return YES;// 返回YES表示隐藏，返回NO表示显示
}

- (ZFPlayerModel *)gPlayerModel
{
    if (!_gPlayerModel) {
        _gPlayerModel                  = [[ZFPlayerModel alloc] init];
        _gPlayerModel.title            = _videoStr;
        _gPlayerModel.videoURL         = [NSURL fileURLWithPath:_videoPath];
        _gPlayerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _gPlayerModel.fatherView       = self.gPlayerFatherView;
    }
    return _gPlayerModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)loadView {
    [super loadView];
    
    [self setZFPlayer];
}

#pragma mark - 设置播放器
- (void)setZFPlayer{
    
    self.gPlayerFatherView = [[UIView alloc] init];
    [self.view addSubview:self.gPlayerFatherView];
    [self.gPlayerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.top.equalTo(self.view);
    }];
    self.gPlayerView = [[ZFPlayerView alloc] init];
    //    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    [self.gPlayerView playerControlView:nil playerModel:self.gPlayerModel];
    // 设置代理
    self.gPlayerView.delegate = self;
    // 打开下载功能（默认没有这个功能）
    //        self.gPlayerView.hasDownload    = YES;
    // 打开预览图
    //    self.gPlayerView.hasPreviewView = YES;
    // 是否自动播放，默认不自动播放
    [self.gPlayerView autoPlayTheVideo];
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
