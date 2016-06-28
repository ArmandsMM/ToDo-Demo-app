//
//  LogInVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/3/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "LogInVC.h"
#import "Configuration.h"
#import "KeychainItemWrapper.h"

@interface LogInVC()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.activityIndicator.hidden = YES;

    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;

    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"TodoApp" accessGroup:nil];
    if ([keychainItem objectForKey:(__bridge id)kSecAttrAccount] && [keychainItem objectForKey:(__bridge id)kSecValueData]) {
        NSString *emailText = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
        NSString *passwordText = [keychainItem objectForKey:(__bridge id)kSecValueData];
        self.usernameTextField.text = emailText;
        self.passwordTextField.text = passwordText;
        NSLog(@"username and pass loaded from keychain");

    } else {
//        self.usernameTextField.text = @"armandsgarbagemail@gmail.com";
//        self.passwordTextField.text = @"qwerty";
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";

    }

    self.headerView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    [self addKeyboardToolBar];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) checkNotificationFromRegistration:(NSNotification *) note {
    self.usernameTextField.text = [[note userInfo] valueForKey:@"email"];
    self.passwordTextField.text = [[note userInfo] valueForKey:@"password"];

    NSLog(@"%@ , %@", [[note userInfo] valueForKey:@"email"], [[note userInfo] valueForKey:@"password"]);
}

- (void) autoLogin {
    [self loginButtonTapped:nil];
}

- (IBAction)loginButtonTapped:(id)sender {
    self.activityIndicator.hidden = NO;
    [[Configuration sharedInstance].authenticator loginUser:self.usernameTextField.text andPassword:self.passwordTextField.text completion:^(NSError *error)
     {
         if (!error) {

             KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"TodoApp" accessGroup:nil];
                 [keychainItem setObject:self.passwordTextField.text forKey:(__bridge id)kSecValueData];
                 [keychainItem setObject:self.usernameTextField.text forKey:(__bridge id)kSecAttrAccount];

             [self.view removeFromSuperview];
             [self removeFromParentViewController];
//             [self dismissViewControllerAnimated:NO completion:nil];
         } else {
             NSLog(@"<LogInVC> %@",[error.userInfo valueForKey:@"NSLocalizedDescription"]);
             [self showAlert:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
         }
         self.activityIndicator.hidden = YES;
     }];
}

- (void) showAlert:(NSString *) message  {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];


}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.containerView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.9];
    [UIView animateWithDuration:0.35 animations:^{
//        self.containerView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.view.frame.size.height-textField.frame.size.height);
        self.containerView.frame = CGRectMake(0, self.view.frame.size.height * 0.1 - textField.frame.origin.y, self.containerView.frame.size.width, self.containerView.frame.size.height);
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self resetContainerView];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // resign first responders..
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

    [self resetContainerView];

}

- (void) resetContainerView {
    [UIView animateWithDuration:0.75 animations:^{
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.view setNeedsLayout];
    }];
}

- (void) addKeyboardToolBar {

    CGRect keyBoardFrame = self.usernameTextField.frame;
    keyBoardFrame.size.height = 40;
    UIToolbar *keyboardToolBar = [[UIToolbar alloc] initWithFrame:keyBoardFrame];
    [keyboardToolBar setItems:[NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(selectPreviousTextField)],
                               [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(selectNextTextField)],
                               nil]];
    self.usernameTextField.inputAccessoryView = keyboardToolBar;
    self.passwordTextField.inputAccessoryView = keyboardToolBar;
}

- (void) selectPreviousTextField {

    if ([self.usernameTextField isEditing]) {
        return;
    }
    if ([self.passwordTextField isEditing]) {
        [self.usernameTextField becomeFirstResponder];
        return;
    }

}

- (void) selectNextTextField {

    if ([self.usernameTextField isEditing]) {
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    if ([self.passwordTextField isEditing]) {
        return;
    }
}

@end
