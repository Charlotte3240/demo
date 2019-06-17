//
//  AppDelegate.m
//  ScanImage
//
//  Created by 刘春奇 on 2017/8/17.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "AppDelegate.h"
#import "HCScan/HCScanViewController.h"
#import "HomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // add fast scan 3d touch
    [self addShortTouch];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




- (void)addShortTouch{
    
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];

    UIApplicationShortcutItem *fastScanItem = [[UIApplicationShortcutItem alloc] initWithType:@"scanType" localizedTitle:@"扫描" localizedSubtitle:@"扫描二维码" icon:icon userInfo:nil];
    
    
    UIApplication *application =  [UIApplication sharedApplication];
    application.shortcutItems = @[fastScanItem];
}



- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    if ([shortcutItem.type isEqualToString: @"scanType"]){
        NSLog(@"scan action");
        
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        if (![[nav.topViewController class] isEqual:[HomeViewController class]]) {
            return ;
        }
        
        HomeViewController *homeVc = (HomeViewController *)nav.topViewController;
        
        [homeVc performSegueWithIdentifier:@"showScan" sender:nil];

        
    }
    
    
}



@end
