//
//  ViewController.m
//  iOS_SocketDemo
//
//  Created by 刘春奇 on 2017/8/3.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"


//获取本机局域网ip
#import <ifaddrs.h>
#import <arpa/inet.h>

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
    NSString *ipString = [self getIPAddress];//@"192.168.50.128"
    [_serverSocket disconnect];
    [_serverSocket acceptOnInterface:ipString port:2333 error:&error];
    if (error) {
        NSLog(@"服务器开启失败 error is %@",error);
    }else{
        //开启后台模式
        //        [_serverSocket enableBackgroundingOnSocket];
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
    
    
    //开启socket 服务器
    [self startup];
    
}


- (void)reStart{
    [self initServer];
    [self startChatServer];
    
}

- (void) startup{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reStart)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectAll)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [self initServer];
    [self startChatServer];
}

- (void)disconnectAll{
    [_serverSocket setDelegate:nil delegateQueue:NULL];
    [_serverSocket disconnect];
    _serverSocket = nil;
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




// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

@end
