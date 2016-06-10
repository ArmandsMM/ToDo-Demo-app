//
//  TopMenu.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/1/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "TopMenu.h"
#import "NavigationVC.h"

@implementation TopMenu {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addMenuButton];

    }
    return self;
}

- (void) addMenuButton {
    self.menuButton = [UIView new];
    self.menuButton.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:self.menuButton];
    [self configureMenuButtonConstraints];
    [self addGestureRecognizerToMenuButton];
}

- (void) addGestureRecognizerToMenuButton {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationVC)];
    [self.menuButton addGestureRecognizer:recognizer];
}

- (void) showNavigationVC {
    self.navVC = [[NavigationVC alloc] init];
    self.navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:self.navVC animated:YES completion:^{
    }];
}

- (void) configureMenuButtonConstraints {
    self.menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[v0(20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":self.menuButton}]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0(20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":self.menuButton}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0 constant:0]];

}

- (void) configureTopMenuTitleConstraints {
    self.topMenuTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[v0]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:@{@"v0":self.topMenuTitle}]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v0]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":self.topMenuTitle}]];
}

- (UILabel *) topMenuTitle {
    if (!_topMenuTitle) {

        _topMenuTitle = [UILabel new];
        _topMenuTitle.textColor = [UIColor whiteColor];
        _topMenuTitle.text = @"title text";
        _topMenuTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_topMenuTitle];
        [self configureTopMenuTitleConstraints];
    }
    return _topMenuTitle;
}

@end
