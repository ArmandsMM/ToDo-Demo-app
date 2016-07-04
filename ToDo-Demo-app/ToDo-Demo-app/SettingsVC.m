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

@interface SettingsVC() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) UITableView *settingsTableView;

@property (strong, nonatomic) NSArray *settingsList;
@property (strong, nonatomic) UISwitch *switcher;

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.profileImageView.image = [Configuration sharedInstance].profileImage;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 1.8;
    self.profileImageView.clipsToBounds = YES;

    self.containerView.backgroundColor = [UIColor clearColor];

    self.settingsList = @[@"General",
                          @"Notifications",
                          @"Sounds",
                          @"Settings",
                          @"Theme",
                          @"Support",
                          @"Privacy"];
}

- (IBAction)showNavigationTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)logOutTapped:(id)sender {
    NSLog(@"log out tapped");
    [[Configuration sharedInstance].authenticator logOutWithCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
//            [self removeFromParentViewController];
//            [self.view removeFromSuperview];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

#pragma mark settings tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.textLabel.text = self.settingsList[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.row == 1) {
        CGRect switchFrame = cell.detailTextLabel.frame;
        switchFrame.origin.x = switchFrame.origin.x + cell.detailTextLabel.frame.size.width / 1;
        if (!self.switcher) {
            self.switcher = [[UISwitch alloc] initWithFrame:switchFrame];
            [cell addSubview:self.switcher];
            self.switcher.thumbTintColor = [UIColor purpleColor];
            self.switcher.onTintColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        }
    }
    if (indexPath.row == 4) {
        cell.detailTextLabel.text = @"Standart";
    } else {
        cell.detailTextLabel.text = @"";
    }


    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"General" sender:nil];
    }
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"Sounds" sender:nil];
    }
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"Settings" sender:nil];
    }
    if (indexPath.row == 4) {
        [self performSegueWithIdentifier:@"Theme" sender:nil];
    }
    if (indexPath.row == 5) {
        [self performSegueWithIdentifier:@"Support" sender:nil];
    }
    if (indexPath.row == 6) {
        [self performSegueWithIdentifier:@"Privacy" sender:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


@end
