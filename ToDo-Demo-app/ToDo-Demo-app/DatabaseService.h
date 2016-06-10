//
//  DatabaseService.h
//  
//
//  Created by Mikanovskis, Armands on 6/10/16.
//
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface DatabaseService : NSObject

@property (nonatomic, strong) FIRDatabaseReference *ref;

@end
