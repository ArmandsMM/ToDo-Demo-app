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

@property (strong, nonatomic) NSDate *taskDate;

@end

@implementation CreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;

    [self updateDateLabelsFromCalendar:nil];

    [self addKeyboardToolBar];
    [self setTextFieldDelegates];
}
- (IBAction)discardTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Date Labels

- (void) updateDateLabelsFromCalendar:(NSDate *) inputDate {

    NSDate *date = [NSDate date];
    if (inputDate != nil) {
        date = inputDate;
    }

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = components.weekday;
    NSInteger day = components.day;
    NSInteger year = components.year;
    NSInteger month = components.month;

    NSDateFormatter *formatter = [NSDateFormatter new];

    self.dateDayLabel.text = [formatter weekdaySymbols][weekday-1];
    self.dateDateLabel.text = [NSString stringWithFormat:@"%ld", (long)day];
    self.dateMonthLabel.text = [NSString stringWithFormat:@"%@ %ld", [[formatter monthSymbols] objectAtIndex:month-1], (long)year];
}

- (NSDate *) updateDate:(NSDate *) date withAddingDays:(int) addDay {

    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = addDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    return newDate;
}

- (IBAction)leftDateArrowTapped:(id)sender {
    if (self.taskDate == nil) {
        self.taskDate = [NSDate date];
    }
    self.taskDate = [self updateDate:self.taskDate withAddingDays: - 1 ];
    [self updateDateLabelsFromCalendar:self.taskDate];
}
- (IBAction)rightDateArrowTapped:(id)sender {
    if (self.taskDate == nil) {
        self.taskDate = [NSDate date];
    }
    self.taskDate = [self updateDate:self.taskDate withAddingDays: 1 ];
    [self updateDateLabelsFromCalendar:self.taskDate];
}
- (IBAction)addUsersTapped:(id)sender {
}

#pragma mark - Create Task

- (IBAction)createTaskTapped:(id)sender {
    self.activityIndicator.hidden = NO;
    

    DatabaseService *service = [DatabaseService new];

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyy HH:mm";
    if (self.taskDate == nil) {
        self.taskDate = [NSDate date];
    }
    NSString *date = [dateFormatter stringFromDate:self.taskDate];

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
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"didCreateNewTask" object:self];
                  [self dismissViewControllerAnimated:YES completion:nil];
              }
          }];
}

#pragma mark - TextFields

- (void) setTextFieldDelegates {
    self.titleLabel.delegate = self;
    self.descriptionLabel.delegate = self;
    self.startTimeLabel.delegate = self;
    self.endTimeLabel.delegate = self;
    self.placeLabel.delegate = self;
    self.notificationLabel.delegate = self;

    [self addDatePickerToTextField:self.startTimeLabel withTimerMode:NO];
    [self addDatePickerToTextField:self.endTimeLabel withTimerMode:NO];
    [self addDatePickerToTextField:self.notificationLabel withTimerMode:YES];
}

- (void) addDatePickerToTextField:(UITextField *) textField withTimerMode:(BOOL ) timerON {
    UIDatePicker *picker = [UIDatePicker new];
    picker.date = [NSDate date];
    if (timerON) {
        picker.datePickerMode = UIDatePickerModeCountDownTimer;
    } else {
        picker.datePickerMode = UIDatePickerModeTime;
    }
    [picker addTarget:self action:@selector(updateTextFieldsFromDatePicker:) forControlEvents:UIControlEventValueChanged];
    textField.inputView = picker;
}

