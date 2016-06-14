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
#import "Authenticator.h"
#import "LogInVC.h"
#import "CreateVC.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation MainTabbarVC {
    TopMenu *menu;
    Configuration *config;
    UIViewController *newViewController;
    UIButton *createNewButton;
    UINavigationController *loginNVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareConfiguration];


    self.selectedIndex = 2;

    self.tabBar.backgroundColor = [UIColor darkGrayColor];

    menu = [TopMenu new];
    [self.view addSubview:menu];
    [self configureTopMenuConstraints:menu];
    
    self.delegate = self;
    [self updateTopMenuTitle];

    [self addCreateNewButton];
    
    [self prepareLoginViewWithCompletion:nil];
}

#pragma mark - Create New button

- (void) addCreateNewButton {
    createNewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [createNewButton setTitle:@"+" forState:UIControlStateNormal];
    [createNewButton addTarget:self action:@selector(showCreateNewView) forControlEvents:UIControlEventTouchUpInside];
    createNewButton.titleLabel.textColor = [UIColor whiteColor];
    createNewButton.backgroundColor = UIColorFromRGB(0x8c88ff);

    createNewButton.layer.cornerRadius = 25;

    [self.view addSubview:createNewButton];
    [self addConstraintsToCreateNewButton:createNewButton];
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
            newViewController = [sb instantiateViewControllerWithIdentifier:@"CreateVC"];
            //[self.view addSubview:newViewController.view];
            //[self addChildViewController:newViewController];
//            newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
//            [self configureNewViewConstraints];
            [self presentViewController:newViewController animated:YES completion:nil];

            //menu.topMenuTitle.text = @"Create New";
        }
    }];
}

- (void) prepareConfiguration {
    config = [[Configuration sharedInstance] init];
}

#pragma mark - Login Check

- (void) prepareLoginViewWithCompletion:(void (^)(BOOL))success {

    if (![Authenticator checkIfLoggedIn]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LogInVC *newVC = [sb instantiateViewControllerWithIdentifier:@"LogInVC"];

        [self.view addSubview:newVC.view];
        [self addChildViewController:newVC];
        [self configureLogInViewConstraints:newVC.view];


        if (success != nil) {
            success(YES);
        }
    } else {
        if (success != nil) {
            success(NO);
        }
    }
}

#pragma mark - Page Navigation from top menu

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    __block id weakSelf = self;
    menu.navVC.navCollectionVC.didSelect = ^(NSString *data) {
        [weakSelf checkVCfromNavigation:data];
    };
}

- (void) checkVCfromNavigation:(NSString *) item {
    if (newViewController) {
        [newViewController.view removeFromSuperview];
        [newViewController removeFromParentViewController];
        menu.topMenuTitle.text = item;
    }
    if ([Authenticator checkIfLoggedIn]) {
        NSInteger itemIndex = [config.navigationItems indexOfObject:item];
        if (!(NSNotFound == itemIndex)) {
            NSInteger tabbarItemIndex = [config.tabbarItems indexOfObject:item];
            if (!(NSNotFound == tabbarItemIndex)) {
                self.selectedIndex = [config.tabbarItems indexOfObject:item];
                [self updateTopMenuTitle];
            } else {
                [self loadViewFromNavigation:itemIndex];
                menu.topMenuTitle.text = item;
            }
        }
    } else {
        [self prepareLoginViewWithCompletion:nil];
    }
}

- (void) loadViewFromNavigation:(NSInteger) itemIndex {
    newViewController = [config.navigationViews objectAtIndex:itemIndex];
    [self.view addSubview:newViewController.view];
    [self addChildViewController:newViewController];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureNewViewConstraints];
}

- (void) updateTopMenuTitle {
    switch (self.selectedIndex) {
        case 0:
            menu.topMenuTitle.text = @"Calendar";
            break;
        case 1:
            menu.topMenuTitle.text = @"Overview";
            break;
        case 2:
            menu.topMenuTitle.text = @"Home";
            break;
        case 3:
            menu.topMenuTitle.text = @"Groups";
            break;
        case 4:
            menu.topMenuTitle.text = @"Timeline";
            break;

        default:
            menu.topMenuTitle.text = @"ToDo Demo App";
            break;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self updateTopMenuTitle];
}

#pragma mark - Constraints

- (void) configureNewViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newViewController.view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newViewController.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newViewController.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newViewController.view
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

#pragma mark - helper methods

- (void) awakeFromNib {
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogin)
                                                 name:@"didLogin"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toggleMenuButton)
                                                 name:@"toggleMenuButton"
                                               object:nil];
}

- (void) didLogin {
    [self updateTopMenuTitle];
}

- (void) toggleMenuButton {
    if (newViewController) {
        [newViewController.view removeFromSuperview];
        [newViewController removeFromParentViewController];
    }
    [self prepareLoginViewWithCompletion:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
