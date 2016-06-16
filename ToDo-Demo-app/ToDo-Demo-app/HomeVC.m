//
//  HomeVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "HomeVC.h"
#import "DatabaseService.h"
#import "Configuration.h"
#import "HomeCollectionViewCell.h"

@interface HomeVC()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UICollectionView *homeCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *taskCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDaylabel;

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSArray *tasks;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackgroundColorsForViews];
    self.date = [NSDate date];

    [self reloadLocalTasks];

    self.homeCollectionView.delegate = self;
    self.homeCollectionView.dataSource = self;
}

#pragma mark - Date Labels

- (void) updateDateLabelsFromCalendar:(NSDate *) inputDate {
    if (inputDate.timeIntervalSinceNow < 24*60 && inputDate.timeIntervalSinceNow > -24*60) {
        self.taskDaylabel.text = @"DUE TODAY";
        return;
    }

    NSDate *date = [NSDate date];
    if (inputDate != nil) {
        date = inputDate;
    }

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];

    NSInteger day = components.day;
    NSInteger month = components.month;
    NSInteger year = components.year;

    NSDateFormatter *formatter = [NSDateFormatter new];

    self.taskDaylabel.text = [NSString stringWithFormat:@"%ld %@ %ld", (long)day, [[formatter monthSymbols] objectAtIndex:month-1], (long)year];
}

- (NSDate *) updateDate:(NSDate *) date withAddingDays:(int) addDay {

    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = addDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    return newDate;
}

- (IBAction)leftArrowTapped:(id)sender {
    if (self.date == nil) {
        self.date = [NSDate date];
    }
    self.date = [self updateDate:self.date withAddingDays: - 1 ];
    [self updateDateLabelsFromCalendar:self.date];
    [self reloadLocalTasks];
}

- (IBAction)rightArrowTapped:(id)sender {
    if (self.date == nil) {
        self.date = [NSDate date];
    }
    self.date = [self updateDate:self.date withAddingDays: 1 ];
    [self updateDateLabelsFromCalendar:self.date];
    [self reloadLocalTasks];
}

- (void) setupBackgroundColorsForViews {
    self.headerView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    self.homeCollectionView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
}
#pragma mark - Tasks

- (void) reloadLocalTasks {

    self.tasks = [NSArray new];
    self.tasks = [self refreshLocalTasks];
    [self updateTaskCountLabel];
    [self.homeCollectionView reloadData];
}

- (NSArray *) refreshLocalTasks {
    DatabaseService *service = [DatabaseService new];
    NSDictionary *refreshedDict = [service loadLocalTasks];
    NSMutableArray *tempTaskArray= [NSMutableArray new];
    for (NSDictionary* item in [refreshedDict objectForKey:@"tasks"]) {
        [tempTaskArray addObject:item];
    }

    return [self pickTasks:tempTaskArray ForDate:self.date];
}

- (NSArray *) pickTasks:(NSArray *) tasks ForDate: (NSDate *) date {
    NSMutableArray *tasksForDate = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    for (NSDictionary *task in tasks) {
        if ([[dateFormatter stringFromDate:date] isEqualToString:[task valueForKey:@"date"]]) {
            [tasksForDate addObject:task];
        }
    }

    return tasksForDate;
}

- (void) updateTaskCountLabel {
    if (self.tasks.count == 1) {
        self.taskCountLabel.text = [NSString stringWithFormat:@"%lu Task", (unsigned long)self.tasks.count];

    }
    if (self.tasks.count == 0) {
        self.taskCountLabel.text = @"No Tasks";
    } else {
        self.taskCountLabel.text = [NSString stringWithFormat:@"%lu Tasks", (unsigned long)self.tasks.count];
    }
}


#pragma mark - CollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@", [self.tasks[indexPath.row] valueForKey:@"time-start"],[self.tasks[indexPath.row] valueForKey:@"time-end"]];
    cell.titleLabel.text = [self.tasks[indexPath.row] valueForKey:@"title"];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.homeCollectionView.frame.size.width/2-20, self.homeCollectionView.frame.size.width/2-20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 10, 15);
}

#pragma mark - Notifications

- (void)awakeFromNib {
    [super awakeFromNib];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadLocalTasks)
//                                                 name:@"didCreateNewTask"
//                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadLocalTasks)
                                                 name:@"taskDownloadedAndSaved"
                                               object:nil];

}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
