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
    NSString *licencing = @"<LicenseContract><Customer>dev9802@topflames.com</Customer><OrderId>Trial</OrderId><LicenseCount>1</LicenseCount><IsTrialLicense>true</IsTrialLicense><SupportExpires>09/20/2018 00:00:00</SupportExpires><ProductCode>SC-IOS-2D-ENTERPRISE-SRC</ProductCode><KeyCode>c2a3917ca7a5d7225ab8a386eeff308f4bb6ad369cfbd9cd8d0f0043faeed86e4833a2268f49717c899df251c3ddf63b71e65cbfb886e802890c7d08e422689660cdf208e1c00dafa163d95c0c1c7dfa1992e5d7c8026e300836ccc44e7f6eb72b3e620a52ed7f4a015a769622a4956774442b480be60c3c442e798402cba36e061874669228d301fa6bb93cb6afa3e6c3bfb18da3e3b4ed80e14d6ec14c544ae59f173fa5ee85b338831e</KeyCode></LicenseContract>";
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
