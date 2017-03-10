//
//  HCLanguageTool.m
//  MutableLanguageChange
//
//  Created by 刘春奇 on 2017/2/28.
//  Copyright © 2017年 刘春奇. All rights reserved.
//

#define LANGUAGE_SET @"langeuageset"
#import "HCLanguageTool.h"
#import "AppDelegate.h"
@interface HCLanguageTool()

@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *language;

@end

@implementation HCLanguageTool
+ (id)shardInstance{
    static HCLanguageTool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[HCLanguageTool alloc]init];
        }
    });
    return sharedInstance;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        [self initLanguage];
    }
    return self;
}

- (void)initLanguage{
    NSString *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:LANGUAGE_SET];
    NSString *path;
    if (tmp == nil) {
        tmp = CNS;
    }
    self.language = tmp;
    path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
}

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table{
    if (self.bundle) {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    return NSLocalizedStringFromTable(key, table, @"");
}


- (void)changeNowLanguage{
    if ([self.language isEqualToString:CNS]) {
        [self setNewLanguage:EN];
    }else{
        [self setNewLanguage:CNS];
    }
}

- (void)setNewLanguage:(NSString *)language{
    if ([language isEqualToString:self.language]) {
        return;
    }
    
    if ([language isEqualToString:EN] || [language isEqualToString:CNS] || [language isEqualToString:CNH]) {
        //是包含的三种语言
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    
    self.language = language;
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //重置root controller
    [self resetRootViewController];
}
- (void)resetRootViewController{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = [sb instantiateViewControllerWithIdentifier:@"mainNav"];
    UINavigationController *personNav = [sb instantiateViewControllerWithIdentifier:@"personNav"];
    UITabBarController *tabVc = (UITabBarController *)delegate.window.rootViewController;
    tabVc.viewControllers = @[mainNav,personNav];
}

@end
