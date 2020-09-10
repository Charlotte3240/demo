//
//  ViewController.m
//  DownLoadFile
//
//  Created by 刘春奇 on 16/1/5.
//  Copyright © 2016年 cloudnapps.com. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "ZipArchive.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSString *saveDiretory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://docs-assets.developer.apple.com/published/deea378adf/UsingCollectionViewCompositionalLayoutsAndDiffableDataSources.zip"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    //设置路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docspath = [paths objectAtIndex:0];
    
    saveDiretory = [NSString stringWithFormat:@"%@/temp",docspath];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:saveDiretory append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead/totalBytesExpectedToRead;
        NSLog(@"%f",p);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"下载成功");
        NSFileManager *fm = [[NSFileManager alloc]init];
        NSError *error;
        NSLog(@"Documentsdirectory: %@",[fm contentsOfDirectoryAtPath:saveDiretory error:&error]);
        
        
        
//        UIImage *image = [[UIImage alloc]initWithContentsOfFile:saveDiretory];
//        UIImageView *imgview = [[UIImageView alloc]initWithImage:image];
//        imgview.frame = CGRectMake(100, 100, 100, 100);
//        [self.view addSubview:imgview];
        
        //解压
        [self unzipImageAsynchronously];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"下载失败");
    }];
    [operation start];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)unzipImageAsynchronously
{
    // 1. 获取Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docspath = [paths objectAtIndex:0];
    
//    NSString *origFile = [[NSBundle mainBundle] pathForResource:@"image.zip" ofType:nil];
    
    NSFileManager* manager = [[NSFileManager alloc]init];
//    [manager copyItemAtPath:origFile toPath:[docspath stringByAppendingString:@"/image.zip"] error: nil];
    NSString *zipPath = saveDiretory;
    ZipArchive *za = [[ZipArchive alloc] init];
    
    NSLog(@"Documentsdirectory: %@",[manager contentsOfDirectoryAtPath:zipPath error:nil]);

    // 1. 在内存中解压缩文件
    if ([za UnzipOpenFile: zipPath]) {
        // 2. 将解压缩的内容写到缓存目录中
        BOOL ret = [za UnzipFileTo: docspath overWrite: YES];
        if (NO == ret){} [za UnzipCloseFile];
        
        // 3. 使用解压缩后的文件
        NSString *imageFilePath = [docspath stringByAppendingPathComponent:@"image.jpg"];
        NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
        UIImage *img = [UIImage imageWithData:imageData];
//         4. 更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imgview = [[UIImageView alloc]initWithImage:img];
            imgview.frame = CGRectMake(100, 100, 100, 100);
            [self.view addSubview:imgview];
        });
        
    }


}

@end
