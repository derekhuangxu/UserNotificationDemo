### 写在最前
在iOS 10中，之前有关Remote Notification和Local Notification的的杂乱的API被进行了重构，并在iOS 8 以及iOS 9的基础之上进行了功能新的扩展，推出了全新并且独立的 UserNotifications.framework 来集中管理相关通知的各种API。

相对于开发者来说使用起来更加简单易用，相对于运营环节来说，因为新的框架有了`Attachment`以及自定义UI等新的功能，所以有更加灵活的方法来处理相关的通知。


### 接口分析
![UserNotifications.h](http://upload-images.jianshu.io/upload_images/711112-8c23ceff33cede99.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以上为新的UserNotifications.framework 为我们带来的各项接口。

###### 1.<UserNotifications/NSString+UserNotifications.h>
类中只有一个方法

    // Use -[NSString localizedUserNotificationStringForKey:arguments:] to provide a string that will be localized at the time that the notification is presented.
    + (NSString *)localizedUserNotificationStringForKey:(NSString *)key arguments:(nullable NSArray *)arguments __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED;

主要作用是用来提供将在该通知被呈现在时间进行本地化字符串。

##### 2.<UserNotifications/UNError.h>
只有一个属性`UNErrorDomain`以及一个枚举`UNErrorCode`，顾名思义是作为错误属性的值。

##### 3.<UserNotifications/UNNotification.h>
拥有两个属性

    // The date displayed on the notification.
    @property (nonatomic, readonly, copy) NSDate *date;
    // The notification request that caused the notification to be delivered.
    @property (nonatomic, readonly, copy) UNNotificationRequest *request;

一般作为返回的消息实例。

##### 4.<UserNotifications/UNNotificationAction.h>
从名字就可以看出，类的作用就是定义了收到通知后的一些Action操作，有identifier，title，options三个属性，其中options是一个枚举类型

    typedef NS_OPTIONS(NSUInteger, UNNotificationActionOptions) {
    
        // Whether this action should require unlocking before being performed.
        //button为红色，点需要解锁屏幕显示
        UNNotificationActionOptionAuthenticationRequired = (1 << 0),
        // Whether this action should be indicated as destructive
        //button为黑色，点击不会进入App
        UNNotificationActionOptionDestructive = (1 << 1),
        // Whether this action should cause the application to launch in the foreground.
        //button为黑色，点击进入App
        UNNotificationActionOptionForeground = (1 << 2),
    } __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED;


拥有有一个子类UNTextInputNotificationAction，所谓类似回复微信和iMessage时候使用。

##### 5.<UserNotifications/UNNotificationAttachment.h>
通知的附件属性类，里面三个主要属性

    // The identifier of this attachment
    @property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *identifier;

    // The URL to the attachment's data. If you have obtained this attachment from UNUserNotificationCenter then the URL will be security-scoped.
    //附件相关的地址，可为本地地址
    @property (nonatomic, readonly, copy) NSURL *URL;

    // The UTI of the attachment.
    @property (nonatomic, readonly, copy) NSString *type;

另有4个常量

    // Key to manually provide a type hint for the attachment. If not set the type hint will be guessed from the attachment's file extension. Value must be an NSString.
    //手动提供附件类型提示的键。如果没有设置类型提示，将会从附件文件扩展名中猜出类型。值必须是一个NSString格式。
    extern NSString * const UNNotificationAttachmentOptionsTypeHintKey __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0);

    // Key to specify if the thumbnail for this attachment is hidden. Defaults to NO. Value must be a boolean NSNumber.
    // 注明此附件缩略图是隐藏的键。默认值为NO。值必须是一个NSNumber类型的布尔值。
    extern NSString * const UNNotificationAttachmentOptionsThumbnailHiddenKey __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0);

    // Key to specify a normalized clipping rectangle to use for the attachment thumbnail. Value must be a CGRect encoded using CGRectCreateDictionaryRepresentation.
    //指定一个标准化的剪辑矩形用于附件缩略图的键。值必须是使用DictionaryRepresentation编码的一个CGRect值。
    extern NSString * const UNNotificationAttachmentOptionsThumbnailClippingRectKey __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0);

    // Key to specify the animated image frame number or the movie time to use as the thumbnail.
    // An animated image frame number must be an NSNumber. A movie time must either be an NSNumber with the time in seconds or a CMTime encoded using CMTimeCopyAsDictionary.
    //指定动画形象帧数或用缩略图的电影时间的键。
    //动画图像帧数必须是一个NSNumber对象。电影的时间必须是一个NSNumber对象的以秒为单位的时间或使用CMTimeCopyAsDictionary编码的CMTime值。
    extern NSString * const UNNotificationAttachmentOptionsThumbnailTimeKey __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0);

