//
//  User.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/29/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init {
    self = [super init];
    if (self) {
        self.username = @"rand0m-guy";
        self.email = @"email@email.com";
        self.birthday = @"1200 B.C";
        self.image = nil;
        self.password = nil;
    }
    return self;
}

@end
