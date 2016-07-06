//
//  LocalNotifications.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 7/5/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsVC.h"

@interface LocalNotifications : NSObject <notificationSwitchDelegate>

@property BOOL notificationsIsSet;

- (void) setupLocalNotifications;

- (void) activateLocalNotificationWithTitle:(NSString *) title bodyText:(NSString *) bodyText taskID:(NSString *) taskId timeInterval:(NSTimeInterval) timeInterval;

- (UIAlertController *) alertUserForAction:(UILocalNotification *) notification;
- (void) takeActionWithLocalNotification:(UILocalNotification *) notification;
- (NSDate *) buildDateFromDateString:(NSString *) dateString andTimeString:(NSString *) timeString;

@end
