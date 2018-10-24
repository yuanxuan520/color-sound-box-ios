//
//  AppDelegate.m
//  AyaneBox
//
//  Created by wenjun on 2018/4/10.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "AppDelegate.h"
#import <SciChart/SciChart.h>
#import "LoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *licencing = @"<LicenseContract><Customer>yuanxuan1@foxmail.com</Customer><OrderId>Trial</OrderId><LicenseCount>1</LicenseCount><IsTrialLicense>true</IsTrialLicense><SupportExpires>11/15/2018 00:00:00</SupportExpires><ProductCode>SC-IOS-2D-ENTERPRISE-SRC</ProductCode><KeyCode>f52704afc7c80dd67d8153dd7d428722daa5a12fe344637bc2c0943227bed66652c792cb7d71ea963fcaf1fa6443489bb045a7fa7174c6d3e487ccfabe580702fd6422a8980bb12f16a097b7b00738a47516f3df1905ea07a0fd623196bef4fba2cf909fd5f0372a17ab5710c4b10bfb40f41fdf898664a57362d3f1f2e5d71e4c8b59ae055370b914ba7fb4c2a1141949d2387dc9b697df7979becaad7635d5ec0fb8704d8ccdfe4bfea3</KeyCode></LicenseContract>";
    [SCIChartSurface setRuntimeLicenseKey:licencing];
    [SCIChartSurface setDisplayLinkRunLoopMode:NSRunLoopCommonModes];
    

    BOOL isLogin = [USERDEFAULTS objectForKey:@"isLogin"];
    if (isLogin) {
        UIStoryboard * sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabbarVc = [sboard instantiateViewControllerWithIdentifier:@"home"];
        AppDelegate* appDelagete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController = tabbarVc;
    }else {
        UIStoryboard * sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewControl = [sboard instantiateViewControllerWithIdentifier:@"login"];
        AppDelegate* appDelagete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController = loginViewControl;
    }
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


@end
