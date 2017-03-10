//
//  ViewController.m
//  MutableLanguageChange
//
//  Created by 刘春奇 on 2017/2/28.
//  Copyright © 2017年 刘春奇. All rights reserved.
//

#import "ViewController.h"
#import "HCLanguageTool.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = HCGetStringWithKeyFromTable(@"root", @"Main");
    self.navigationController.tabBarItem.title = HCGetStringWithKeyFromTable(@"home", @"Main");
    
}
- (IBAction)changeLanguage:(id)sender {
    [[HCLanguageTool shardInstance] changeNowLanguage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
