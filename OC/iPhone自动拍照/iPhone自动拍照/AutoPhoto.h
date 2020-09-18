//
//  AutoPhoto.h
//  GDSmart
//
//  Created by Charlotte on 2020/7/7.
//  Copyright © 2020 DY 李. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AutoPhoto : NSObject

// init function
- (AutoPhoto *)initWithLocation:(NSString *)location userName:(NSString *)name;

- (void)capture;

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//输出图片
@property (nonatomic ,strong) AVCapturePhotoOutput *imageOutput;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic,strong) AVCapturePhotoSettings *outputSettings;

@property (nonatomic,strong) AVCaptureDeviceInput *frontInput;
@property (nonatomic,strong) AVCaptureDeviceInput *backInput;

// call back
typedef void (^AutoPhotoCallBack)(NSData *front,NSData *back);
@property (nonatomic,copy) AutoPhotoCallBack callBack;



@end

NS_ASSUME_NONNULL_END
