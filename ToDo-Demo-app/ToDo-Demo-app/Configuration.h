//
//  Configuration.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseService.h"
#import "StorageService.h"
#import "Authenticator.h"

#import "HomeVC.h"
#import "CalendarVC.h"
#import "OverviewVC.h"
#import "GroupsVC.h"
#import "ListsVC.h"
#import "ProfileVC.h"
#import "TimelineVC.h"
#import "SettingsVC.h"

#import "User.h"
#import "LocalNotifications.h"

@interface Configuration : NSObject <userDataDelegate>

@property (nonatomic, strong) NSArray *tabbarItems;
@property (nonatomic, strong) NSArray *navigationItems;
@property (nonatomic, strong) NSArray *navigationViews;

@property (nonatomic, strong) DatabaseService *service;
//@property (nonatomic, strong) UIImage *profileImage;

@property (nonatomic, strong) Authenticator *authenticator;

@property (nonatomic, strong) HomeVC *home;
@property (nonatomic, strong) CalendarVC *calendar;
@property (nonatomic, strong) OverviewVC *overview;
@property (nonatomic, strong) GroupsVC *groups;
@property (nonatomic, strong) ListsVC *lists;
@property (nonatomic, strong) ProfileVC *profile;
@property (nonatomic, strong) TimelineVC *timeline;
@property (nonatomic, strong) SettingsVC *settings;
@property (nonatomic, strong) UINavigationController *settingsNav;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) LocalNotifications *localNotifications;

+ (instancetype)sharedInstance;

@end
