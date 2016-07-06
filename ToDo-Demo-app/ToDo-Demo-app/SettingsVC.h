//
//  SettingsVC.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol notificationSwitchDelegate <NSObject>

- (void) notificationSwitched:(BOOL) notifSwitch;

@end

@interface SettingsVC : UIViewController

@property (nonatomic, strong) id <notificationSwitchDelegate> switchDelegate;

@end
