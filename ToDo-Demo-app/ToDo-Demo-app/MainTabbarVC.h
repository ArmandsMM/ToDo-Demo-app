//
//  MainTabbarVC.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 5/30/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationVC.h"
#import "Authenticator.h"

@interface MainTabbarVC : UITabBarController  <UITabBarControllerDelegate, navigationDelegate, loginDelegate>

@end
