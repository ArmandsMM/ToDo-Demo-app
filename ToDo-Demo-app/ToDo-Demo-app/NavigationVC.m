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

@implementation NavigationVC {
    UIView *logOutView;
}

-(instancetype)init {
    self  = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor darkGrayColor];
        [self addCloseButton];
        [self addProfileImage];
        [self addNavigationCollectionView];
        [self addLogOutButton];
    }
    return self;
}

- (void) addLogOutButton {
    if ([Authenticator checkIfLoggedIn]) {
        logOutView = [UIView new];
        logOutView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:logOutView];
        [self configureLogOutViewConstraints:logOutView];
        [self addGestureRecognizerToLogOutView: logOutView];
        logOutView.hidden = NO;
    }
}

- (void) addNavigationCollectionView {
    self.navCollectionVC = [NavigationCollectionVC new];
    [self addChildViewController:self.navCollectionVC];
    [self.view addSubview:self.navCollectionVC.view];
    [self configureNavCollectionVConstraints:self.navCollectionVC.view];
}

- (void) addProfileImage {
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:imageView];
    [self configureProfileImageConstraints:imageView];

    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
}

- (void) addCloseButton {
    UIView *closeButton = [UIView new];
    closeButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:closeButton];
    [self configureCloseButtonConstraints:closeButton];
    [self addGestureRecognizerToCloseButton:closeButton];
}

- (void) addGestureRecognizerToCloseButton:(UIView *) closeButton {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNavigationVC)];
    [closeButton addGestureRecognizer:recognizer];
}

- (void) addGestureRecognizerToLogOutView:(UIView *) view {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logOutUser)];
    [view addGestureRecognizer:recognizer];
}

- (void) logOutUser {
    [Authenticator logOutWithCompletion:^(NSError *error) {
        if (!error) {
            logOutView.hidden = YES;
        }
    }];
}

- (void) dismissNavigationVC {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMenuButton" object:self];
    [self dismissViewControllerAnimated:YES completion:^{

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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[v0(20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":closeButton}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0(20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":closeButton}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:closeButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:0.08 constant:0]];
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[v0(20)]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":view}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0(20)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"v0":view}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:0.08 constant:0]];
}

@end
