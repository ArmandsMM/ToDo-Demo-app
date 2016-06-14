//
//  CreateVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "CreateVC.h"
#import "DatabaseService.h"

@interface CreateVC()
@property (strong, nonatomic) IBOutlet UILabel *dateDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateMonthLabel;

@property (strong, nonatomic) IBOutlet UITextField *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *startTimeLabel;
@property (strong, nonatomic) IBOutlet UITextField *endTimeLabel;
@property (strong, nonatomic) IBOutlet UITextField *placeLabel;

@property (strong, nonatomic) IBOutlet UIStackView *usersStackView;

@property (strong, nonatomic) IBOutlet UITextField *notificationLabel;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;
    [self setTextViewDelegates];
}
- (IBAction)discardTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextFieldDelegate

- (void) setTextViewDelegates {
    self.titleLabel.delegate = self;
    self.descriptionLabel.delegate = self;
    self.startTimeLabel.delegate = self;
    self.endTimeLabel.delegate = self;
    self.placeLabel.delegate = self;
    self.notificationLabel.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self resetViewWhenKeaboardAppears:textField];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.titleLabel resignFirstResponder];
    [self.descriptionLabel resignFirstResponder];
    [self.startTimeLabel resignFirstResponder];
    [self.endTimeLabel resignFirstResponder];
    [self.placeLabel resignFirstResponder];
    [self.notificationLabel resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveViewWhenKeaboardAppears:textField];
}

- (void) moveViewWhenKeaboardAppears:(UITextField *) textField {
    [UIView animateWithDuration:0.325 animations:^{
        CGRect newRect = self.view.frame;
//        newRect.origin.y = - textField.frame.size.height;
        newRect.origin.y = self.view.frame.size.height * 0.1 - textField.frame.origin.y;
        self.view.frame = newRect;
    }];
}

- (void) resetViewWhenKeaboardAppears:(UITextField *) textField {
    [UIView animateWithDuration:0.325 animations:^{
        CGRect newRect = self.view.frame;
        newRect.origin.y = 0;
        self.view.frame = newRect;
    }];
}

- (IBAction)leftDateArrowTapped:(id)sender {
}
- (IBAction)rightDateArrowTapped:(id)sender {
}
- (IBAction)addUsersTapped:(id)sender {
}
- (IBAction)createTaskTapped:(id)sender {
    self.activityIndicator.hidden = NO;

    DatabaseService *service = [DatabaseService new];

    NSString *date = [NSString stringWithFormat:@"%@/%@/%@", self.dateDateLabel.text, self.dateMonthLabel.text, self.dateDayLabel.text];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *notification = [formatter numberFromString:self.notificationLabel.text];

    [service createNewTask:date
                 taskTitle:self.titleLabel.text
           taskDescription:self.descriptionLabel.text
                      time:@[self.startTimeLabel.text, self.endTimeLabel.text]
                     place:self.placeLabel.text
                 withUsers:@[@"user1",@"user2"]
          withNotification:notification completion:^(BOOL success) {
              if (success) {
                  self.activityIndicator.hidden = YES;
                  //[self.view removeFromSuperview];
                  [self dismissViewControllerAnimated:YES completion:nil];
              }
          }];
}

@end
