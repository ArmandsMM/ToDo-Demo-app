//
//  SettingsTheme.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/28/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "SettingsTheme.h"

@interface SettingsTheme ()

@end

@implementation SettingsTheme

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
