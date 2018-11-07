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
    NSString *licencing = @"<LicenseContract><Customer>dev9803@topflames.com</Customer><OrderId>Trial</OrderId><LicenseCount>1</LicenseCount><IsTrialLicense>true</IsTrialLicense><SupportExpires>12/07/2018 00:00:00</SupportExpires><ProductCode>SC-IOS-2D-ENTERPRISE-SRC</ProductCode><KeyCode>88b306f2360c296fa6fe51d67e2286054a89665acb7fe5ebffee52e6a9dfd315ca9a4e6eb8e2a2c4bd9264d3a7764a8ca68c19001329bcf115c804d136fabaea61c145181485d0c90e02d3343787aed9e81b9bb4a2cc14e34dec59d1b3cf09dafa8099265abe7ab154ec037744f44c9cc9933870dfe8ae8bc2066f8abd3af5c8ce8bfc577a35f653cfe381d81e6480c3a7e0d6ae5dda88dab66f996728d8566d7ebe6010d12702fa585d95</KeyCode></LicenseContract>";
    
    
    
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
