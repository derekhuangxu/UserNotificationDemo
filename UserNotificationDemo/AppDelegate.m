//
//  AppDelegate.m
//  NotificationDemo
//
//  Created by Derek on 2017/8/10.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import "AppDelegate.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

#endif


@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //注册远程推送
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [[UNUserNotificationCenter currentNotificationCenter]setDelegate:self];
        UNUserNotificationCenter * notiCenter = [UNUserNotificationCenter currentNotificationCenter];
        [notiCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert |
         UNAuthorizationOptionBadge |
         UNAuthorizationOptionSound
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                      
                                  }];
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [notiCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                                       UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound
                                                                                        categories:nil]];
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];
    }
#pragma clang diagnostic pop
    
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


#ifdef NSFoundationVersionNumber_iOS_9_x_Max

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler {
    
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    
    
}

#endif

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
}


@end
