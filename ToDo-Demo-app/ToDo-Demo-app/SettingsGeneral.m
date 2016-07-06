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

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property BOOL profileImageWasChanged;

@end

@implementation SettingsGeneral

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;

    self.userImageView.image = [Configuration sharedInstance].user.image;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/1.8;
    self.userImageView.clipsToBounds = YES;

    self.profileImageWasChanged = NO;

    self.updateButton.layer.cornerRadius = self.updateButton.frame.size.width/1.8;
    self.updateButton.clipsToBounds = YES;

    [self setupTextFieldDelegates];
    [self addKeyboardToolBar];
}



#pragma mark - Button Actions

- (IBAction)updateButtonTapped:(id)sender {

    self.activityIndicator.hidden = NO;

    if (self.usernameTextfield.text.length != 0) {
        [[Configuration sharedInstance].service updateProfileWithNewUsername:self.usernameTextfield.text];
    }
    if (self.emailTextfield.text.length != 0) {
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
    if (self.birthdayTextfield.text.length != 0) {
        [[Configuration sharedInstance].service updateProfileWithNewBirthday:self.birthdayTextfield.text];
    }
    if (self.profileImageWasChanged) {
        [self uploadImageForProfile:self.userImageView.image];
    }

    self.activityIndicator.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    if (!self.profileImageWasChanged) {
        self.updatebuttonview.hidden = YES;
    }
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

#pragma mark - Photo

- (IBAction)addPhotoWasTapped:(id)sender {
    [self setupProfileAlert];
}

- (void) setupProfileAlert {
    UIAlertController *profileAlertController = [UIAlertController alertControllerWithTitle:@"Select image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleCamera];
    }];
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleGallery];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [profileAlertController dismissViewControllerAnimated:YES completion:nil];
    }];


    [profileAlertController addAction:camera];
    [profileAlertController addAction:gallery];
    [profileAlertController addAction:cancel];

    [self presentViewController:profileAlertController animated:YES completion:nil];
}

- (void) handleCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *cameraAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You don't have camera" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [cameraAlert dismissViewControllerAnimated:YES completion:nil];
        }];

        [cameraAlert addAction:ok];
        [self presentViewController:cameraAlert animated:YES completion:nil];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void) handleGallery {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - imagePickerController/navigation delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 0.01);
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    self.userImageView.image = image;
    [Configuration sharedInstance].user.image = image;

    self.profileImageWasChanged = YES;
    self.updatebuttonview.hidden = NO;

    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) uploadImageForProfile:(UIImage *) image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    StorageService *storage = [StorageService new];
    [storage uploadImage:imageData forUser:[FIRAuth auth].currentUser.uid];
}

@end
