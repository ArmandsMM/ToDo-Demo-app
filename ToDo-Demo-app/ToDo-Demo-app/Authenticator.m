//
//  Authenticator.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/3/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "Authenticator.h"
#import <FirebaseAuth/FIRAuth.h>

@implementation Authenticator

- (instancetype)init {
    self = [super init];
    if (self) {
        [FIRApp configure];
    }
    return self;
}

+ (BOOL ) checkIfLoggedIn {
    if ([FIRAuth auth].currentUser) {
        return YES;
    }
    return NO;
}

+(void) createUser:(NSString *) email andPassword:(NSString *) password completion:(void (^)(NSError *))completionBlock {
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            //NSLog(@"<Authenticator> Couldn't create user: %@", error);
            if (completionBlock != nil) {
                completionBlock(error);
            }
        } else {
            //NSLog(@"<Authenticator> user created. Yay!: %@", user.email);
            if (completionBlock != nil) {
                completionBlock(nil);
            }
        }
    }];

}


+ (void) loginUser:(NSString *) email andPassword:(NSString *) password completion:(void (^)(NSError *))completionBlock {

    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            //NSLog(@"<Authenticator> Couldn't log in: %@", error);
            if (completionBlock != nil) {
                completionBlock(error);
            }
        } else {
            //NSLog(@"<Authenticator> Yay! we are in: %@", user.email);
            if (completionBlock != nil) {
                completionBlock(nil);
            }

        }
    }];
}

+ (void) logOutWithCompletion:(void (^)(NSError *))completionBlock {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        if (completionBlock !=  nil) {
            completionBlock(nil);
            NSLog(@"<Authenticator> %@",@"logged out");
        }
    } else {
        if (completionBlock != nil) {
            completionBlock(error);
        }
    }
}


@end
