//
//  LocalNotifications.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 7/5/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "LocalNotifications.h"
#import "DatabaseService.h"

@implementation LocalNotifications

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationsIsSet"] isEqualToString:@"YES"]) {
            self.notificationsIsSet = YES;
        } else {
            self.notificationsIsSet = NO;
        }
    }
    return self;
}

- (void) setupLocalNotifications {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (void) activateLocalNotificationWithTitle:(NSString *) title bodyText:(NSString *) bodyText taskID:(NSString *) taskId timeInterval:(NSTimeInterval) timeInterval {
    if (!self.notificationsIsSet) {
        return;
    }

    NSMutableArray *taskIdArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"taskIDs"];
    if (taskIdArray != nil) {
        for (NSString *item in taskIdArray) {
            if ([item isEqualToString:taskId]) {
                return;
            }
        }
    }

    NSTimeInterval interval;
    interval = timeInterval;
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    localNotification.alertBody = bodyText;
    localNotification.alertTitle = title;
    localNotification.userInfo = @{@"task-id":taskId};
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //    localNotification.repeatInterval = NSCalendarUnitHour;
    localNotification.soundName = @"sax.aif";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    [taskIdArray addObject:taskId];
    [[NSUserDefaults standardUserDefaults] setObject:taskIdArray forKey:@"taskIDs"];
    NSLog(@"notification set for: %@", [localNotification.userInfo objectForKey:@"task-id"]);
}

- (UIAlertController *) alertUserForAction:(UILocalNotification *) notification {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Ignore was pressed");
        [self clearNotifications];
    }];
    UIAlertAction *viewAction = [UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takeActionWithLocalNotification:notification];
        [self clearNotifications];
    }];

    [alertController addAction:ignoreAction];
    [alertController addAction:viewAction];

    return alertController;
}

- (void) takeActionWithLocalNotification:(UILocalNotification *) notification {
    NSLog(@"action taken >> %@ >> %@ >> %@", [notification.userInfo valueForKey:@"task-id"], notification.alertTitle, notification.alertBody);
}

- (NSDate *) buildDateFromDateString:(NSString *) dateString andTimeString:(NSString *) timeString {
    NSString *fullDateString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
    NSDateFormatter *formatter = [NSDateFormatter new];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSDate *date = [formatter dateFromString:fullDateString];

    return date;
}

- (void) clearNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - notificationSwitchDelegate

- (void)notificationSwitched:(BOOL)notifSwitch {
    if (notifSwitch) {
        [self loadTaskForLocalNotifications];
        NSLog(@"all local notifactions renewed.");
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSLog(@"all local notifactions cleared.");
    }
}

- (void) loadTaskForLocalNotifications {
    if ([FIRAuth auth].currentUser) {
        DatabaseService *service = [DatabaseService new];
        NSArray *tasks = [service loadLocalTasksForUser:[FIRAuth auth].currentUser.uid];
        for (NSDictionary *task in tasks) {
            [self setLocalNotificationForTask:task];
        }
    }
}

- (void) setLocalNotificationForTask:(NSDictionary *) task {

    NSDate *date = [self buildDateFromDateString:[task valueForKey:@"date"]
                                   andTimeString:[task valueForKey:@"time-start"]];
    NSDate *dateNow = [NSDate date];

//    NSLog(@"%f", [date timeIntervalSinceDate:dateNow]);

    if ([date timeIntervalSinceDate:dateNow] > 0) {
        [self activateLocalNotificationWithTitle:[task valueForKey:@"title"]
                                        bodyText:[task valueForKey:@"description"]
                                          taskID:[task valueForKey:@"task-id"]
                                    timeInterval:[date timeIntervalSinceDate:dateNow]];
    }
}

@end
