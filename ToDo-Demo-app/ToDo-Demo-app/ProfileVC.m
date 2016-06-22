//
//  ProfileVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "ProfileVC.h"
#import "Configuration.h"

@implementation ProfileVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.nameLabel.text = [NSString stringWithFormat:@"Hi! %@",[FIRAuth auth].currentUser.email];
}

@end
