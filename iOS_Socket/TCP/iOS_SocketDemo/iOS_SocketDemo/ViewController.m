//
//  ViewController.m
//  iOS_SocketDemo
//
//  Created by 刘春奇 on 2017/8/3.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>

@end

@implementation ViewController{
    GCDAsyncSocket *_serverSocket;
    dispatch_queue_t _golbalQueue;
    NSMutableArray *_clientSocket;
}

//启动sever
- (void)startChatServer{
    NSError *error;
    //开启一个可接受的ip(本机ip 注意：模拟器获取不到Ip) 和 端口
    [_serverSocket acceptOnInterface:@"192.168.50.128" port:2333 error:&error];
    if (error) {
        NSLog(@"服务器开启失败 error is %@",error);
    }else{
        NSLog(@"服务器开启成功");
    }
}

- (void)initServer{
    if (!_serverSocket) {
        _clientSocket = [NSMutableArray array];
        _golbalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_golbalQueue];
    }
    NSLog(@"server inited");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initServer];
    [self startChatServer];
    
    
}
#pragma mark 有客户端建立连接的时候调用
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    NSLog(@"new clientSocket is %@",newSocket.connectedHost);
    
    [_clientSocket addObject:newSocket];
    //newSocket为客户端的Socket。这里读取数据
    [newSocket readDataWithTimeout:-1 tag:100];
}

#pragma mark - GCDAsyncSocketDelegate
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:100];
}

#pragma mark - GCDAsyncSocketDelegate
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    //接收到数据
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"服务端收到的数据:%@",receiverStr);
    [sock writeData:[@"mes received" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}





@end
