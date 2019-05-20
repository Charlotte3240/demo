//
//  HomeViewController.m
//  ScanImage
//
//  Created by admin on 2019/5/20.
//  Copyright © 2019 com.hc-nsqk.hc. All rights reserved.
//

#import "HomeViewController.h"
#import "HCScan/HCScanViewController.h"
@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showScan"]){
        HCScanViewController *scanVc = segue.destinationViewController;
        scanVc.callBack = ^(NSString *result) {
            NSLog(@"%@", result);
            self.resultLabel.text = result;
        };
    }
    
    
}


- (IBAction)showScanAction:(UIButton *)sender {
        [self performSegueWithIdentifier:@"showScan" sender:sender];

}


@end
