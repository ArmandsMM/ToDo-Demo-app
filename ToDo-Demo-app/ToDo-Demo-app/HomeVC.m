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

@property (strong, nonatomic) NSArray *tasks;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLocalTasks];
    [self setupBackgroundColorsForViews];

    self.homeCollectionView.delegate = self;
    self.homeCollectionView.dataSource = self;
}

- (void) setupBackgroundColorsForViews {
    self.headerView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    self.homeCollectionView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
}

- (void) loadLocalTasks {

    self.tasks = [NSArray new];
//    self.tasks = [[Configuration sharedInstance].localTasks copy];
    self.tasks = [self refreshLocalTasks];
    [self.homeCollectionView reloadData];
}

- (NSArray *) refreshLocalTasks {
    DatabaseService *service = [DatabaseService new];
    NSDictionary *refreshedDict = [service loadLocalTasks];
    NSMutableArray *tempTaskArray= [NSMutableArray new];
    for (NSDictionary* item in [refreshedDict objectForKey:@"tasks"]) {
        [tempTaskArray addObject:item];
    }
    return tempTaskArray;
}

- (IBAction)leftArrowTapped:(id)sender {
}

- (IBAction)rightArrowTapped:(id)sender {
    [self.homeCollectionView reloadData];
}

#pragma mark - CollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    cell.timeLabel.text = [self.tasks[indexPath.row] valueForKey:@"time-start"];
    cell.titleLabel.text = [self.tasks[indexPath.row] valueForKey:@"title"];

//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:cell.bounds];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = [self.tasks[indexPath.row] valueForKey:@"title"];
//    [cell addSubview:titleLabel];

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadLocalTasks)
                                                 name:@"didCreateNewTask"
                                               object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