- (void) updateTextFieldsFromDatePicker:(id) sender {

    NSDateFormatter *timeFormatter = [NSDateFormatter new];
    timeFormatter.timeStyle = NSDateFormatterShortStyle;
    timeFormatter.dateFormat = @"HH:mm";

    if ([self.startTimeLabel isEditing]) {
        UIDatePicker *picker = (UIDatePicker *) self.startTimeLabel.inputView;
        NSString *formattedTime = [timeFormatter stringFromDate:picker.date];
        self.startTimeLabel.text = formattedTime;
    }
    if ([self.endTimeLabel isEditing]) {
        UIDatePicker *picker = (UIDatePicker *) self.endTimeLabel.inputView;
        NSString *formattedTime = [timeFormatter stringFromDate:picker.date];
        self.endTimeLabel.text = formattedTime;
    }
    if ([self.notificationLabel isEditing]) {
        UIDatePicker *picker = (UIDatePicker *) self.notificationLabel.inputView;
        NSString *formattedTime = [timeFormatter stringFromDate:picker.date];
        self.notificationLabel.text = formattedTime;
    }
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

    [self resetViewWhenKeaboardAppears:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveViewWhenKeaboardAppears:textField];
}

- (void) moveViewWhenKeaboardAppears:(UITextField *) textField {
    [UIView animateWithDuration:0.325 animations:^{
        CGRect newRect = self.view.frame;
        //        newRect.origin.y = - textField.frame.size.height;
        newRect.origin.y = self.view.frame.size.height * 0.35 - textField.frame.origin.y;
        self.view.frame = newRect;
    }];
}

- (void) resetViewWhenKeaboardAppears:(UITextField *) textField {
    [UIView animateWithDuration:0.35 animations:^{
        CGRect newRect = self.view.frame;
        newRect.origin.y = 0;
        self.view.frame = newRect;
    }];
}

- (void) addKeyboardToolBar {

    CGRect keyBoardFrame = self.titleLabel.frame;
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
    self.titleLabel.inputAccessoryView = keyboardToolBar;
    self.descriptionLabel.inputAccessoryView = keyboardToolBar;
    self.startTimeLabel.inputAccessoryView = keyboardToolBar;
    self.endTimeLabel.inputAccessoryView = keyboardToolBar;
    self.placeLabel.inputAccessoryView = keyboardToolBar;
    self.notificationLabel.inputAccessoryView = keyboardToolBar;
}

- (void) doneTextField {
    [self.titleLabel resignFirstResponder];
    [self.descriptionLabel resignFirstResponder];
    [self.startTimeLabel resignFirstResponder];
    [self.endTimeLabel resignFirstResponder];
    [self.placeLabel resignFirstResponder];
    [self.notificationLabel resignFirstResponder];
    [self resetViewWhenKeaboardAppears:nil];
}

- (void) selectPreviousTextField {

    if ([self.titleLabel isEditing]) {
        return;
    }
    if ([self.descriptionLabel isEditing]) {
        [self.titleLabel becomeFirstResponder];
        return;
    }
    if ([self.startTimeLabel isEditing]) {
        [self.descriptionLabel becomeFirstResponder];
        return;
    }
    if ([self.endTimeLabel isEditing]) {
        [self.startTimeLabel becomeFirstResponder];
        return;
    }
    if ([self.placeLabel isEditing]) {
        [self.endTimeLabel becomeFirstResponder];
        return;
    }
    if ([self.notificationLabel isEditing]) {
        [self.placeLabel becomeFirstResponder];
        return;
    }


}

- (void) selectNextTextField {

    if ([self.titleLabel isEditing]) {
        [self.descriptionLabel becomeFirstResponder];
        return;
    }
    if ([self.descriptionLabel isEditing]) {
        [self.startTimeLabel becomeFirstResponder];
        return;
    }
    if ([self.startTimeLabel isEditing]) {
        [self.endTimeLabel becomeFirstResponder];
        return;
    }
    if ([self.endTimeLabel isEditing]) {
        [self.placeLabel becomeFirstResponder];
        return;
    }
    if ([self.placeLabel isEditing]) {
        [self.notificationLabel becomeFirstResponder];
        return;
    }
    if ([self.notificationLabel isEditing]) {
        return;
    }
}

@end
