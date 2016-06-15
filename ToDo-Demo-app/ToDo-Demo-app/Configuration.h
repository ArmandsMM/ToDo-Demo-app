//
//  Configuration.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/2/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@property (nonatomic, strong) NSArray *tabbarItems;
@property (nonatomic, strong) NSArray *navigationItems;
@property (nonatomic, strong) NSArray *navigationViews;

//@property (nonatomic, strong) NSMutableArray *localTasks;

+ (instancetype)sharedInstance;

//+ (NSArray *) refreshLocalTasks;

@end
