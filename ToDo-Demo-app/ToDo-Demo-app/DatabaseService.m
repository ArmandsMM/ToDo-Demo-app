//
//  DatabaseService.m
//  
//
//  Created by Mikanovskis, Armands on 6/10/16.
//
//

#import "DatabaseService.h"
#import "Authenticator.h"
#import "Configuration.h"

@implementation DatabaseService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ref = [[FIRDatabase database] reference];

    }
    return self;
}

- (void) updateProfileWithNewUsername:(NSString *) newUsername {
    [[[[self.ref child:@"user-profiles"] child:[FIRAuth auth].currentUser.uid] child:@"username"] setValue:newUsername];
}
- (void) updateProfileWithNewEmail:(NSString *) newEmail {
    [[[[self.ref child:@"user-profiles"] child:[FIRAuth auth].currentUser.uid] child:@"email"] setValue:newEmail];
}
- (void) updateProfileWithNewBirthday:(NSString *) newBirthday {
    [[[[self.ref child:@"user-profiles"] child:[FIRAuth auth].currentUser.uid] child:@"birthday"] setValue:newBirthday];
}

- (void) saveProfileDataToDatabaseWithUsername:(NSString *)username email:(NSString *)email birthday:(NSString *)birthday imagePath:(NSString *)path {
    //[[[self.ref child:@"users"] child:[FIRAuth auth].currentUser.uid] setValue:@{@"username": @"this is my name"}];
    NSDictionary *post = @{@"username": username,
                           @"email": email,
                           @"birthday": birthday,
                           @"image": path};
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/user-profiles/%@/", [FIRAuth auth].currentUser.uid]: post};
    [_ref updateChildValues:childUpdates];
}

- (void) updateTasksInUserProfile:(NSString *) taskId {
    NSString *key = [[self.ref child:[NSString stringWithFormat:@"/user-profiles/%@", [FIRAuth auth].currentUser.uid]] childByAutoId].key;

    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/user-profiles/%@/created-tasks/%@", [FIRAuth auth].currentUser.uid,key]:taskId};
    [self.ref updateChildValues:childUpdates];

}

- (void)createNewTask:(NSString *)date taskTitle:(NSString *)title taskDescription:(NSString *)description time:(NSArray *)time place:(NSString *)place withUsers:(NSArray *)users withNotification:(NSNumber *)minutesBefore completion:(void (^)(BOOL))completionBlock {

    NSString *combinedUsers = [users componentsJoinedByString:@"-"];

    NSString *key = [[self.ref child:@"tasks"] childByAutoId].key;
    NSDictionary *post = @{@"date": date,
                           @"title": title,
                           @"description":description,
                           @"time-start": time[0],
                           @"time-end": time[1],
                           @"place": place,
                           @"users": combinedUsers,
                           @"task-author": [FIRAuth auth].currentUser.uid,
                           @"task-id": key};
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/tasks/%@", key]:post};
    [self.ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (!error) {
            if (completionBlock != nil) {
                completionBlock(YES);
                [self updateTasksInUserProfile:key];

            }
        } else {
            if (completionBlock != nil) {
                completionBlock(NO);
            }
        }
    }];
}

- (void) downloadTasks:(FIRDataSnapshot *) tasksSnapshot {
        [[[self.ref child:@"tasks"] child:tasksSnapshot.value] observeSingleEventOfType:FIRDataEventTypeValue
                                                                                 withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                                                                     NSLog(@"downloaded Tasks: %@", snapshot);
                                                                                     [self saveTaskLocally:snapshot.value];
                                                                                     [self.downloadDelegate taskDownloaded];
                                                                                 }];
}

#pragma mark - firebase listener