##### 6.<UserNotifications/UNNotificationCategory.h>
用于储存Action的类

    // The unique identifier for this category. The UNNotificationCategory's actions will be displayed on notifications when the UNNotificationCategory's identifier matches the UNNotificationRequest's categoryIdentifier.
    @property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *identifier;

    // The UNNotificationActions in the order they will be displayed.
    //储存我们设置的Actions的数组
    @property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray<UNNotificationAction *> *actions;

    // The intents supported support for notifications of this category. See <Intents/INIntentIdentifiers.h> for possible values.
    @property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray<NSString *> *intentIdentifiers;

    @property (NS_NONATOMIC_IOSONLY, readonly) UNNotificationCategoryOptions options;

options是一个权限的枚举值，两者可以一起使用

    typedef NS_OPTIONS(NSUInteger, UNNotificationCategoryOptions) {
        UNNotificationCategoryOptionNone = (0),
    
        // Whether dismiss action should be sent to the UNUserNotificationCenter delegate
        UNNotificationCategoryOptionCustomDismissAction = (1 << 0),
    
        // Whether notifications of this category should be allowed in CarPlay
        UNNotificationCategoryOptionAllowInCarPlay = (2 << 0),

    } __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED;

#####7.<UserNotifications/UNNotificationContent.h>
可以简单看做是储存所有通知信息的Model类，里面有attachments、sound、title以及userInfo等信息。

拥有一个子类`UNMutableNotificationContent`，和父类的区别从名字就可以看出是可以修改的，个属性中也比父类少了一个`readonly`属性。

##### 8.<UserNotifications/UNNotificationRequest.h>
有三个属性，分别是标示符、消息Model以及NotificationTrigger。

    // The unique identifier for this notification request. It can be used to replace or remove a pending notification request or a delivered notification.
    @property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *identifier;

    // The content that will be shown on the notification.
    @property (NS_NONATOMIC_IOSONLY, readonly, copy) UNNotificationContent *content;

    // The trigger that will or did cause the notification to be delivered. No trigger means deliver now.
    @property (NS_NONATOMIC_IOSONLY, readonly, copy, nullable) UNNotificationTrigger *trigger;


##### 9.<UserNotifications/UNNotificationResponse.h>
通过名字就可以看出来，与request对应作为相应通知的Action使用。
用户可以拿到整个通知的内容，以及操作所对应的标示符。

    // The notification to which the user responded.
    @property (NS_NONATOMIC_IOSONLY, readonly, copy) UNNotification *notification;

    // The action identifier that the user chose:
    // * UNNotificationDismissActionIdentifier if the user dismissed the notification
    // * UNNotificationDefaultActionIdentifier if the user opened the application from the notification
    // * the identifier for a registered UNNotificationAction for other actions
    @property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *actionIdentifier;

子类UNTextInputNotificationResponse还包含userText，可以取到用户输入的内容。

##### 10.<UserNotifications/UNNotificationSettings.h>
主要是通知的一些属性设置，对应属性，有三个枚举值

    typedef NS_ENUM(NSInteger, UNAuthorizationStatus) {
         // The user has not yet made a choice regarding whether the application may post user notifications.
        UNAuthorizationStatusNotDetermined = 0,
    
        // The application is not authorized to post user notifications.
        UNAuthorizationStatusDenied,
    
        // The application is authorized to post user notifications.
        UNAuthorizationStatusAuthorized
    } __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0);

    typedef NS_ENUM(NSInteger, UNNotificationSetting) {
        // The application does not support this notification type
        UNNotificationSettingNotSupported  = 0,
    
        // The notification setting is turned off.
         UNNotificationSettingDisabled,
    
        // The notification setting is turned on.
        UNNotificationSettingEnabled,
    } __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0);

    typedef NS_ENUM(NSInteger, UNAlertStyle) {
        UNAlertStyleNone = 0,
        UNAlertStyleBanner,
        UNAlertStyleAlert,
    } __IOS_AVAILABLE(10.0) __TVOS_PROHIBITED __WATCHOS_PROHIBITED;


##### 11.<UserNotifications/UNNotificationSound.h>
两个方法，一个是设置为默认提示音，一个是设置为自定义提示音。
可以直接使用声音的name，而不是文件路径。

    // The default sound used for notifications.
    + (instancetype)defaultSound;

    // The name of a sound file to be played for the notification. The sound file must be contained in the app’s bundle or in the Library/Sounds folder of the app's data container. If files exist in both locations then the file in ~/Library/Sounds will be preferred.
    + (instancetype)soundNamed:(NSString *)name __WATCHOS_PROHIBITED;

