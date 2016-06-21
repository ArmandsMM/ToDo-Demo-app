//
//  Configuration.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "Configuration.h"
#import "HomeVC.h"
#import "CalendarVC.h"
#import "OverviewVC.h"
#import "GroupsVC.h"
#import "ListsVC.h"
#import "ProfileVC.h"
#import "TimelineVC.h"
#import "SettingsVC.h"

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

        HomeVC *home = [sb instantiateViewControllerWithIdentifier:@"HomeVC"];
        CalendarVC *calendar = [sb instantiateViewControllerWithIdentifier:@"CalendarVC"];
        OverviewVC *overview = [sb instantiateViewControllerWithIdentifier:@"OverviewVC"];
        GroupsVC *groups = [sb instantiateViewControllerWithIdentifier:@"GroupsVC"];
        ListsVC *lists = [sb instantiateViewControllerWithIdentifier:@"ListsVC"];
        ProfileVC *profile = [sb instantiateViewControllerWithIdentifier:@"ProfileVC"];
        TimelineVC *timeline = [sb instantiateViewControllerWithIdentifier:@"TimelineVC"];
        SettingsVC *settings = [sb instantiateViewControllerWithIdentifier:@"SettingsVC"];

        self.navigationViews = @[home, calendar, overview, groups, lists, profile, timeline, settings];

//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(setupProfileImageAndFirebaseListeners)
//                                                     name:@"isInFirebase"
//                                                   object:nil];

        //[self didLogin];
    }
    return self;
}

- (NSArray *) tabbarItems {
    if (!_tabbarItems) {
        _tabbarItems = @[@"CALENDAR", @"OVERVIEW", @"HOME", @"GROUPS", @"TIMELINE"];
    }
    return _tabbarItems;
}

- (Authenticator *) authenticator {
    if (!_authenticator) {
        _authenticator = [Authenticator new];
        //_authenticator.logInDelegate = self;
    }
    return _authenticator;
}

//#pragma mark - loginDelegate
//
//- (BOOL)didLogin {
//    [self setupProfileImageAndFirebaseListeners];
//    return YES;
//}
//
//- (void) setupProfileImageAndFirebaseListeners {
//
//    if ([FIRAuth auth].currentUser.uid) {
//        StorageService *storage = [StorageService new];
//        [storage downloadProfileImage:^(UIImage *image) {
//            if (image) {
//                self.profileImage = image;
//            }
//        }];
//
//        self.service = [DatabaseService new];
//        [self.service listenForTaskDataChangeFromFirebase];
//        NSLog(@"Firebase listeners setup");
//    }
//}

//- (void) dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end