//
//  Photo.m
//  myOJT
//
//  Created by jiemin on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import "Photo.h"

@implementation Photo {
    NSString *title;
    NSString *url;
}

+ (Photo *) initWithTitle:(NSString *)title withUrl:(NSString *)url {
    Photo *result = [[Photo alloc] init];
    result.title = title;
    result.url = url;
    return result;
}

- (NSString *)title {
    return self -> title;
}
- (void)setTitle:(NSString *)title {
    if (title != nil) self -> title = title;
}

- (NSString *)url {
    return self -> url;
}
- (void)setUrl:(NSString *)url {
    if (url != nil) self -> url = url;
}

@end
