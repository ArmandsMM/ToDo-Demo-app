//
//  NavigationCollectonV.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/1/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "NavigationCollectonVC.h"
#import "NavigationCollectionViewCell.h"

@implementation NavigationCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"inside collection view");
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *navCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) collectionViewLayout:layout];

    navCollectionView.delegate = self;
    navCollectionView.dataSource = self;

    navCollectionView.backgroundColor = [UIColor yellowColor];

    [navCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];

    [self.view addSubview:navCollectionView];

    [navCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 35;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2 - 20, 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 5);
}
@end
