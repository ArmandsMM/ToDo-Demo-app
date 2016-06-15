//
//  HomeCollectionViewCell.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/15/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIStackView *usersStackView;

@end
