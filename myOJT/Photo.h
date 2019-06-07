//
//  Photo.h
//  myOJT
//
//  Created by jiemin on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

- (NSString *) title;
- (void) setTitle:(NSString *) title;

- (NSString *) url;
- (void) setUrl:(NSString *) url;

+ (Photo *) initWithTitle:(NSString *) title withUrl:(NSString *) url;

@end
