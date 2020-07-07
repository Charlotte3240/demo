//
//  ViewController.m
//  iPhone自动拍照
//
//  Created by 刘春奇 on 2017/11/8.
//  Copyright © 2017年 com.cloudnapps. All rights reserved.
//

#import "ViewController.h"
#import "GCQiniuUploadManager.h"
@interface ViewController ()<AVCapturePhotoCaptureDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cameraSetting];
    [self takePhotoAction:nil];
}


- (void)cameraSetting{
    // Device
    if (@available(iOS 10.0, *)) {
        AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
        NSArray *devices  = devicesIOS10.devices;
        _device = devices.lastObject;
    } else {
        _device = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].lastObject;
    }
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    self.imageOutput = [[AVCapturePhotoOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    //设置输出类型
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    _outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    [self.imageOutput setPhotoSettingsForSceneMonitoring:_outputSettings];
    
    //输入输出设备结合
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    
    if ([_device lockForConfiguration:nil]){
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]){
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动对焦
        if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
            [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //自动曝光
        if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]){
            [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        [_device unlockForConfiguration];
    }
    // Start
    [_session startRunning];

    
}
- (IBAction)takePhotoAction:(id)sender {
    [self photoBtnDidClick];
}

- (void)photoBtnDidClick
{
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    [self.imageOutput capturePhotoWithSettings:outputSettings delegate:self];
}


- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
    self.displayImage.image = image;
    
    //上传到七牛
//    [[GCQiniuUploadManager sharedInstance] uploadData:data progress:^(float percent) {
//        NSLog(@"进度=====%f",percent);
//    } completion:^(NSError *error, NSString *link, NSInteger index) {
//        if (error) {
//            NSLog(@"error is %@",error);
//        }else{
//            NSLog(@"link is %@ index is %ld ",link,index);
//        }
//
//    }];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
