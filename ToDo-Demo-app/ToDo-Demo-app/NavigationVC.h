//
//  NavigationVC.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/1/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationCollectionVC.h"

@interface NavigationVC : UIViewController

@property (nonatomic, strong) NavigationCollectionVC *navCollectionVC;

- (instancetype) init;

@end
