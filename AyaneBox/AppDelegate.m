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
    NSString *licencing = @"<LicenseContract><Customer>yuanxuanl@foxmail.com</Customer><OrderId>Trial</OrderId><LicenseCount>1</LicenseCount><IsTrialLicense>true</IsTrialLicense><SupportExpires>08/27/2018 00:00:00</SupportExpires><ProductCode>SC-IOS-2D-ENTERPRISE-SRC</ProductCode><KeyCode>b5ecbf48eb0462e82551a1c130c03e27e2512ef5298bccfd1250731689cd6f90c813a718ece97801c2406808866b7042652f804b158c4cae61d298fca948a8432c707a25c896e481033df8d74e0401e018c064efca031fa0de5985bc74eb17d41ae3c67568bab1d2c5f8aa861ac5718e084b0e09c75228adf1f9bb497a8bc07d377571ee038b5683069f13ae09dfd3a985e32a858ea4650960ad611e57af1dcb6c0d1f62df70df6ac63ae2</KeyCode></LicenseContract>";
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
