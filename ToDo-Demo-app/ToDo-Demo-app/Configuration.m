//
//  Configuration.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationItems = @[@"HOME",@"CALENDAR",@"OVERVIEW",@"GROUPS",@"LISTS",@"PROFILE",@"TIMELINE",@"SETTINGS"];

        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIStoryboard *sbSettings = [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]];

        self.home = [sb instantiateViewControllerWithIdentifier:@"HomeVC"];
        self.calendar = [sb instantiateViewControllerWithIdentifier:@"CalendarVC"];
        self.overview = [sb instantiateViewControllerWithIdentifier:@"OverviewVC"];
        self.groups = [sb instantiateViewControllerWithIdentifier:@"GroupsVC"];
        self.lists = [sb instantiateViewControllerWithIdentifier:@"ListsVC"];
        self.profile = [sb instantiateViewControllerWithIdentifier:@"ProfileVC"];
        self.timeline = [sb instantiateViewControllerWithIdentifier:@"TimelineVC"];
//        self.settings = [sbSettings instantiateViewControllerWithIdentifier:@"SettingsVC"];

        self.settingsNav = [sbSettings instantiateViewControllerWithIdentifier:@"settingsNav1"];

        [self.settingsNav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.settingsNav.navigationBar.shadowImage = [UIImage new];
        self.settingsNav.navigationBar.translucent = YES;
        self.settingsNav.navigationBar.tintColor = [UIColor whiteColor];

        self.navigationViews = @[self.home, self.calendar, self.overview, self.groups, self.lists, self.profile, self.timeline, self.settingsNav];
    }
    return self;
}

- (NSArray *) tabbarItems {
    if (!_tabbarItems) {
        _tabbarItems = @[@"CALENDAR", @"OVERVIEW", @"HOME", @"GROUPS", @"TIMELINE"];
    }
    return _tabbarItems;
}

- (DatabaseService *) service {
    if (!_service) {
        _service = [DatabaseService new];
//        [_service readUserDataOnce];
//        _service.userDelegate = self;
    }
    return _service;
}

- (Authenticator *) authenticator {
    if (!_authenticator) {
        _authenticator = [Authenticator new];
    }
    return _authenticator;
}

#pragma mark - USER

- (User *) user {
    if (!_user) {
        _user = [User new];
        self.service.userDelegate = self;
    }
    return _user;
}

- (void)userDataDownloaded:(FIRDataSnapshot *) userSanpshot {
//    NSLog(@"userDataDownloaded: %@", userSanpshot);
    NSLog(@"user data changed");
    self.user.username = userSanpshot.value[@"username"];
    self.user.email = userSanpshot.value[@"email"];
    self.user.birthday = userSanpshot.value[@"birthday"];
    self.user.image = [Configuration sharedInstance].profileImage;

    self.user.createdTaskIDs = [userSanpshot.value[@"created-tasks"] allValues];
}

@end