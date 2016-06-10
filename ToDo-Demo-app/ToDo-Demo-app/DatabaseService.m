//
//  DatabaseService.m
//  
//
//  Created by Mikanovskis, Armands on 6/10/16.
//
//

#import "DatabaseService.h"
#import "Authenticator.h"
#import <FirebaseDatabase/FirebaseDatabase.h>

@implementation DatabaseService

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.ref = [[FIRDatabase database] reference];
//    }
//    return self;
//}
//
//- (void) saveProfileData:(NSString *) email username:(NSString *) username imageData:(NSData *) imageData {
//    NSString *key = [[self.ref child:@"posts"] childByAutoId].key;
//    NSDictionary *post = @{@"uid": userID,
//                           @"author": username,
//                           @"title": title,
//                           @"body": body};
//    NSDictionary *childUpdates = @{[@"/posts/" stringByAppendingString:key]: post,
//                                   [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]: post};
//    [_ref updateChildValues:childUpdates];
////}

@end