##### 12.<UserNotifications/UNNotificationTrigger.h>
NotificationTrigger算是新增的比较重要的功能，四种方式为App的运用提供了更多可选择的方法。其中，日历和地理位置是新增Trigger。

所以，此类下面有四个子类：push通知触发， 时间通知触发，日历通知触发，地区通知触发。与之相对应的，子类拥有自己出发的属性。

![UNNotificationTrigger](http://upload-images.jianshu.io/upload_images/711112-2d3b188059412704.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 13.<UserNotifications/UNUserNotificationCenter.h>
>吐个槽，为毛和USNotificationCenter长得这么想，第一眼看差点蒙了。

最主要的类，通知的注册，激活，编辑，删除等功能都由该类完成。
通过[UNUserNotificationCenter currentNotificationCenter]单例方法进行操作。

##### 14.<UserNotifications/UNNotificationServiceExtension.h>
里面有两个方法，收到通知的请求后调用， 系统将要销毁时调用。

##### 15.<UserNotifications/UNNotificationContentExtension.h>
>这个类不在UserNotifications.framework中，主要是用作修改通知展示的UI，使用时需要添加UserNotificationsUI.framework。
下文会做详细介绍。


### Notification Extension
从Share Extension等开始，iOS逐渐支持一些利用沙盒等方法的扩展方法。在iOS 10中，与通知有关的有两个：`Service Extension` 和 `Content Extension`。
前者可以让我们有机会在收到远程推送的通知后，展示之前对通知内容进行自定义修改；后者可以用来自定义通知视图的UI样式。

![Notification Extensions](http://upload-images.jianshu.io/upload_images/711112-df6c9918f1b33502.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



##### iOS 10 中被标为弃用的 API
- UILocalNotification
- UIMutableUserNotificationAction
- UIMutableUserNotificationCategory
- UIUserNotificationAction
- UIUserNotificationCategory
- UIUserNotificationSettings
- handleActionWithIdentifier:forLocalNotification:
- handleActionWithIdentifier:forRemoteNotification:
- didReceiveLocalNotification:withCompletion:
- didReceiveRemoteNotification:withCompletion:


# Demo
Demo地址：https://github.com/derekhuangxu/NotificationDemo
>因为iOS 10更改了对于获取权限的限制，所以作为适配来说，希望大家在info.plist文件中更改对于权限的获取相关字段。

#### 1、文字通知
文字通知相对简单，只是需要创建`UNMutableNotificationContent `实体类，创建`UNTimeIntervalNotificationTrigger `的实体类，然后加入到通知中心的单例中，然后触发即可。

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

#### 2、图片通知

与纯文字通知相似，但是需要额外在`UNMutableNotificationContent `中添加`UNNotificationAttachment `属性，剩下的基本相似。需要注意的是，`content.attachments`是一个数组。

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

#### 3、视频通知

视频通知和图片通知的方法是同样的，但是在Demo中，我在视频通知的方法里面添加了3个Action，通过方法，添加到通知中心的单例即可，具体使用方法和作用上文已有介绍。


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
        UNNotificationAction * actionA = [UNNotificationAction actionWithIdentifier:@"IdentifierUnlock" title:@"进入应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"IdentifierRed" title:@"Another Action" options:UNNotificationActionOptionDestructive];
        UNNotificationAction * actionC = [UNNotificationAction actionWithIdentifier:@"IdentifierBlack" title:@"Third Action" options:UNNotificationActionOptionAuthenticationRequired];
    
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


### 最后
本文主要介绍了API的使用，简单书写了一个本地触发通知的简单Demo，后面会单研究一下关于远程推送多媒体通知和自定义UI通知。

### 另
前有Apple Watch，后面有新的widget和新的UserNotifications.framework，苹果似乎很努力的将我们沉浸在手机中的注意力解脱出来，极力避免我们被纷繁的通知和short action打扰而不得不打开App的可能性。

不知道这算不算Apple对于手机的使用又将有新的定义。





### 参考

  * https://onevcat.com/2016/08/notification/
  * http://www.jianshu.com/p/9b720efe3779
  * http://www.cnblogs.com/dsxniubility/p/5596973.html
  * https://developer.apple.com/videos/play/wwdc2016/707/
  * https://developer.apple.com/videos/play/wwdc2016/708/
