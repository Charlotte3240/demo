//
//  ViewController.m
//  CoreNfcTour
//
//  Created by 刘春奇 on 2017/8/29.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"
#import <CoreNFC/CoreNFC.h>
@interface ViewController ()<NFCNDEFReaderSessionDelegate>
@property (strong, nonatomic) NFCNDEFReaderSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.session) {
        [self.session invalidateSession];//关闭以前的Session
    }
    self.session = [[NFCNDEFReaderSession alloc]initWithDelegate:self queue:dispatch_get_main_queue() invalidateAfterFirstRead:YES];
    
    if (NFCNDEFReaderSession.readingAvailable) {
        self.session.alertMessage = @"把卡放到手机背面";
        [self.session beginSession];
    }else{
        NSLog(@"不能读");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error{
    NSLog(@"%@",error);
    if (error.code == 201) {
        NSLog(@"扫描超时");
    }
    if (error.code == 1) {
        NSLog(@"不支持的设备");
    }
    if (error.code == 200) {
        NSLog(@"取消扫描");
    }
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages{
    // 读取成功
    for (NFCNDEFMessage *msg in messages) {
        NSArray *ary = msg.records;
        for (NFCNDEFPayload *rec in ary) {
            
            NFCTypeNameFormat typeName = rec.typeNameFormat;
            NSData *payload = rec.payload;
            NSData *type = rec.type;
            NSData *identifier = rec.identifier;
            
            NSLog(@"TypeName : %d",typeName);
            NSLog(@"Payload : %@",payload);
            NSLog(@"Type : %@",type);
            NSLog(@"Identifier : %@",identifier);
        }
    }
   
}



@end
