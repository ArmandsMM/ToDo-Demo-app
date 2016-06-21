//
//  SettingsTVC.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/20/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "SettingsTVC.h"

@interface SettingsTVC ()

@property BOOL isExpandedCell;
@property (nonatomic, strong) NSIndexPath *indexPathForExpanding;
@property (strong, nonatomic) IBOutlet UISwitch *notificationsSwitch;

@end

@implementation SettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExpandedCell = NO;
}

#pragma mark - Notifications

- (IBAction)notificationSwitchToggled:(id)sender {
    if (self.notificationsSwitch.isOn) {
        NSLog(@"notifications is ON");
    } else {
        NSLog(@"notifications is OFF");
    }
}

#pragma mark - TableView

- (void) toggleExpandedCell {
    self.isExpandedCell = !self.isExpandedCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell %ld tapped", (long)indexPath.row);
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 11) {

        [self toggleExpandedCell];
        self.indexPathForExpanding = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        NSArray *indexPathArray = [NSArray arrayWithObject:self.indexPathForExpanding];
        [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = tableView.rowHeight;
    if (indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 12) {
        height = 0;
    }
    if (self.isExpandedCell && indexPath.row == self.indexPathForExpanding.row) {
        height = 200;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
}


@end
