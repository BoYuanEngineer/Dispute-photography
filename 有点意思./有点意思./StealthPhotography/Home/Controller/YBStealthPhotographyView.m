//
//  YBStealthPhotographyView.m
//  有点意思.
//
//  Created by Macx on 16/6/5.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "YBStealthPhotographyView.h"

#import <AVFoundation/AVFoundation.h>

@interface YBStealthPhotographyView ()<AVCaptureFileOutputRecordingDelegate>
// 声音
@property(nonatomic, strong) AVCaptureDeviceInput *audioInput;
// 画面
@property(nonatomic, strong) AVCaptureDeviceInput *videoInput;
// 加工厂
@property(nonatomic, strong) AVCaptureSession *session;
// 导出
@property(nonatomic, strong) AVCaptureMovieFileOutput *output;

@property(nonatomic,strong) UIButton *switchBtn;
@property(nonatomic,strong) UIButton *exitBtn;
@property(nonatomic,strong) UIButton *initializeBtn;
@property(nonatomic,strong) UIButton *flipCameraBtn;
@property(nonatomic,strong) UIButton *hideBtn;

@end

@implementation YBStealthPhotographyView
{
    BOOL _isHide;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self creatUI];
}

-(void)clickExitBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden {
    return YES;// 返回YES表示隐藏，返回NO表示显示
}

#pragma mark- 初始化
-(void)clickInitializeBtn {
    if ([_initializeBtn.titleLabel.text isEqualToString:@"success"]) {
        return;
    }
    
    //声音
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
    //画面
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    //加工厂的初始化
    self.session = [[AVCaptureSession alloc] init];
    //导出
    self.output = [[AVCaptureMovieFileOutput alloc] init];
    // 录制视频的时候，视频长度超过10s，没有声音的解决方案
    self.output.movieFragmentInterval = kCMTimeInvalid;
    //把输入和输出,添加到加工厂中.
    if ([self.session canAddInput:self.audioInput]) {
        [self.session addInput:self.audioInput];
    }
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
//        // 添加一个特殊的layer层,才能够显示实时画面
//        AVCaptureVideoPreviewLayer *prelayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
//        prelayer.frame = self.view.bounds;
//        [self.view.layer addSublayer:prelayer];
//        [self.view.layer insertSublayer:prelayer atIndex:0];
    
    //开启加工厂
    [self.session startRunning];
    
    [_initializeBtn setTitle:@"success" forState:UIControlStateNormal];
    [_flipCameraBtn setTitle:@"after" forState:UIControlStateNormal];
}

