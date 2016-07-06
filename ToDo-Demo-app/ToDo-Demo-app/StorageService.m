//
//  StorageService.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/13/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "StorageService.h"


@implementation StorageService

- (instancetype)init {
    self = [super init];
    if (self) {
        FIRStorage *storage = [FIRStorage storage];
        self.storageReference = [storage referenceForURL:@"gs://todo-demo-app-2ca4a.appspot.com"];
        self.imagesFolderRef = [self.storageReference child:@"images"];
    }
    return self;
}

- (void)uploadImage:(NSData *)imageData forUser:(NSString *)user {

    FIRStorageReference *userRef = [self.imagesFolderRef child:[NSString stringWithFormat:@"%@", user]];

    FIRStorageReference *imageRef = [userRef child:@"profile-image.jpg"];
    FIRStorageUploadTask *uploadTask = [imageRef putData:imageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"<StorageService> %@", error.localizedDescription);
        } else {
            //NSURL *downloadURL = metadata.downloadURL;
        }
    }];

    [uploadTask resume];

}

//- (UIImage *)downloadImageForUser:(NSString *)user {
//    __block UIImage *image = [UIImage new];
//    FIRStorageReference *userProfileImageRef = [self.storageReference child:[NSString stringWithFormat:@"%@/profile-image.jpg", user]];
//    
//    [userProfileImageRef dataWithMaxSize:1*1024*1024
//                              completion:^(NSData * _Nullable data, NSError * _Nullable error) {
//                                  if (error != nil) {
//                                      NSLog(@"<StorageService> %@", error.localizedDescription);
//                                  } else {
//                                      image = [UIImage imageWithData:data];
//                                  }
//                              }];
//    return image;
//
//}

- (void) downloadProfileImage:(void (^)(UIImage *image))completionBlock {
    [[[[self.storageReference child:@"images"] child:[FIRAuth auth].currentUser.uid] child:@"profile-image.jpg"] dataWithMaxSize:2*1024*1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"storage : %@", error.localizedDescription);
        } else {
            if (completionBlock != nil) {
                completionBlock([UIImage imageWithData:data]);
            }
        }
    }];
}

@end
