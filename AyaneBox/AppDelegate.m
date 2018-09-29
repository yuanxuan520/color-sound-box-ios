//
//  AppDelegate.m
//  AyaneBox
//
//  Created by wenjun on 2018/4/10.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "AppDelegate.h"
#import <SciChart/SciChart.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *licencing = @"<LicenseContract><Customer>yuanxuan@topflames.com</Customer><OrderId>Trial</OrderId><LicenseCount>1</LicenseCount><IsTrialLicense>true</IsTrialLicense><SupportExpires>10/20/2018 00:00:00</SupportExpires><ProductCode>SC-IOS-2D-ENTERPRISE-SRC</ProductCode><KeyCode>ff43f7b854a4c1b8a4edfedd4ec957fdfa78752f8d9a82ba84caf0eb5fe0cc2dcdfec9c765538eb4c4dc9c43a0c1d72df68827fbfda9ede80571d2e1640e7dce4d39c115b36a3a335ed26e06a338506018b89469db836e910424dc3acbf1d4fa94e5729bfbfff1c56386fe94f9fff664015db3b4dd488a110545c412f6dab941ead6435858c0af9c7cea7b4bf8b15c15f9ffcd7b67e2ed356b6821a306177a35f352a1a6a1f7a681819f6279</KeyCode></LicenseContract>";
    [SCIChartSurface setRuntimeLicenseKey:licencing];
    [SCIChartSurface setDisplayLinkRunLoopMode:NSRunLoopCommonModes];
    

    
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
