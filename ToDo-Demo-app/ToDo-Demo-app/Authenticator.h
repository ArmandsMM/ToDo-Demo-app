//
//  Authenticator.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/3/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@protocol loginDelegate <NSObject>
- (BOOL) didLogin;
@optional
- (BOOL) didLogout;
@end

@interface Authenticator : NSObject

@property (nonatomic, strong) id <loginDelegate> logInDelegate;
- (void) configFirebase;
- (void) loginUser:(NSString *) email andPassword:(NSString *) password completion: (void (^) (NSError *error)) completionBlock;
- (void) logOutWithCompletion:(void (^)(NSError * error))completionBlock;
- (BOOL ) checkIfLoggedIn;

+(void) createUser:(NSString *) email andPassword:(NSString *) password completion:(void (^)(NSError *error))completionBlock ;

@end
