//
//  ViewController.m
//  ReactiveCocoaTour
//
//  Created by 刘春奇 on 2017/5/2.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self textFiledUse];
    
//    [self buttonUse];
    
//    [self skip];
    
//    [self distinctUntilChanged];
    
//    [self take];
    
//    [self takeLast];
    
//    [self takeUntil];
    
//    [self switchToLatest];
    
//    [self doNextAndDoComplete];
    
//    [self deliverOn];
    
//    [self subscribOn];
    
//    [self interval];
    
//    [self timeOut];
    
//    [self delay];
    
//    [self retry];
    
//    [self replay];
    
//    [self throttle];
    
//    [self sequence];
    
//    [self notificationUse];
    
    [self KVO];
    
}


//textfiled 用法
- (void)textFiledUse{
    
    //直接检测值的变化 坏处是 第一次无变化时也会回调
    @weakify(self);
    [self.textFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSLog(@"textfiled text is %@  x is %@",self.textFiled.text,x);
    }];
    //增加一个过滤条件
    [[self.textFiled.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return [value hasPrefix:@"x"];
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"x is %@",x);
    }];
    
    //过滤掉特殊字符串不进行调用
    [[self.textFiled.rac_textSignal ignore:@"sunny"] subscribeNext:^(NSString *value) {
        NSLog(@"`sunny` could never appear : %@", value);
    }];
    
    //可以有多个订阅者 依次执行
    RACSignal *signal = self.textFiled.rac_textSignal;
    [signal subscribeNext:^(id x) {
        NSLog(@"1111");
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"2222");
    }];

}

- (void)buttonUse{
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"button click");
    }];
}

- (void)skip{
    //跳过前面两个 skip 填写跳过的个数
    RACSubject *subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendNext:@1];
}
- (void)distinctUntilChanged{
    //和上次一样的信号 不会被订阅
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@2]; // 不会被订阅

}

- (void)take{
    //只取前面几个的信号 take:nsinter count
    RACSubject *subject = [RACSubject subject];
    [[subject take:2]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}


- (void)takeLast{
    //只取后面几个的信号 takeLast:nsinter count
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}

- (void)takeUntil{
    //执行到 until的那个信号发出 结束  这里指subject2 发出next 或者 complete
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
    [[subject1 takeUntil:subject2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject1 sendNext:@1];
    [subject1 sendNext:@2];
    
//    [subject2 sendNext:@1];  //和下面 complete 效果相同
    [subject2 sendCompleted];
    
    [subject1 sendNext:@3];

}


- (void)switchToLatest{
    //只获取最新的信号发出的指令 前面的都释放掉
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [signalOfSignals sendNext:signalA];
    [signalOfSignals sendNext:signalB];
    [signalA sendNext:@"signalA"];
    [signalB sendNext:@"signalB"];
    
}

- (void)doNextAndDoComplete{
    [[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"hi"];
        [subscriber sendCompleted];
        
        return nil;
    }]doNext:^(id  _Nullable x) {
        //在执行    [subscriber sendNext:@"hi"];之前先执行
        NSLog(@"do next");
    }]doCompleted:^{
        //在执行    [subscriber sendCompleted];之前先执行
        NSLog(@"do complete");
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

//内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用
- (void)deliverOn{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           NSLog(@"%@",[NSThread currentThread]);
           [subscriber sendNext:@1];
           [subscriber sendCompleted];
           return nil;
       }]
        //交付给主线程
        deliverOn:[RACScheduler mainThreadScheduler] ]
        subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
            NSLog(@"%@",[NSThread currentThread]);
       }];
    });
}
//内容传递和副作用都会切换到制定线程中
- (void)subscribOn{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"%@",[NSThread currentThread]);
            [subscriber sendNext:@"123"];
            [subscriber sendCompleted];
            return nil;
        }]
        subscribeOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
            NSLog(@"%@",[NSThread currentThread]);
        }];
    });
}

- (void)interval{
    //定时器
    [[RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)timeOut{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //无任何操作 等超时
//        [subscriber sendNext:@"ddsa"];
//        NSError *error = [[NSError alloc]initWithDomain:@"unknwn domain" code:600 userInfo:@{@"error":@"超时"}];
//        [subscriber sendError:error];
//        [subscriber sendCompleted];
        return nil;
    }] timeout:3 onScheduler:[RACScheduler mainThreadScheduler]]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }error:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

- (void)delay{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"send next");
        [subscriber sendNext:@"delay msg"];
        [subscriber sendCompleted];
        return nil;
    }] delay:2]
        subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
    }];
}

- (void)retry{
    //重试
    //不执行error block  一直到send next 结束
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (i == 5) {
            [subscriber sendNext:@"send next"];
        }else{
            [subscriber sendError:[NSError errorWithDomain:@"unknown domain" code:600 userInfo:@{@"msg":[NSString stringWithFormat:@"%d",i]}]];
        }
        i ++;
        return  nil;
    }]
      retry]
     
     subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }error:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

- (void)replay{
    //多个订阅者 只执行一遍副作用  没有replay 要重复执行副作用
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)throttle{
    //节流 间隔1s以后 订阅者获取最新信号发出的指令 在1S内  sendNext都不会进subscribeBlock中
    RACSubject *subject = [RACSubject subject];
    
    [[subject throttle:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendNext:@4];

}

- (void)sequence{
//    遍历数组
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
//    遍历字典
    NSDictionary *dict = @{@"name":@"张旭",@"age":@24};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        NSLog(@"%@ %@",key,value);
        
    }];

    
}

- (void)notificationUse{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"notificationName" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"notificaiton is %@",x);
    }];
}

- (void)KVO{
    UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, 200, 400)];
    scrolView.contentSize = CGSizeMake(200, 800);
    scrolView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrolView];
    [RACObserve(scrolView, contentOffset) subscribeNext:^(id x) {
        NSLog(@"success");
    }];
}

@end
