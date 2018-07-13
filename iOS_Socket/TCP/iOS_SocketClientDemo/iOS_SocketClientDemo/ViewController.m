//
//  ViewController.m
//  iOS_SocketClientDemo
//
//  Created by 刘春奇 on 2017/8/3.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mesTextField;
@property (weak, nonatomic) IBOutlet UITextField *ipSetLabel;
@property (weak, nonatomic) IBOutlet UITextField *portSetLabel;

@end

@implementation ViewController{
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *hostString = [[NSUserDefaults standardUserDefaults]objectForKey:@"host"];
    NSNumber *portNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"port"];
    
    self.ipSetLabel.text = hostString;
    self.portSetLabel.text = [NSString stringWithFormat:@"%ld",portNum.integerValue];
    
    //connect server
    [self connectServer];
}
- (IBAction)connect:(id)sender {
    
    if (self.ipSetLabel.text.length <= 0) {
        return;
    }
    
    if (self.portSetLabel.text.length <= 0) {
        return;
    }
    
    
    [self connectServer];
}

- (void)connectServer{
    
    NSString *host = self.ipSetLabel.text;
    int port = self.portSetLabel.text.intValue;
    
    NSNumber *savePort = [NSNumber numberWithInt:port];
    
    [[NSUserDefaults standardUserDefaults] setObject:host forKey:@"host"];
    [[NSUserDefaults standardUserDefaults] setObject:savePort forKey:@"port"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //创建输入输出流
    CFReadStreamRef readStreamRef;
    CFWriteStreamRef writeStreamRef;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStreamRef, &writeStreamRef);
    _inputStream = (__bridge NSInputStream *)(readStreamRef);
    _outputStream = (__bridge NSOutputStream *)(writeStreamRef);
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    
    // 输入输出流必须加入主运行runLoop中
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [_inputStream open];
    [_outputStream open];
    
}

- (IBAction)sendMes:(id)sender {
    NSString *msg = self.mesTextField.text;
    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [_outputStream write:msgData.bytes maxLength:msgData.length];
    self.mesTextField.text = @"";
    NSLog(@"客户端发送消息:%@",msg);
 
}

#pragma MARK - NSStreamDelegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch(eventCode) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"客户端输入输出流打开完成");
            break;
            
        case NSStreamEventHasBytesAvailable:
            NSLog(@"客户端有字节可读");
            //读取服务端发来的消息
            [self readData];
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"客户端可以发送字节");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"客户端连接出现错误");
            
        {
            NSError *theError = [aStream streamError];
            NSLog(@"%@",[NSString stringWithFormat:@"Error %li: %@",
                         (long)[theError code], [theError localizedDescription]]);
            
        }
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"客户端连接结束");
            //关闭输入输出流
            [_inputStream close];
            [_outputStream close];
            
            //从主运行循环移除
            [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            break;
        default:
            break;
            
    }
    
}

-(void)readData{
    //建立一个缓冲区 可以放1024个字节
    uint8_t buf[1024];
    //返回实际装的字节数
    NSInteger len = [_inputStream read:buf maxLength:sizeof(buf)];
    //把字节数组转化成字符串
    NSData *data =[NSData dataWithBytes:buf length:len];
    //从服务器接收到的数据
    NSString *recStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Socket:读取从服务端发来的消息:%@",recStr);
}


@end
