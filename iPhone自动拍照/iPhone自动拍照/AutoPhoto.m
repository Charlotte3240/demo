//
//  AutoPhoto.m
//  GDSmart
//
//  Created by Charlotte on 2020/7/7.
//  Copyright © 2020 DY 李. All rights reserved.
//

#import "AutoPhoto.h"
#import "国动Smart-Swift.h"

@interface AutoPhoto()<AVCapturePhotoCaptureDelegate>

@end

@implementation AutoPhoto{
    BOOL isFront;
    NSData *_frontImage;
    NSData *_backImage;
    NSString *_locationString;
    NSString *_name;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (AutoPhoto *)initWithLocation:(NSString *)location userName:(NSString *)name{
    self = [super init];
    if (self){
        _locationString = location;
        _name = name;
        
    }
    return self;
}


- (void)capture{
    [self startCamera];
}

-(void)startCamera{
    
    
    [self cameraSetting];
    
    // 使用摄像头拍照 延时0.2s 否则镜头进光量很少
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self takePhoto];
    });
    
}


- (void)cameraSetting{
    // Device
    AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    NSArray *devices  = devicesIOS10.devices;
    _device = devices.lastObject;
    

    if (isFront){
        devicesIOS10 = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
        _device = devicesIOS10.devices.lastObject;

    }
    NSLog(@"device %@",_device);
    
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


- (void)takePhoto{
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};

    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    // 自动闪光灯
    outputSettings.flashMode = AVCaptureFlashModeAuto;
    
    [self.imageOutput capturePhotoWithSettings:outputSettings delegate:self];

}

- (void)dealWithPhoto{
    // watermark
    NSDate *date = [NSDate date];
    NSString *dateStr = [date getFormatterString];
    NSString *waterText = [NSString stringWithFormat:@"%@\n%@\n%@",_name,dateStr,_locationString];
    
    
    UIImage *frontImage = [[UIImage alloc]initWithData:_frontImage];
    frontImage = [frontImage drawTextInImageWithText:waterText textColor:UIColor.whiteColor textFont:[UIFont systemFontOfSize:50]];

    UIImage *backImage = [[UIImage alloc]initWithData:_backImage];
    backImage = [backImage drawTextInImageWithText:waterText textColor:UIColor.whiteColor textFont:[UIFont systemFontOfSize:150]];

    // compress
    NSData *frontData = [frontImage compressImageWithMaxLength:100*1024];
    NSData *backData = [backImage compressImageWithMaxLength:100*1024];
    
    if (self.callBack){
        self.callBack(frontData, backData);
    }
    [self close];
    
}

- (void)close{
    [self.session stopRunning];

}


#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error{
    
    if (isFront){
        _frontImage = [photo fileDataRepresentation];
        [self dealWithPhoto];
    }else{
        _backImage = [photo fileDataRepresentation];
        isFront = YES;
        [self startCamera];
    }

}



@end