#pragma mark - 开关
-(void)clickSwitchBtn {
    if (![_initializeBtn.titleLabel.text isEqualToString:@"success"]) {
        return;
    }
    if ([self.output isRecording]) {
        // 停止录制
        [self.output stopRecording];
    } else {
        USERDEFAULTS
        NSInteger videoIndex;
        if ([userDefault objectForKey:@"videoIndex"]) {
            videoIndex = [[userDefault objectForKey:@"videoIndex"] integerValue];
        } else {
            videoIndex = 0;
        }
        videoIndex++;
        [userDefault setObject:[NSString stringWithFormat:@"%ld",(long)videoIndex] forKey:@"videoIndex"];
        
        // 保存录制的东西到沙盒
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [path objectAtIndex:0];
        //创建目录
        NSString *createPath = [NSString stringWithFormat:@"%@/video", documentDirectory];
        // 判断文件夹是否存在，如果不存在，则创建
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
            [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *videoTitle;
        if (STRING_IS_NIL(self.videoTitle)) {
            videoTitle = @"录制的视频";
        }else {
            videoTitle = self.videoTitle;
        }
        NSString *filePath = [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld.mp4",videoTitle,(long)videoIndex]];
        //开始录制
        [self.output startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath] recordingDelegate:self];
    }
}

#pragma mark - 翻转相机
- (void)clickFlipCameraBtn {
    if ([_flipCameraBtn.titleLabel.text isEqualToString:@"flipCamera"]) {
        return;
    }
    if ([_flipCameraBtn.titleLabel.text isEqualToString:@"after"]) {
        [_flipCameraBtn setTitle:@"before" forState:UIControlStateNormal];
    } else {
        [_flipCameraBtn setTitle:@"after" forState:UIControlStateNormal];
    }
    
    NSArray *inputs =self.session.inputs;
    for (AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera =nil;
            AVCaptureDeviceInput *newInput =nil;
            
            if (position ==AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}

#pragma mark - 隐藏UI
- (void)clickHideBtn {
    _isHide = !_isHide;
    if (_isHide) {
        [self HideUI:YES alpha:0];
    } else{
        [self HideUI:NO alpha:1];
    }
}
- (void)HideUI:(BOOL)isHide alpha:(int)alpha {
    _switchBtn.hidden = isHide;
    _exitBtn.hidden = isHide;
    _initializeBtn.hidden = isHide;
    _flipCameraBtn.hidden = isHide;
    _hideBtn.titleLabel.alpha = alpha;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
#pragma mark -结束录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"finish");
    [_switchBtn setTitle:@"finish" forState:UIControlStateNormal];
}
#pragma mark -开始录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"start");
    [_switchBtn setTitle:@"start" forState:UIControlStateNormal];
}

#pragma mark - 懒加载UI
- (void)creatUI {
    
    [self.view addSubview:self.switchBtn];
    [self.view addSubview:self.exitBtn];
    [self.view addSubview:self.initializeBtn];
    [self.view addSubview:self.flipCameraBtn];
    [self.view addSubview:self.hideBtn];
    
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10*UIScreenWidthScale);
        make.left.offset(15*UIScreenWidthScale);
        make.width.offset(80*UIScreenWidthScale);
        make.height.offset(30*UIScreenWidthScale);
    }];
    [_initializeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10*UIScreenWidthScale);
        make.left.equalTo(_switchBtn.right).offset(15*UIScreenWidthScale);
        make.width.offset(80*UIScreenWidthScale);
        make.height.offset(30*UIScreenWidthScale);
    }];
    [_exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_initializeBtn);
        make.right.offset(-15*UIScreenWidthScale);
        make.width.offset(50*UIScreenWidthScale);
        make.height.offset(20*UIScreenWidthScale);
    }];
    [_flipCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10*UIScreenWidthScale);
        make.left.equalTo(_initializeBtn.right).offset(5*UIScreenWidthScale);
        make.width.offset(100*UIScreenWidthScale);
        make.height.offset(30*UIScreenWidthScale);
    }];
    [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-5*UIScreenWidthScale);
        make.left.offset(5*UIScreenWidthScale);
        make.height.offset(40*UIScreenWidthScale);
        make.width.offset(90*UIScreenWidthScale);
    }];
}

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc]init];
        [_exitBtn setTitle:@"back" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(clickExitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc]init];
        [_switchBtn setTitle:@"switch" forState:UIControlStateNormal];
        [_switchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(clickSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

- (UIButton *)initializeBtn {
    if (!_initializeBtn) {
        _initializeBtn = [[UIButton alloc]init];
        [_initializeBtn setTitle:@"initialize" forState:UIControlStateNormal];
        [_initializeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_initializeBtn addTarget:self action:@selector(clickInitializeBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _initializeBtn;
}

- (UIButton *)flipCameraBtn {
    if (!_flipCameraBtn) {
        _flipCameraBtn = [[UIButton alloc]init];
        [_flipCameraBtn setTitle:@"flipCamera" forState:UIControlStateNormal];
        [_flipCameraBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_flipCameraBtn addTarget:self action:@selector(clickFlipCameraBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flipCameraBtn;
}

- (UIButton *)hideBtn {
    if (!_hideBtn) {
        _hideBtn = [[UIButton alloc]init];
        [_hideBtn setTitle:@"Hide" forState:UIControlStateNormal];
        [_hideBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_hideBtn addTarget:self action:@selector(clickHideBtn) forControlEvents:UIControlEventTouchUpInside];
        _isHide = NO;
    }
    return _hideBtn;
}


- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}





















@end
