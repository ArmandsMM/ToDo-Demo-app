//
//  NavigationCollectonV.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/1/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "NavigationCollectionVC.h"
#import "NavigationCollectionViewCell.h"
#import "Configuration.h"

@implementation NavigationCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *navCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];

    navCollectionView.delegate = self;
    navCollectionView.dataSource = self;

    navCollectionView.backgroundColor = [UIColor darkGrayColor];

    [navCollectionView registerClass:[NavigationCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];

    [self.view addSubview:navCollectionView];

    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NavigationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.titleLabel.text = [Configuration sharedInstance].navigationItems[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2-20, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self dismissViewControllerAnimated:NO completion:^{
        if (self.didSelect) {
            self.didSelect([NSString stringWithFormat:@"%@", [Configuration sharedInstance].navigationItems[indexPath.row]]);
        }
        
    }];
}
@end
