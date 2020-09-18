//
//  HomeViewController.m
//  DeviceCheckServerApi
//
//  Created by 刘春奇 on 2017/11/21.
//  Copyright © 2017年 Charlotte. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UILabel *disPlayLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMes:(id)sender {
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.development.devicecheck.apple.com/v1/query_two_bits"]];
    request.HTTPMethod = @"POST";
    [request addValue: @"Bearer <GeneratedJWT>" forHTTPHeaderField:@"Authorization"];
    [request addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    
    // body build
    NSDictionary *dic = @{@"device_token":self.myTextField.text,@"timestamp":@([[NSDate date] timeIntervalSince1970]*1000),@"transaction_id":@"transaction_id_hc"};
    NSString *strBody = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    [request setHTTPBody: [strBody dataUsingEncoding:NSUTF8StringEncoding]];

    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            if (res.statusCode == 200) {
                NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
            }else{
                NSLog(@"服务器异常%ld",res.statusCode);
            }
        }else
            NSLog(@"%@",error);
    }];
    [task resume];
    
    
}

@end
