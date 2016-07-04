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
        //[FIRApp configure];
    }
    return self;
}

- (void) configFirebase {
    [FIRApp configure];
}

- (BOOL ) checkIfLoggedIn {
    if ([FIRAuth auth].currentUser) {
        //[self.logInDelegate didLogin];
        return YES;
    }
    //[self.logInDelegate didLogout];
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


- (void) loginUser:(NSString *) email andPassword:(NSString *) password completion:(void (^)(NSError *))completionBlock {

    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            //NSLog(@"<Authenticator> Couldn't log in: %@", error);
            if (completionBlock != nil) {
                completionBlock(error);
                
            }
        } else {
            //NSLog(@"<Authenticator> Yay! we are in: %@", user.email);
            [self.logInDelegate didLogin];
            if (completionBlock != nil) {
                completionBlock(nil);
            }

        }
    }];
}

- (void) logOutWithCompletion:(void (^)(NSError *))completionBlock {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        [self.logInDelegate didLogout];
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

- (void) reauthenticateUserWithEmail:(NSString *) email password:(NSString *) password completion: (void (^)(NSError * error))completionBlock {
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRAuthCredential *credential = [FIREmailPasswordAuthProvider credentialWithEmail:email
                                                                             password:password];

    [user reauthenticateWithCredential:credential completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"<Authenticator> %@", error.localizedDescription);
            if (completionBlock != nil) {
                completionBlock(error);
            }
        } else {
            NSLog(@"<Authenticator> user reauthenticated");
            if (completionBlock !=nil) {
                completionBlock(nil);
            }
        }
    }];
}

- (void) deleteUserFromFireBaseDB {
    FIRUser *user = [FIRAuth auth].currentUser;
    [user deleteWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"<Authenticator> user deletion failed %@", error.localizedDescription);
//            [self reauthenticateUser:^(NSError *error) {
//                if (!error) {
//                    [self deleteUserFromFireBaseDB];
//                    NSLog(@"<Authenticator> user deleted.");
//                }
//            }];
        } else {
            NSLog(@"<Authenticator> user deleted.");
        }
    }];
}

- (void) sendPasswordResetEmail:(NSString *) email {
    [[FIRAuth auth] sendPasswordResetWithEmail:email completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"<Authenticator> password reset email sending failed. %@", error.localizedDescription);
        } else {
            NSLog(@"<Authenticator> password reset email sent.");
        }
    }];
}

- (void) changeUsersPassword:(NSString *) newPassword {
    FIRUser *user = [FIRAuth auth].currentUser;
    [user updatePassword:newPassword completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"<Authenticator> %@", error.localizedDescription);
//            [self reauthenticateUser:^(NSError *error) {
//                if (!error) {
//                    [self changeUsersPassword:newPassword];
//                    NSLog(@"<Authenticator> password changed.");
//                }
//            }];
        } else {
            NSLog(@"<Authenticator> password changed.");
        }
    }];
}

- (void) changeUsersEmail:(NSString *) newEmail oldEmail:(NSString *) oldEmail password:(NSString *) password completion:(void (^)(NSError * error))completionBlock {
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
        [user updateEmail:newEmail completion:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"<Authenticator> change email succes. first try.");
                if (completionBlock!=nil) {
                    completionBlock(nil);
                }
            } else {
                NSLog(@"<Authenticator> %@", error.localizedDescription);
                [self reauthenticateUserWithEmail:oldEmail password:password completion:^(NSError *error) {
                    if (!error) {
                        FIRUser *user = [FIRAuth auth].currentUser;
                        [user updateEmail:newEmail completion:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"<Authenticator> %@", error.localizedDescription);
                                if (completionBlock!=nil) {
                                    completionBlock(error);
                                }
                            } else {
                                NSLog(@"<Authenticator> email changed");
                                if (completionBlock!=nil) {
                                    completionBlock(nil);
                                }
                            }
                        }];
                    } else {
                        NSLog(@"<Authenticator> %@", error.localizedDescription);
                        if (completionBlock!=nil) {
                            completionBlock(error);
                        }
                    }
                }];
            }
        }];
    } else {
        NSLog(@"<Authenticator> %@", @"user is nil");
        return;
    }
}

@end
