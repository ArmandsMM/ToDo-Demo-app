//
//  User.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/29/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *createdTaskIDs;

@property (nonatomic, strong) NSString *password;

@end
