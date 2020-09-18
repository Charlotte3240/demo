//
//  ViewController.m
//  调用系统邮件
//
//  Created by 红尘 on 15/8/18.
//  Copyright (c) 2015年 红尘. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
@interface ViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
}
- (void)btnAction{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];     //创建邮件controller
    
    mailPicker.mailComposeDelegate = self;  //设置邮件代理
    
//    [mailPicker setSubject:@"Send WebView ScreenShot"]; //邮件主题
    
    //设置发送给谁，参数是NSarray
    [mailPicker setToRecipients:[NSArray arrayWithObjects:@"Artinfo@k11.com", nil]];
    
    
    //   [mailPicker setCcRecipients:[NSArray arrayWithObject:@"zhuqil@163.com"]]; //可以添加抄送
    
    
    // [mailPicker setBccRecipients:[NSArray arrayWithObject:@"secret@gmail.com"]];
    
//    [mailPicker setMessageBody:@"WebShotScreen n in Attachment!" isHTML:NO];     //邮件主题
    
//    NSData *imageData = UIImagePNGRepresentation(viewImage);
    //这里获取截图存入NSData，用于发送附件
    
//    [mailPicker addAttachmentData:imageData mimeType:@"image/png" fileName:@"WebScreenShot"];
    //发送附件的NSData，类型，附件名
    
    [self presentViewController:mailPicker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
        
        switch (result){
                
            case MFMailComposeResultCancelled:
                NSLog(@"Mail send canceled…");
                
                break;
                
            case MFMailComposeResultSaved:
                NSLog(@"Mail saved…");
                
                break;
                
            case MFMailComposeResultSent:
                NSLog(@"Mail sent…");
                
                break;
                
            case MFMailComposeResultFailed:
                NSLog(@"Mail send errored: %@…", [error localizedDescription]);
                
                break;
                
            default:
                break;
                
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
