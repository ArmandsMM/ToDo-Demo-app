//
//  RegistrationVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/9/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "RegistrationVC.h"

#import "DatabaseService.h"
#import "StorageService.h"
#import "KeychainItemWrapper.h"

@interface RegistrationVC ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation RegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;

    self.activityIndicator.hidden = YES;
    self.headerView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    self.usernameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.birthdayTextField.delegate = self;

    self.passwordTextField.secureTextEntry = YES;

    [self addKeyboardToolBar];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)signInTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addPhotoTapped:(id)sender {
    [self setupProfileAlert];
}

- (IBAction)connectTapped:(id)sender {
    if (![self isValidEmail:self.emailTextField.text]) {
        return;
    }
    self.activityIndicator.hidden = NO;
    [Authenticator createUser:self.emailTextField.text andPassword:self.passwordTextField.text completion:^(NSError *error) {
        if (!error) {

            DatabaseService *service = [DatabaseService new];
            NSData *imageData = UIImageJPEGRepresentation(self.profileImageView.image, 1.0);

            StorageService *storage = [StorageService new];
            [storage uploadImage:imageData forUser:[FIRAuth auth].currentUser.uid];
            
            NSString *imagePath = [NSString stringWithFormat:@"%@/profile-image.jpg", [FIRAuth auth].currentUser.uid];
            [service saveProfileDataToDatabaseWithUsername:self.usernameTextField.text email:self.emailTextField.text birthday:self.birthdayTextField.text imagePath:imagePath];

            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
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

- (BOOL) isValidEmail:(NSString *) email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    if (isValid == 0) {
        return NO;
    }
    return YES;

}

#pragma mark - UITextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self resetViews];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.usernameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.birthdayTextField resignFirstResponder];

    [self resetViews];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.325 animations:^{
        CGRect newRect = self.view.frame;
        newRect.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height - self.headerView.frame.size.height;
        self.view.frame = newRect;

    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![self isValidEmail:self.emailTextField.text]) {
        self.emailTextField.textColor = [UIColor redColor];
    } else {
        self.emailTextField.textColor = [UIColor whiteColor];
    }
}

- (void) resetViews {
    [UIView animateWithDuration:0.325 animations:^{
        CGRect newRect = self.view.frame;
        newRect.origin.y = 0;
        self.view.frame = newRect;
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
    self.emailTextField.inputAccessoryView = keyboardToolBar;
    self.passwordTextField.inputAccessoryView = keyboardToolBar;
    self.birthdayTextField.inputAccessoryView = keyboardToolBar;
}

- (void) selectPreviousTextField {

    if ([self.usernameTextField isEditing]) {
        return;
    }
    if ([self.emailTextField isEditing]) {
        [self.usernameTextField becomeFirstResponder];
        return;
    }
    if ([self.passwordTextField isEditing]) {
        [self.emailTextField becomeFirstResponder];
        return;
    }
    if ([self.birthdayTextField isEditing]) {
        [self.passwordTextField becomeFirstResponder];
        return;
    }

}

- (void) selectNextTextField {

    if ([self.usernameTextField isEditing]) {
        [self.emailTextField becomeFirstResponder];
        return;
    }
    if ([self.emailTextField isEditing]) {
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    if ([self.passwordTextField isEditing]) {
        [self.birthdayTextField becomeFirstResponder];
        return;
    }
    if ([self.birthdayTextField isEditing]) {
        return;
    }
}

#pragma mark - Photo

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
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 0.1);
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    self.profileImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];

}

@end