- (void) readUserDataOnce {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    if (userID == nil) {
        return;
    }
    [[[self.ref child:@"user-profiles"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //NSLog(@"%@", snapshot.value[@"username"]);
        if (snapshot != nil) {
//            [self.userDelegate userDataDownloaded:snapshot];
//            [Configuration sharedInstance].user.username = snapshot.value[@"username"];
//            [Configuration sharedInstance].user.email = snapshot.value[@"email"];
//            [Configuration sharedInstance].user.birthday = snapshot.value[@"birthday"];
//            [Configuration sharedInstance].user.createdTaskIDs = [snapshot.value[@"created-tasks"] allValues];
        }

    }];
}

- (void) listenForTaskDataChangeFromFirebase {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    //listen for added task
    if (userID != nil) {
        [[[[self.ref child:@"user-profiles"] child:userID] child:@"created-tasks"] observeEventType:FIRDataEventTypeChildAdded
                                                                                          withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                                                                              if (snapshot != nil) {
                                                                                                  if (![self allreadyIsLocal:snapshot.value]) {
                                                                                                      [self downloadTasks:snapshot];
                                                                                                  }
                                                                                              }
                                                                                          }];
        //listen for removed task
        [[[[self.ref child:@"user-profiles"] child:userID] child:@"created-tasks"] observeEventType:FIRDataEventTypeChildRemoved
                                                                                          withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {                                                                                              if (snapshot != nil) {

        }
                                                                                          }];

        [[[self.ref child:@"user-profiles"] child:userID] observeEventType:FIRDataEventTypeValue
                                                                 withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                                                     if (snapshot != nil) {
                                                                         [self.userDelegate userDataDownloaded:snapshot];
//                                                                         [Configuration sharedInstance].user.username = snapshot.value[@"username"];
//                                                                         [Configuration sharedInstance].user.email = snapshot.value[@"email"];
//                                                                         [Configuration sharedInstance].user.birthday = snapshot.value[@"birthday"];
//                                                                         [Configuration sharedInstance].user.createdTaskIDs = [snapshot.value[@"created-tasks"] allValues];
                                                                     }
                                                                 }];
    }
}

#pragma mark - local save/load

- (BOOL) allreadyIsLocal :(NSString *) task {
    NSDictionary *localTasks = [self loadLocalTasks];
    if (localTasks != nil) {
        for (NSDictionary *singleLocalTask in [localTasks objectForKey:@"tasks"]) {
            if ([[singleLocalTask valueForKey:@"task-id"] isEqualToString:task]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void) saveTaskLocally:(NSDictionary *) task {
    NSMutableArray *dataToSave = [NSMutableArray new];
    [dataToSave addObject:task];

    NSDictionary *oldData = [self loadLocalTasks];
    if (oldData != nil) {
        for (NSDictionary *localTask in [oldData objectForKey:@"tasks"]) {
            [dataToSave addObject:localTask];
        }
    }

    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    if (task != nil) {
        [dataDict setObject:dataToSave forKey:@"tasks"];

    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingString:@"/tasks"];

    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
    //NSLog(@"task: %@ saved at path: %@", dataDict, filePath);
}

- (NSDictionary *) loadLocalTasks {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingString:@"/tasks"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *loadedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //NSLog(@"loaded data: %@", loadedData);
        if ([loadedData objectForKey:@"tasks"] != nil) {
            return loadedData;
        }
    }
    return nil;

}

- (NSArray *) loadLocalTasksForUser:(NSString *) userID {
    NSMutableArray *userLocalTasks = [NSMutableArray new];
    NSDictionary *allLocalTaks = [self loadLocalTasks];
    if (allLocalTaks != nil) {
        for (NSDictionary *task in [allLocalTaks objectForKey:@"tasks"]) {
            //NSLog(@"loaded user tasks: %@", task);
            if ([[task valueForKey:@"task-author"] isEqualToString:userID]) {
                [userLocalTasks addObject:task];
            }
        }
    }

    return userLocalTasks.copy;
}

- (void) deleteAllLocalTasks {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingString:@"/tasks"];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (!success) {
        NSLog(@"delete: %@", error.localizedDescription);
    } else {
        NSLog(@"deleted successifully");
    }
}

@end
