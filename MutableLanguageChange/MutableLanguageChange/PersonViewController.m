//
//  PersonViewController.m
//  MutableLanguageChange
//
//  Created by 刘春奇 on 2017/2/28.
//  Copyright © 2017年 刘春奇. All rights reserved.
//

#import "PersonViewController.h"
#import "HCLanguageTool.h"
@interface PersonViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = HCGetStringWithKeyFromTable(@"当前语言", @"LanguageFile");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
