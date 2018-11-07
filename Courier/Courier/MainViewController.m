//
//  MainViewController.m
//  Courier
//
//  Created by 刘春奇 on 2017/7/6.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "MainViewController.h"
#import "HCQuery.h"
#import "InfoDetailViewController.h"
#import "ZXingObjC.h"
#import "HCScanViewController.h"
@interface MainViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ScanBarCodeDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFiled;

@end

@implementation MainViewController{
    UIImage *_codeImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)qrCodeScan:(id)sender {
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"访问相册中的图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //识别图片中的条形码或者二维码
        [self getCodeFromImage];
    }];
    [alerVC addAction:imageAction];
    
    UIAlertAction *scanImageAction = [UIAlertAction actionWithTitle:@"使用相机扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       //使用相机扫描
        [self scanImage];
    }];
    [alerVC addAction:scanImageAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alerVC addAction:cancelAction];
    
    
    [self.navigationController presentViewController:alerVC animated:YES completion:nil];
    
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //开始查询快递
    [self queryInstance:textField.text];
    return YES;
    
}
- (void)showDetail:(NSDictionary *)body{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoDetailViewController *detailVC = [sb instantiateViewControllerWithIdentifier:@"InfoDetailViewController"];
    detailVC.body = body;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//点击空白取消键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.txtFiled resignFirstResponder];
    [self showDetail:@{}];
    
}
//获取相册中的图片
- (void)getCodeFromImage{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        [self.view makeToast:@"请先授权相册权限"];
        return;
    }
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
  
}
#pragma mark -- <UIImagePickerControllerDelegate>--
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
    _codeImage = info[UIImagePickerControllerOriginalImage];
    [self recognitionCode];
}

- (void)recognitionCode{
    CGImageRef imageToDecode = _codeImage.CGImage;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        NSString *contents = result.text;
        [self queryInstance:contents];
    } else {
        [self.view makeToast: [NSString stringWithFormat:@"%@",error]];
    }
}


- (void)scanImage{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"HCScanImage" bundle:nil];
    HCScanViewController *scanImageVC = [sb instantiateViewControllerWithIdentifier:@"HCScanViewController"];
    scanImageVC.delegate = self;
    [self.navigationController pushViewController:scanImageVC animated:YES];
}

- (void) scanBarCodeResut: (NSString*)resultString{
    [self queryInstance:resultString];
}

- (void)queryInstance:(NSString *)text{
    [SVProgressHUD showWithStatus:@"查询中"];
    [HCQuery queryCourier:text withSuccess:^(NSDictionary *body, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                [SVProgressHUD dismiss];
                //储存单号 查询时间
                [self showDetail:body];
                [self.txtFiled resignFirstResponder];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
