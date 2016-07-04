//
//  MainTabbarVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 5/30/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "MainTabbarVC.h"
#import "TopMenu.h"
#import "Configuration.h"
#import "LogInVC.h"
#import "CreateVC.h"

#import "KeychainItemWrapper.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface MainTabbarVC()

@property (nonatomic, strong) TopMenu *menu;
//@property (nonatomic, strong) Configuration *config;
@property (nonatomic, strong) UIButton *createNewButton;
@property (nonatomic, strong) NavigationVC *navVC;

@property BOOL didPressLogout;

@property (nonatomic, strong) UIViewController *pageViewController;
@property (nonatomic, strong) LogInVC *loginVC;

@property (nonatomic, strong) HomeVC *homePage;

@end

@implementation MainTabbarVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ([self checkForSavedKeychainCredentials] && !self.didPressLogout && [FIRAuth auth].currentUser) {
        [self.loginVC autoLogin];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareConfiguration];
    [Configuration sharedInstance].authenticator.logInDelegate = self;
    if ([[Configuration sharedInstance].authenticator checkIfLoggedIn]) {
        [self didLogin];
    }

    self.selectedIndex = 2;

    self.tabBar.backgroundColor = [UIColor darkGrayColor];

    self.menu = [TopMenu new];
    [self.view addSubview:self.menu];
    [self configureTopMenuConstraints:self.menu];
    self.menu.navVC.navDelegate = self;
    
    self.delegate = self;
    [self updateTopMenuTitle];

    [self addCreateNewButton];
    
    [self prepareLoginViewWithCompletion:nil];
}

#pragma mark - Create New button

- (void) addCreateNewButton {
    self.createNewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.createNewButton addTarget:self action:@selector(showCreateNewView) forControlEvents:UIControlEventTouchUpInside];
    [self.createNewButton setImage:[UIImage imageNamed:@"create-new-button.png"] forState:UIControlStateNormal];
    self.createNewButton.imageView.layer.cornerRadius = 26;

    [self.view addSubview:self.createNewButton];
    [self addConstraintsToCreateNewButton:self.createNewButton];
}

- (void) addConstraintsToCreateNewButton:(UIButton *) button {
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[v0(50)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":button}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0(50)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":button}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0 constant:0]];
}

- (void) showCreateNewView {
    [self prepareLoginViewWithCompletion:^(BOOL success) {
        if (!success) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            self.pageViewController = [sb instantiateViewControllerWithIdentifier:@"CreateVC"];

            [self presentViewController:self.pageViewController animated:YES completion:nil];
        }
    }];
}

- (void) prepareConfiguration {
//    self.config = [Configuration sharedInstance];
}

#pragma mark - Login Check

- (void) prepareLoginViewWithCompletion:(void (^)(BOOL))success {

    if (![[Configuration sharedInstance].authenticator checkIfLoggedIn]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"login" bundle:[NSBundle mainBundle]];

        self.loginVC = [sb instantiateViewControllerWithIdentifier:@"LogInVC"];
        [self.view addSubview:self.loginVC.view];
        [self addChildViewController:self.loginVC];
        [self configureLogInViewConstraints:self.loginVC.view];

        if (success != nil) {
            success(YES);
        }
    } else {
        if (success != nil) {
            success(NO);
        }
    }
}

- (BOOL) checkForSavedKeychainCredentials {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"TodoApp" accessGroup:nil];
    if ([keychainItem objectForKey:(__bridge id)kSecAttrAccount] && [keychainItem objectForKey:(__bridge id)kSecValueData]) {
        NSString *emailText = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
        NSString *passwordText = [keychainItem objectForKey:(__bridge id)kSecValueData];
        if (emailText != nil && passwordText != nil) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Page Navigation from top menu

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    __block id weakSelf = self;
    self.menu.navVC.navCollectionVC.didSelect = ^(NSString *data) {
        [weakSelf checkVCfromNavigation:data];
    };
}

- (void) checkVCfromNavigation:(NSString *) item {
    if (self.pageViewController) {
        [self.pageViewController.view removeFromSuperview];
        [self.pageViewController removeFromParentViewController];
        self.menu.topMenuTitle.text = item;
    }
    if ([[Configuration sharedInstance].authenticator checkIfLoggedIn]) {
        NSInteger itemIndex = [[Configuration sharedInstance].navigationItems indexOfObject:item];
        if (!(NSNotFound == itemIndex)) {
            NSInteger tabbarItemIndex = [[Configuration sharedInstance].tabbarItems indexOfObject:item];
            if (!(NSNotFound == tabbarItemIndex)) {
                self.selectedIndex = [[Configuration sharedInstance].tabbarItems indexOfObject:item];
                [self updateTopMenuTitle];
            } else {
                [self loadViewFromNavigation:itemIndex];
//                self.menu.topMenuTitle.text = item;
            }
        }
    } else {
        [self prepareLoginViewWithCompletion:nil];
    }
}

