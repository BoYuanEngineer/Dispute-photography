



//
//  YBWatchVideoController.m
//  有点意思.
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "YBWatchVideoController.h"
#import "YBWatchVideoCell.h"
#import "YBPlayerVideoController.h"
#import <KYAlertView.h>

@interface YBWatchVideoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray *videoList;

@property (nonatomic,copy)NSString *videoPath;
@end

@implementation YBWatchVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"My Video";
    
    [self loadVideoList];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 文件路径
- (void)loadVideoList {
    _videoPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    _videoList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/video",_videoPath] error:nil]];
}

#pragma mark - 计算文件大小
- (NSString *)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist){
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        
        NSString *memorySize;
        if (fileSize >= pow(10, 9)) { // size >= 1GB
            memorySize = [NSString stringWithFormat:@"%.2fGB", fileSize / pow(10, 9)];
        } else if (fileSize >= pow(10, 6)) { // 1GB > size >= 1MB
            memorySize = [NSString stringWithFormat:@"%.2fMB", fileSize / pow(10, 6)];
        } else if (fileSize >= pow(10, 3)) { // 1MB > size >= 1KB
            memorySize = [NSString stringWithFormat:@"%.2fKB", fileSize / pow(10, 3)];
        } else { // 1KB > size
            memorySize = [NSString stringWithFormat:@"%zdB", fileSize];
        }
        return memorySize;
    } else {
        return 0;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - tableView协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YBWatchVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YBWatchVideoCell"];
    if(cell == nil){
        cell = [[YBWatchVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YBWatchVideoCell"];
    }
    cell.textLabel.text = _videoList[indexPath.row];
    
    NSString *videoPath = [NSString stringWithFormat:@"%@/video/%@", _videoPath, _videoList[indexPath.row]];
    cell.memorySize.text = [self fileSizeAtPath:videoPath];
        
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*UIScreenWidthScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *videoPath = [NSString stringWithFormat:@"%@/video/%@", _videoPath, _videoList[indexPath.row]];

    YBPlayerVideoController *playVideoVC = [[YBPlayerVideoController alloc]init];
    playVideoVC.videoStr = _videoList[indexPath.row];
    playVideoVC.videoPath = videoPath;
    [self.navigationController pushViewController:playVideoVC animated:YES];
}

//侧滑
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whether or not to delete?" message:nil delegate:nil cancelButtonTitle:@"Cancle" otherButtonTitles:@"YES",nil];
        alert.alertViewClickedButtonAtIndexBlock = ^(UIAlertView *alert ,NSUInteger index) {
            if (index == 1) {
                
                NSString *videoPath = [NSString stringWithFormat:@"%@/video/%@", _videoPath, _videoList[indexPath.row]];
                NSFileManager* fileManager=[NSFileManager defaultManager];
                BOOL isHave=[[NSFileManager defaultManager] fileExistsAtPath:videoPath];
                if (!isHave) {
                    return ;
                }else {
                    BOOL isDele= [fileManager removeItemAtPath:videoPath error:nil];
                    if (isDele) {
                        [self loadVideoList];
                        [self.tableView reloadData];
                    }
                }
            }
        };
        [alert show];
    }];
    UITableViewRowAction *renameAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"rename" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rename title" message:@"Please enter a new title" delegate:nil cancelButtonTitle:@"Cancle" otherButtonTitles:@"OK",nil];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
        [[alert textFieldAtIndex:0] setSecureTextEntry:NO];
        [[alert textFieldAtIndex:0] setPlaceholder:@"Please Enter The Title"];
        alert.alertViewClickedButtonAtIndexBlock = ^(UIAlertView *alert ,NSUInteger index) {
            
            if (index == 1) {
                
                if (!STRING_IS_NIL([alert textFieldAtIndex:0].text)) {
                    
                    //通过移动该文件对文件重命名
                    NSString *documentsPath =[NSString stringWithFormat:@"%@/video",_videoPath];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *filePath = [documentsPath stringByAppendingPathComponent:_videoList[indexPath.row]];
                    NSString *moveToPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[alert textFieldAtIndex:0].text]];
                    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
                    if (isSuccess) {
                        [self loadVideoList];
                        [self.tableView reloadData];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rename failure" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        alert.alertViewClickedButtonAtIndexBlock = ^(UIAlertView *alert ,NSUInteger index) {
                        };
                        [alert show];
                    }
                }
            }
        };
        [alert show];
    }];
    renameAction.backgroundColor = [UIColor orangeColor];

    return @[deleteAction,renameAction];
}




























#pragma mark - 侧滑另一种写法
//// Cell可编辑
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//// 编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//// 进入编辑模式，按下出现的编辑按钮后,进行操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        NSString *videoPath = [NSString stringWithFormat:@"%@/video/%@", _videoPath, _videoList[indexPath.row]];
//        NSFileManager* fileManager=[NSFileManager defaultManager];
//        BOOL isHave=[[NSFileManager defaultManager] fileExistsAtPath:videoPath];
//        if (!isHave) {
//            return ;
//        }else {
//            BOOL isDele= [fileManager removeItemAtPath:videoPath error:nil];
//            if (isDele) {
//                [self loadVideoList];
//                [self.tableView reloadData];
//            }else {
//            }
//        }
//    }
//}
//
//// 修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

//- (void)renameFileName
//{
//    //通过移动该文件对文件重命名
//    NSString *documentsPath =[self getDocumentsPath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
//    NSString *moveToPath = [documentsPath stringByAppendingPathComponent:@"rename.txt"];
//    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
//    if (isSuccess) {
//        NSLog(@"rename success");
//    }else{
//        NSLog(@"rename fail");
//    }
//}


@end
