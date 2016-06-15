//
//  DatabaseService.m
//  
//
//  Created by Mikanovskis, Armands on 6/10/16.
//
//

#import "DatabaseService.h"
#import "Authenticator.h"
//#import <FirebaseDatabase/FirebaseDatabase.h>

@implementation DatabaseService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
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
                           @"task-author": [FIRAuth auth].currentUser.uid};
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

    [self saveTaskLocally:post];
}

- (void) saveTaskLocally:(NSDictionary *) task {
    NSMutableArray *dataToSave = [NSMutableArray new];
    [dataToSave addObject:task];

    NSDictionary *oldData = [self loadLocalTasks];
    if (oldData != nil) {
        for (NSDictionary *item in [oldData objectForKey:@"tasks"]) {
            [dataToSave addObject:item];
        }
    }

    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    if (task != nil) {
        [dataDict setObject:dataToSave forKey:@"tasks"];

    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingString:@"tasks"];

    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];

    [self loadLocalTasks];
}

- (NSDictionary *) loadLocalTasks {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingString:@"tasks"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *loadedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([loadedData objectForKey:@"tasks"] != nil) {
            //NSLog(@"loaded tasks: %@", [loadedData objectForKey:@"tasks"]);
            return loadedData;
        }
    }
    return nil;

}

@end
