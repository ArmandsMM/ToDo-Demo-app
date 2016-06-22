//
//  DatabaseService.h
//  
//
//  Created by Mikanovskis, Armands on 6/10/16.
//
//

#import <Foundation/Foundation.h>
@import Firebase;
@import FirebaseDatabase;

@protocol taskDownloadDelegate <NSObject>

- (void) taskDownloaded;

@end

@interface DatabaseService : NSObject

@property (nonatomic, strong) id <taskDownloadDelegate> downloadDelegate;

@property (nonatomic, strong) FIRDatabaseReference *ref;

- (void) saveProfileDataToDatabaseWithUsername:(NSString *) username email:(NSString *) email birthday:(NSString *) birthday imagePath:(NSString *) path;

- (void) createNewTask:(NSString *) date taskTitle:(NSString *) title taskDescription:(NSString *) description time:(NSArray *) time place:(NSString *) place  withUsers:(NSArray *) users withNotification:(NSNumber *) minutesBefore completion:(void (^)(BOOL success))completionBlock;

- (void) readUserDataOnce;
- (void) listenForTaskDataChangeFromFirebase;

- (NSDictionary *) loadLocalTasks;
- (NSArray *) loadLocalTasksForUser:(NSString *) userID;

- (void) deleteAllLocalTasks;

@end
