//
//  StorageService.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/13/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import Firebase;

@import FirebaseStorage;

@interface StorageService : NSObject

@property (nonatomic, strong) FIRStorageReference *storageReference;
@property (nonatomic, strong) FIRStorageReference *imagesFolderRef;

- (void) uploadImage:(NSData *) imageData forUser:(NSString *) user;
- (UIImage *) downloadImageForUser:(NSString *) user;
- (void) downloadProfileImage:(void (^)(UIImage *image)) completionBlock;
@end
