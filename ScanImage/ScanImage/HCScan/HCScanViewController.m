//
//  HCScanViewController.m
//  ScanImage
//
//  Created by 刘春奇 on 2017/8/17.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "HCScanViewController.h"

@interface HCScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation HCScanViewController{
    CGRect _holeRect; //从半透明中扣出透明的区域
    UIView *_boxView; //preView 上的限制扫码view
    NSString *_stringValue;  //二维码信息
    UIImageView *_shadowImage; //渐变图片
    NSTimer *_timer; //控制扫码动画的时间
    UIView *_preView; //预览层加载的view
    UIView *_holeView; //黑色半透明
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //设置UI
    [self maskToHoleView];
    
    //相机设置
    [self cameraSetting];


}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //调整旋转方向
    [self doRotateAction:nil];


}
//扣出中间扫码区域
- (void)maskToHoleView{
    

    if (_preView == nil) {
        _preView = [[UIView alloc] init];
        _preView.bounds = self.view.bounds;
        [self.view addSubview:_preView];

    }
    _preView.center = self.view.center;
    
    if (_holeView == nil) {
        _holeView = [[UIView alloc]init];
        _holeView.bounds = self.view.bounds;
        _holeView.backgroundColor = [UIColor blackColor];
        _holeView.alpha = 0.5;
        [self.view addSubview:_holeView];

    }
    _holeView.center = self.view.center;
    

    
    
    NSInteger kRadius = 150; //边长的一半
    CGRect bounds = _holeView.bounds;
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
    _holeView.layer.mask = maskLayer;
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
        [_preView addSubview:_boxView];
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
    
    
    //设置感兴趣的区域  或者说是 扫描区域 （y,x,w,h） y、x、w、h 为比例
    
    CGSize size = self.view.bounds.size;
    _output.rectOfInterest = CGRectMake(_holeRect.origin.y/size.height, _holeRect.origin.x/size.width, _holeRect.size.width/size.width, _holeRect.size.height/size.height);


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
    [_preView.layer insertSublayer:self.preViewLayer atIndex:0];


    
    //启动一个timer 移动渐变图片
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moveShadowImage:) userInfo:nil repeats:YES];
    [_timer fire];

    // Start
    [_session startRunning];
    
}

- (void)moveShadowImage:(NSTimer *)timer
{
    _shadowImage.frame = CGRectMake(0, -_boxView.bounds.size.height, _boxView.bounds.size.width, _boxView.bounds.size.height);
    _output.rectOfInterest = _boxView.bounds;

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
        
        
        [_session stopRunning];
        
        NSLog(@"scan result is %@",_stringValue);
        if (self.callBack != nil){
            self.callBack(metadataObject.stringValue);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:_stringValue preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [_session startRunning];
//
//        }];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];

    }
    
}


- (void)doRotateAction:(NSNotification *)notification {


    _preViewLayer.frame = _preView.bounds;
    _preViewLayer.connection.videoOrientation = [self getDeviceDirection];
    _output.rectOfInterest = _boxView.bounds;

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
