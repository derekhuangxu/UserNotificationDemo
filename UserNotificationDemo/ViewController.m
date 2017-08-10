//
//  ViewController.m
//  UserNotificationDemo
//
//  Created by Derek on 2017/8/10.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnCreateWordNotofication:(id)sender {
    
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    content.title = @"NotificationCenter";
    content.subtitle = @"testWord";
    content.body = @"本地通知测试";
    UNTimeIntervalNotificationTrigger * triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    NSString * requestIdentifier = @"request";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:triger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
    
}

- (IBAction)btnCreatePictrueNotofication:(id)sender {
    
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    content.title = @"NotificationCenter";
    content.subtitle = @"testWord";
    content.body = @"本地通知测试";
    
    NSString * imagePath = [[NSBundle mainBundle]pathForResource:@"Notification_Image" ofType:@"png"];
    if (imagePath) {
        UNNotificationAttachment * imageAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"imagePath"
                                                                                                    URL:[NSURL fileURLWithPath:imagePath]
                                                                                                options:nil
                                                                                                  error:nil];
        if (imageAttachment) {
            content.attachments = @[imageAttachment];
        }
    }
    
    UNTimeIntervalNotificationTrigger * triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    NSString * requestIdentifier = @"request";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:triger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
    
}
- (IBAction)btnCreateVideoNotofication:(id)sender {
    
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    content.title = @"NotificationCenter";
    content.subtitle = @"testWord";
    content.body = @"本地通知测试";
    
    NSString * videoPath = [[NSBundle mainBundle]pathForResource:@"Notification_video" ofType:@"mp4"];
    if (videoPath) {
        UNNotificationAttachment * videoAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"videoPath"
                                                                                                    URL:[NSURL fileURLWithPath:videoPath]
                                                                                                options:nil
                                                                                                  error:nil];
        if (videoAttachment) {
            content.attachments = @[videoAttachment];
        }
    }
    
    NSMutableArray * actionArr = [NSMutableArray array];
    UNNotificationAction * actionA = [UNNotificationAction actionWithIdentifier:@"IdentifierUnlock"
                                                                          title:@"进入应用"
                                                                        options:UNNotificationActionOptionForeground];
    UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"IdentifierRed"
                                                                          title:@"Another Action"
                                                                        options:UNNotificationActionOptionDestructive];
    UNNotificationAction * actionC = [UNNotificationAction actionWithIdentifier:@"IdentifierBlack"
                                                                          title:@"Third Action"
                                                                        options:UNNotificationActionOptionAuthenticationRequired];
    
    [actionArr addObjectsFromArray:@[actionA, actionB, actionC]];
    if (actionArr.count > 0) {
        UNNotificationCategory * categoryNotification = [UNNotificationCategory categoryWithIdentifier:@"categoryOperationAction"
                                                                                               actions:actionArr
                                                                                     intentIdentifiers:@[]
                                                                                               options:UNNotificationCategoryOptionCustomDismissAction];
        [[UNUserNotificationCenter currentNotificationCenter]setNotificationCategories:[NSSet setWithObject:categoryNotification]];
        content.categoryIdentifier = @"categoryOperationAction";
    }
    
    UNTimeIntervalNotificationTrigger * triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    NSString * requestIdentifier = @"request";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:triger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}

@end
