//
//  TopMenu.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/1/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationVC.h"

@interface TopMenu : UIView

@property (nonatomic, strong) UILabel *topMenuTitle;
@property (nonatomic, strong) UIView *menuButton;

@property (nonatomic, strong) NavigationVC *navVC;

- (instancetype) init;

@end
