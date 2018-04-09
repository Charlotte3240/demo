//
//  GViewController.m
//  iOS_SocketClientDemo
//
//  Created by 刘春奇 on 2017/11/22.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "GViewController.h"
#import "GCDAsyncSocket.h"

@interface GViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@end

@implementation GViewController{
    GCDAsyncSocket *_socket;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connectServer];
}

- (void)connectServer{
    // 1.与服务器通过三次握手建立连接
    NSString *host = @"192.168.50.128";
    int port = 2333;
    
    //创建一个socket对象
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //连接
    NSError *error = nil;
    [_socket connectToHost:host onPort:port error:&error];
    
    if (error) {
        NSLog(@"connect error is %@",error);
    }
    
}


- (IBAction)sendMes:(id)sender {
    NSString *mes = self.textFiled.text;
    [_socket writeData:[mes dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}


- (IBAction)connect:(id)sender {
    [self connectServer];
}

#pragma mark -socket的代理
#pragma mark 连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"%s",__func__);
}


#pragma mark 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"连接失败 error is %@",err);
    }else{
        NSLog(@"正常断开");
    }
}


#pragma mark 数据发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s",__func__);
    
    //发送完数据手动读取，-1不设置超时
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%s %@",__func__,receiverStr);
}


@end
