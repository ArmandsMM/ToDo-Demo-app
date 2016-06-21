//
//  NavigationVC.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/1/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationCollectionVC.h"

@protocol navigationDelegate <NSObject>

- (void) didDismissNavigation;

@end

@interface NavigationVC : UIViewController

@property (nonatomic, strong) id <navigationDelegate> navDelegate;

@property (nonatomic, strong) NavigationCollectionVC *navCollectionVC;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIButton *logOutbutton;

- (instancetype) init;

@end
