//
//  HCScanViewController.m
//  ScanImage
//
//  Created by 刘春奇 on 2017/8/17.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "HCScanViewController.h"

@interface HCScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *preView; //预览层加载的view
@property (weak, nonatomic) IBOutlet UIView *holeView; //黑色半透明

@end

@implementation HCScanViewController{
    CGRect _holeRect;
    UIView *_boxView; //preView 上的
    NSString *_stringValue;  //二维码信息
    UIImageView *_shadowImage; //渐变图片
    NSTimer *_timer;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //相机设置
    [self cameraSetting];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self doRotateAction:nil];

}
//扣出中间扫码区域
- (void)maskToHoleView{
    NSInteger kRadius = 150; //边长
    CGRect bounds = self.holeView.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGRect const circleRect = CGRectMake(CGRectGetMidX(bounds) - kRadius,
                                         CGRectGetMidY(bounds) - kRadius,
                                         2 * kRadius, 2 * kRadius);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:circleRect];
    [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.holeView.layer.mask = maskLayer;
    _holeRect = circleRect;
   
    UIImageView *topLeftImageView;
    UIImageView *topRightImageView;
    UIImageView *bottomLeftImageView;
    UIImageView *bottomRightImageView;
    if (!_boxView) {  //创建boxview
        _boxView = [[UIView alloc]initWithFrame:_holeRect];
        //添加四个边角的框
        topLeftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ScanQR1.png"]];
        topRightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ScanQR2.png"]];
        bottomLeftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ScanQR3.png"]];
        bottomRightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ScanQR4.png"]];
        
        [_boxView addSubview:topLeftImageView];
        [_boxView addSubview:topRightImageView];
        [_boxView addSubview:bottomLeftImageView];
        [_boxView addSubview:bottomRightImageView];
        
        //渐变图片移动
        _shadowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shadow.png"]];
        _shadowImage.frame = CGRectMake(0, -_boxView.bounds.size.height, _boxView.bounds.size.width, _boxView.bounds.size.height);
        [_boxView addSubview:_shadowImage];
        _boxView.layer.masksToBounds = YES;
        //添加boxview
        [self.preView addSubview:_boxView];
    }else{
        _boxView.frame = _holeRect;
    }

    topLeftImageView.frame = CGRectMake(0, 0, topLeftImageView.bounds.size.width, topLeftImageView.bounds.size.height);
    topRightImageView.frame = CGRectMake(_boxView.bounds.size.width - topRightImageView.bounds.size.width, 0, topRightImageView.bounds.size.width, topRightImageView.bounds.size.height);
    bottomLeftImageView.frame = CGRectMake(0,_boxView.bounds.size.height  - bottomLeftImageView.bounds.size.height, bottomLeftImageView.bounds.size.width, bottomLeftImageView.bounds.size.height);
    bottomRightImageView.frame = CGRectMake(_boxView.bounds.size.width - bottomRightImageView.bounds.size.width,_boxView.bounds.size.height - bottomRightImageView.bounds.size.height, bottomRightImageView.bounds.size.width, bottomRightImageView.bounds.size.height);
}

- (void)cameraSetting{

    // Device
    if (@available(iOS 10.0, *)) {
        AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        NSArray *devices  = devicesIOS10.devices;
        _device = devices.lastObject;
    } else {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    _output.rectOfInterest = _boxView.bounds;

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
    
    //设置扫描后的代理
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    //session添加input
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    //session添加output
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    //注意 设置metadataObjectTypes 一定要在添加好了out后写
    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];


    // Preview layer
    _preViewLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preViewLayer.frame = _preView.bounds;
    _preViewLayer.connection.videoOrientation = [self getDeviceDirection];
    [self.preView.layer insertSublayer:self.preViewLayer atIndex:0];

    //启动一个timer 移动渐变图片
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moveShadowImage:) userInfo:nil repeats:YES];
    [_timer fire];

    // Start
    [_session startRunning];
    
}

- (void)moveShadowImage:(NSTimer *)timer
{
    _shadowImage.frame = CGRectMake(0, -_boxView.bounds.size.height, _boxView.bounds.size.width, _boxView.bounds.size.height);

    [UIView animateWithDuration:1.5f animations:^{
        _shadowImage.frame = CGRectMake(0, _boxView.frame.size.height, _boxView.frame.size.width, _boxView.frame.size.height);
    }];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        _stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:_stringValue preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_session startRunning];

    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)doRotateAction:(NSNotification *)notification {

    _preViewLayer.frame = _preView.bounds;
    _preViewLayer.connection.videoOrientation = [self getDeviceDirection];
    [self maskToHoleView];

}
- (AVCaptureVideoOrientation)getDeviceDirection{
    switch ([[UIDevice currentDevice] orientation]) {
            
        case UIDeviceOrientationLandscapeLeft :
            return AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight :
            return AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortrait :
            return AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown :
            return AVCaptureVideoOrientationPortraitUpsideDown;
            break;
            
        default:
            return AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    
}

@end