- (void) loadViewFromNavigation:(NSInteger) itemIndex {
    self.pageViewController = [[Configuration sharedInstance].navigationViews objectAtIndex:itemIndex];
    if (itemIndex == 7) {
        [self showSettingsFromNavigationVC:self.pageViewController];
    } else {
        [self.view addSubview:self.pageViewController.view];
        [self addChildViewController:self.pageViewController];
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self configureNewViewConstraints];
    }
}

- (void) showSettingsFromNavigationVC:(UIViewController *) settingsVC {
    settingsVC.modalPresentationStyle = UIModalPresentationFullScreen;
    settingsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:settingsVC animated:YES completion:^{
    }];
}

- (void) updateTopMenuTitle {
    switch (self.selectedIndex) {
        case 0:
            self.menu.topMenuTitle.text = @"Calendar";
            break;
        case 1:
            self.menu.topMenuTitle.text = @"Overview";
            break;
        case 2:
            self.menu.topMenuTitle.text = @"Home";
            break;
        case 3:
            self.menu.topMenuTitle.text = @"Groups";
            break;
        case 4:
            self.menu.topMenuTitle.text = @"Timeline";
            break;

        default:
            self.menu.topMenuTitle.text = @"ToDo Demo App";
            break;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self updateTopMenuTitle];
}

- (void)didDismissNavigation {
    NSLog(@"dismiss delegate working");
}

#pragma mark - Constraints

- (void) configureNewViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageViewController.view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageViewController.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageViewController.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageViewController.view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.88 constant:0]];
}

- (void) configureLogInViewConstraints:(UIView *) loginview {
    loginview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginview
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginview
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginview
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginview
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0 constant:0]]; // multiplier:0.92 if need to see top menu
}

- (void) configureTopMenuConstraints:(UIView *) view {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.12 constant:0]];
}

#pragma mark - loginDelegate

- (BOOL)didLogout {
    NSLog(@"did logout delegate");
    self.didPressLogout = YES;
    [self clearKeyChainItems];
    [[Configuration sharedInstance].service deleteAllLocalTasks];

    [self prepareLoginViewWithCompletion:nil];
    return YES;
}

- (BOOL)didLogin {
    NSLog(@"did login delegate");

    if (self.pageViewController) {
        [self.pageViewController.view removeFromSuperview];
        [self.pageViewController removeFromParentViewController];
    }

    if (self.loginVC) {
        [self.loginVC.view removeFromSuperview];
        [self.loginVC removeFromParentViewController];
    }
    self.selectedIndex = 2;
    self.menu.navVC.logOutbutton.hidden = NO;
    [self setupProfileImageAndFirebaseListeners];

    NSLog(@"%@", self.selectedViewController.description);
    if ([self.selectedViewController isKindOfClass:[HomeVC class]]) {
//        [Configuration sharedInstance].service.downloadDelegate = (HomeVC *) self.selectedViewController;
        [Configuration sharedInstance].service.downloadDelegate = [self.viewControllers objectAtIndex:2];
    }

    return YES;
}

- (void) clearKeyChainItems {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"TodoApp" accessGroup:nil];
    if ([keychainItem objectForKey:(__bridge id)kSecAttrAccount] && [keychainItem objectForKey:(__bridge id)kSecValueData]) {

//        [keychainItem delete:[keychainItem objectForKey:(__bridge id)kSecAttrAccount]];
//        [keychainItem delete:[keychainItem objectForKey:(__bridge id)kSecValueData]];
        [keychainItem resetKeychainItem];

    }
}

- (void) setupProfileImageAndFirebaseListeners {

    StorageService *storage = [StorageService new];
    [storage downloadProfileImage:^(UIImage *image) {
        if (image) {
            [Configuration sharedInstance].profileImage = image;
            self.menu.navVC.profileImageView.image = image;
        }
    }];

    [Configuration sharedInstance].service = [DatabaseService new];
    [[Configuration sharedInstance].service listenForTaskDataChangeFromFirebase];
    NSLog(@"Firebase listeners setup");
}

@end
