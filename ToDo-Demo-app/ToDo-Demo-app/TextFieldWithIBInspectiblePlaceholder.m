//
//  TextFieldWithIBInspectiblePlaceholder.m
//  ToDo-Demo-app
//
//  Created by Mikanovskis, Armands on 6/14/16.
//  Copyright © 2016 Mikanovskis, Armands. All rights reserved.
//

#import "TextFieldWithIBInspectiblePlaceholder.h"

@implementation TextFieldWithIBInspectiblePlaceholder


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIColor *color = self.PlaceholderColor;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}

@end
