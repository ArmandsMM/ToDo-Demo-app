//
//  SettingsVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "SettingsVC.h"
#import "Configuration.h"
#import "Authenticator.h"

@interface SettingsVC()
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) UITableViewController *settingsTVC;

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.profileImageView.image = [Configuration sharedInstance].profileImage;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 1.8;
    self.profileImageView.clipsToBounds = YES;

    [self setupSettingsTVC];

}

- (IBAction)logOutTapped:(id)sender {
    NSLog(@"log out tapped");
    [Authenticator logOutWithCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
//            [self removeFromParentViewController];
//            [self.view removeFromSuperview];
        }
    }];
}

#pragma mark settings tableview

- (void) setupSettingsTVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.settingsTVC = [sb instantiateViewControllerWithIdentifier:@"settingsTVC"];
    [self.containerView addSubview:self.settingsTVC.view];
    [self addChildViewController:self.settingsTVC];
    self.settingsTVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v0]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"v0":self.settingsTVC.view}]];

    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v0]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"v0":self.settingsTVC.view}]];
    self.settingsTVC.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    self.containerView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
}

@end
