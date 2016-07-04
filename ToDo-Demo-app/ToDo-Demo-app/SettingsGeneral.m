//
//  SettingsGeneral.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/28/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "SettingsGeneral.h"
#import "Configuration.h"
#import "KeychainItemWrapper.h"

@interface SettingsGeneral () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@property (strong, nonatomic) IBOutlet UILabel *usernameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayTextLabel;

@end

@implementation SettingsGeneral

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImageView.image = [Configuration sharedInstance].user.image;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/1.8;
    self.userImageView.clipsToBounds = YES;

//    [self loadTextsForLabels];
}

- (void) loadTextsForLabels {
    self.usernameTextLabel.text = [Configuration sharedInstance].user.username;
    self.emailTextLabel.text = [Configuration sharedInstance].user.email;
    self.birthdayTextLabel.text = [Configuration sharedInstance].user.birthday;
}

#pragma mark - Button Actions

- (IBAction)usernameChangeTapped:(id)sender {
    [self setupAlertFor:self.usernameTextLabel];
}

- (IBAction)emailChangeTapped:(id)sender {
    [self setupAlertFor:self.emailTextLabel];
}

- (IBAction)birthdayChangeTapped:(id)sender {
    [self setupAlertFor:self.birthdayTextLabel];
}

#pragma mark - Alert

- (void) setupAlertFor:(UILabel *) label {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


        if ([label.text isEqualToString:self.usernameTextLabel.text]) {
            [[Configuration sharedInstance].service updateProfileWithNewUsername:alertController.textFields.firstObject.text];
            label.text = alertController.textFields.firstObject.text;
        } else if ([label.text isEqualToString:self.emailTextLabel.text]) {
            [[Configuration sharedInstance].authenticator changeUsersEmail:alertController.textFields.firstObject.text
                                                                  oldEmail:[FIRAuth auth].currentUser.email
                                                                  password:[Configuration sharedInstance].user.password
                                                                completion:^(NSError *error) {
                                                                    if (!error) {

                                                                        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"TodoApp" accessGroup:nil];
                                                                        [keychainItem setObject:@"qwerty" forKey:(__bridge id)kSecValueData];
                                                                        [keychainItem setObject:self.emailTextLabel.text forKey:(__bridge id)kSecAttrAccount];

                                                                        [[Configuration sharedInstance].service updateProfileWithNewEmail:alertController.textFields.firstObject.text];
                                                                        label.text = alertController.textFields.firstObject.text;

                                                                        NSLog(@"%@", [FIRAuth auth].currentUser.email);
                                                                    }
                                                                }];

        } else if ([label.text isEqualToString:self.birthdayTextLabel.text]) {
            [[Configuration sharedInstance].service updateProfileWithNewBirthday:alertController.textFields.firstObject.text];
            label.text = alertController.textFields.firstObject.text;
        }
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"type new one";
    }];

    [alertController addAction:done];
    [alertController addAction:cancel];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Appear/Disappier

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self loadTextsForLabels];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self loadTextsForLabels];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - uitextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignFirstResponder];
}
@end
