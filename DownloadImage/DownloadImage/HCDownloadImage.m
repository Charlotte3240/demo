//
//  HCDownloadImage.m
//  MagicSDKPlayer
//
//  Created by 刘春奇 on 2017/2/10.
//  Copyright © 2017年 刘春奇. All rights reserved.
//

#import "HCDownloadImage.h"

@implementation HCDownloadImage



+ (void)downLoadImages:(NSArray *)urls withProgress





+ (void)downloadImage:(NSURL *)url withCompleteBlock:(FinishDidBlock)finish andErrorBlock:(FailureBlock)failure{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            //copy 文件到文件夹下
            NSFileManager *manager = [NSFileManager defaultManager];
            NSArray *pathArray = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
            NSURL* folderURL = [pathArray firstObject];
            NSURL *folderPath = [folderURL URLByAppendingPathComponent:@"downloadImage" isDirectory:YES];
            NSURL* filePath = [folderPath URLByAppendingPathComponent:response.suggestedFilename];
            BOOL isDir = YES;
            BOOL isExistsFolder = [manager fileExistsAtPath:folderPath.relativePath isDirectory:&isDir];
            
            if (isExistsFolder) {
                //文件夹存在
                NSError *error = nil;
                [manager removeItemAtURL:filePath error:&error];
                BOOL iscopy = [manager moveItemAtURL:location toURL:filePath error:&error];
                if (iscopy) {
                    NSLog(@"移动成功");
                }else{
                    NSLog(@"移动失败 error is %@",error);
                }
               
            }else{
                //不存在文件夹  创建文件夹
                NSError *fileError = nil;
                [manager createDirectoryAtPath:folderPath.relativePath withIntermediateDirectories:YES attributes:nil error:&fileError];
                if (fileError  == nil) {
                    BOOL iscopy = [manager moveItemAtURL:location toURL:filePath error:&fileError];
                    if (iscopy) {
                        NSLog(@"移动成功");
                    }
                }
               

            }
            
            finish([NSString stringWithFormat:@"%@",filePath]);
        }else{
            failure(error);
            NSLog(@"error is %@",error);
        }
    }];
    [task resume];
}


+ (BOOL)checkfolderContainFile:(NSString *)fileName{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *pathArray = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* folderURL = [pathArray firstObject];
    NSURL *folderPath = [folderURL URLByAppendingPathComponent:@"downloadImage" isDirectory:YES];
    NSURL* filePath = [folderPath URLByAppendingPathComponent:fileName];
    BOOL isexist = NO;
    if ([manager fileExistsAtPath:filePath.relativePath isDirectory:&isexist]) {
        NSLog(@"文件存在");
        return YES;
    }
    else {
        NSLog(@"文件不存在");
        return NO;
    }
}

+ (NSURL *)changeServerUrlToLocalUrl:(NSString *)fileName{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *pathArray = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* folderURL = [pathArray firstObject];
    NSURL *folderPath = [folderURL URLByAppendingPathComponent:@"downloadImage" isDirectory:YES];
    NSURL* filePath = [folderPath URLByAppendingPathComponent:fileName];
    return filePath;
}

+ (void)copyToCurrentFolder:(NSString *)fileName{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *pathArray = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* folderURL = [pathArray firstObject];
    NSURL *folderPath = [folderURL URLByAppendingPathComponent:@"downloadImage" isDirectory:YES];
    NSURL* filePath = [folderPath URLByAppendingPathComponent:fileName];
    NSError *error = nil;
    NSURL *bakUrl = [folderPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%@sameName.bak",fileName]];

    BOOL iscopy = [manager copyItemAtURL:filePath toURL:bakUrl error:&error];
    if (iscopy) {
        NSLog(@"重新拷贝防删除成功");
    }
}

+ (void)reloadOriginalName:(NSString *)fileName{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *pathArray = [manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* folderURL = [pathArray firstObject];
    NSURL *folderPath = [folderURL URLByAppendingPathComponent:@"downloadImage" isDirectory:YES];
    NSURL* filePath = [folderPath URLByAppendingPathComponent:fileName];
    NSError *error = nil;
    NSURL *bakUrl = [folderPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%@sameName.bak",fileName]];
    
    BOOL iscopy = [manager copyItemAtURL:bakUrl toURL:filePath error:&error];
    if (iscopy) {
        NSLog(@"把图片按照原来的名称复制回去");
    }else{
        NSLog(@"复制回原图片error is %@",error);
    }
    
    BOOL isremove = [manager removeItemAtURL:bakUrl error:&error];
    if (isremove) {
        NSLog(@"删除bak文件成功");
    }else{
        NSLog(@"删除bak文件error is %@",error);
    }

}


@end
