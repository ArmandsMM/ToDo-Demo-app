//
//  NavigationVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/1/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "NavigationVC.h"
#import "NavigationCollectionVC.h"
#import "Authenticator.h"
#import "Configuration.h"

@implementation NavigationVC

-(instancetype)init {
    self  = [super init];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:backgroundImageView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v0]|"
                                                                         options:0
                                                                         metrics:nil
                                                                            views:@{@"v0":backgroundImageView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v0]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"v0":backgroundImageView}]];
        [self addCloseButton];
        [self addProfileImage];
        [self addNavigationCollectionView];
        [self addLogOutButton];
    }
    return self;
}

- (void) addLogOutButton {
    self.logOutbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.logOutbutton setImage:[UIImage imageNamed:@"log-out.png"] forState:UIControlStateNormal];
    [self.logOutbutton addTarget:self action:@selector(logOutUser) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.logOutbutton];
    [self configureLogOutViewConstraints:self.logOutbutton];

    if ([[Configuration sharedInstance].authenticator checkIfLoggedIn]) {
        self.logOutbutton.hidden = NO;
    }
}

- (void) addNavigationCollectionView {
    self.navCollectionVC = [NavigationCollectionVC new];
    [self addChildViewController:self.navCollectionVC];
    [self.view addSubview:self.navCollectionVC.view];
    [self configureNavCollectionVConstraints:self.navCollectionVC.view];
}

- (void) addProfileImage {
    self.profileImageView = [UIImageView new];
    self.profileImageView.backgroundColor = [UIColor purpleColor];
    [self.profileImageView setImage:[Configuration sharedInstance].profileImage];
    [self.view addSubview:self.profileImageView];
    [self configureProfileImageConstraints:self.profileImageView];

    self.profileImageView.layer.cornerRadius = 20;
    self.profileImageView.layer.masksToBounds = YES;
}

- (void) addCloseButton {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"discard-create-new.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismissNavigationVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    [self configureCloseButtonConstraints:closeButton];
}

- (void) addGestureRecognizerToLogOutView:(UIView *) view {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logOutUser)];
    [view addGestureRecognizer:recognizer];
}

- (void) logOutUser {
    [[Configuration sharedInstance].authenticator logOutWithCompletion:^(NSError *error) {
        if (!error) {
            self.logOutbutton.hidden = YES;
            [self dismissNavigationVC];
        }
    }];
}

- (void) dismissNavigationVC {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navDelegate didDismissNavigation];
    }];
}

- (void) configureNavCollectionVConstraints: (UIView *) navView {
    navView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v0]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":navView}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":navView}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.75 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0 constant:0]];
}

- (void) configureCloseButtonConstraints:(UIView *) closeButton {
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[v0(44)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":closeButton}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0(44)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":closeButton}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:closeButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:0.15 constant:0]];
}

- (void) configureProfileImageConstraints: (UIImageView *) profileImageView {
    profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[v0(40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":profileImageView}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0(40)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":profileImageView}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:profileImageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0 constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:profileImageView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:0.25 constant:0]];
}

- (void) configureLogOutViewConstraints: (UIView *) view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[v0(44)]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":view}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0(44)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":view}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:0.15 constant:0]];
}

@end
