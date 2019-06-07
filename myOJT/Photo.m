//
//  Photo.m
//  myOJT
//
//  Created by jiemin on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import "Photo.h"

@implementation Photo
@synthesize img;
@synthesize title;

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (id) addTitle:(NSString *)title withImg:(UIImage *)img {
    Photo *p = [[Photo alloc] init];
    p.img = img;
    p.title = title;
    return p;
}

@end
