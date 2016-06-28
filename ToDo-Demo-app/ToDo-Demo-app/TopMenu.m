//
//  TopMenu.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/1/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "TopMenu.h"
#import "NavigationVC.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation TopMenu {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColorFromRGB(0x3f3f41) colorWithAlphaComponent:0.8];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addMenuButton];

    }
    return self;
}

- (void) addMenuButton {
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton addTarget:self action:@selector(showNavigationVC) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setImage:[UIImage imageNamed:@"navigation.png"] forState:UIControlStateNormal];
    [self addSubview:self.menuButton];
    [self configureMenuButtonConstraints];
}

- (void) addGestureRecognizerToMenuButton {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationVC)];
    [self.menuButton addGestureRecognizer:recognizer];
}

- (void) showNavigationVC {
    self.navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:self.navVC animated:YES completion:^{
    }];
}
- (NavigationVC *) navVC {
    if (!_navVC) {
        _navVC = [NavigationVC new];
    }
    return _navVC;
}

- (void) configureMenuButtonConstraints {
    self.menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[v0(44)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":self.menuButton}]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v0(44)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"v0":self.menuButton}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.25 constant:0]];

}

- (void) configureTopMenuTitleConstraints {
    self.topMenuTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-64-[v0]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:@{@"v0":self.topMenuTitle}]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topMenuTitle
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.25 constant:0]];
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
