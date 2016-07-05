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

@property (strong, nonatomic) IBOutlet UIView *updatebuttonview;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;
@property (strong, nonatomic) IBOutlet UITextField *birthdayTextfield;

@end

@implementation SettingsGeneral

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userImageView.image = [Configuration sharedInstance].user.image;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/1.8;
    self.userImageView.clipsToBounds = YES;

    self.updateButton.layer.cornerRadius = self.updateButton.frame.size.width/1.8;
    self.updateButton.clipsToBounds = YES;

    [self setupTextFieldDelegates];
    [self addKeyboardToolBar];
}



#pragma mark - Button Actions

- (IBAction)updateButtonTapped:(id)sender {

    if (![self.usernameTextfield.text isEqualToString:@""] || self.usernameTextfield != nil) {
        [[Configuration sharedInstance].service updateProfileWithNewUsername:self.usernameTextfield.text];
    }
    if (![self.emailTextfield.text isEqualToString:@""] || self.emailTextfield != nil) {
        [[Configuration sharedInstance].authenticator changeUsersEmail:self.emailTextfield.text
                                                              oldEmail:[FIRAuth auth].currentUser.email
                                                              password:[Configuration sharedInstance].user.password
                                                            completion:^(NSError *error) {
                                                                if (!error) {

                                                                    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"TodoApp" accessGroup:nil];
                                                                    [keychainItem setObject:[Configuration sharedInstance].user.password forKey:(__bridge id)kSecValueData];
                                                                    [keychainItem setObject:self.emailTextfield.text forKey:(__bridge id)kSecAttrAccount];

                                                                    [[Configuration sharedInstance].service updateProfileWithNewEmail:self.emailTextfield.text];
                                                                    NSLog(@"%@", [FIRAuth auth].currentUser.email);
                                                                }
                                                            }];
    }
    if (![self.birthdayTextfield.text isEqualToString:@""] || self.birthdayTextfield != nil) {
        [[Configuration sharedInstance].service updateProfileWithNewBirthday:self.birthdayTextfield.text];
    }
}

//#pragma mark - Alert
//
//- (void) setupAlertFor:(UILabel *) label {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//
//        if ([label.text isEqualToString:self.usernameTextLabel.text]) {
//            [[Configuration sharedInstance].service updateProfileWithNewUsername:alertController.textFields.firstObject.text];
//            label.text = alertController.textFields.firstObject.text;
//        } else if ([label.text isEqualToString:self.emailTextLabel.text]) {
//            [[Configuration sharedInstance].authenticator changeUsersEmail:alertController.textFields.firstObject.text
//                                                                  oldEmail:[FIRAuth auth].currentUser.email
//                                                                  password:[Configuration sharedInstance].user.password
//                                                                completion:^(NSError *error) {
//                                                                    if (!error) {
//
//                                                                        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"TodoApp" accessGroup:nil];
//                                                                        [keychainItem setObject:@"qwerty" forKey:(__bridge id)kSecValueData];
//                                                                        [keychainItem setObject:self.emailTextLabel.text forKey:(__bridge id)kSecAttrAccount];
//
//                                                                        [[Configuration sharedInstance].service updateProfileWithNewEmail:alertController.textFields.firstObject.text];
//                                                                        label.text = alertController.textFields.firstObject.text;
//
//                                                                        NSLog(@"%@", [FIRAuth auth].currentUser.email);
//                                                                    }
//                                                                }];
//
//        } else if ([label.text isEqualToString:self.birthdayTextLabel.text]) {
//            [[Configuration sharedInstance].service updateProfileWithNewBirthday:alertController.textFields.firstObject.text];
//            label.text = alertController.textFields.firstObject.text;
//        }
//    }];
//
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"type new one";
//    }];
//
//    [alertController addAction:done];
//    [alertController addAction:cancel];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//
//#pragma mark - Appear/Disappier
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    [self.navigationController setNavigationBarHidden:YES];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.updatebuttonview.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - uitextfield delegate

- (void) setupTextFieldDelegates {
    self.usernameTextfield.delegate = self;
    self.emailTextfield.delegate = self;
    self.birthdayTextfield.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.updatebuttonview.hidden = NO;

    [UIView animateWithDuration:0.325 animations:^{
        CGRect newRect = self.view.frame;
        newRect.origin.y = self.view.frame.size.height * 0.18  - textField.frame.origin.y;
        self.view.frame = newRect;

    }];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self resetViews];
}

- (void) resetViews {
    [UIView animateWithDuration:0.325 animations:^{
        CGRect newRect = self.view.frame;
        newRect.origin.y = 0;
        self.view.frame = newRect;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self doneTextField];
}

- (void) doneTextField {
    [self.usernameTextfield resignFirstResponder];
    [self.emailTextfield resignFirstResponder];
    [self.birthdayTextfield resignFirstResponder];
}

- (void) addKeyboardToolBar {

    CGRect keyBoardFrame = self.usernameTextfield.frame;
    keyBoardFrame.size.height = 40;
    UIToolbar *keyboardToolBar = [[UIToolbar alloc] initWithFrame:keyBoardFrame];
    [keyboardToolBar setItems:[NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(selectPreviousTextField)],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(selectNextTextField)],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTextField)],
                               nil]];
    self.usernameTextfield.inputAccessoryView = keyboardToolBar;
    self.emailTextfield.inputAccessoryView = keyboardToolBar;
    self.birthdayTextfield.inputAccessoryView = keyboardToolBar;
}

- (void) selectPreviousTextField {

    if ([self.usernameTextfield isEditing]) {
        return;
    }
    if ([self.emailTextfield isEditing]) {
        [self.usernameTextfield becomeFirstResponder];
        return;
    }
    if ([self.birthdayTextfield isEditing]) {
        [self.emailTextfield becomeFirstResponder];
        return;
    }

}

- (void) selectNextTextField {

    if ([self.usernameTextfield isEditing]) {
        [self.emailTextfield becomeFirstResponder];
        return;
    }
    if ([self.emailTextfield isEditing]) {
        [self.birthdayTextfield becomeFirstResponder];
        return;
    }
    if ([self.birthdayTextfield isEditing]) {
        return;
    }

}
@end
