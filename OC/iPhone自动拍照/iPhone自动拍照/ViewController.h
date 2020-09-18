//
//  ViewController.h
//  iPhone自动拍照
//
//  Created by 刘春奇 on 2017/11/8.
//  Copyright © 2017年 com.cloudnapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *displayImage;
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//输出图片
@property (nonatomic ,strong) AVCapturePhotoOutput *imageOutput;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic,strong) AVCapturePhotoSettings *outputSettings;
@end

