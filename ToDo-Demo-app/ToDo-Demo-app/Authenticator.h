//
//  Authenticator.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/3/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface Authenticator : NSObject

+ (void) loginUser:(NSString *) email andPassword:(NSString *) password completion: (void (^) (NSError *error)) completionBlock;
+ (void) logOutWithCompletion:(void (^)(NSError * error))completionBlock;
+ (BOOL ) checkIfLoggedIn;

+(void) createUser:(NSString *) email andPassword:(NSString *) password completion:(void (^)(NSError *error))completionBlock ;

@end
