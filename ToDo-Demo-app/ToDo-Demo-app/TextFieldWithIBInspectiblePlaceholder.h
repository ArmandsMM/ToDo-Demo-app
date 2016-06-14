//
//  TextFieldWithIBInspectiblePlaceholder.h
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/14/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface TextFieldWithIBInspectiblePlaceholder : UITextField

@property (nonatomic) IBInspectable UIColor *PlaceholderColor;

@end
