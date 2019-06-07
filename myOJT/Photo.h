//
//  Photo.h
//  myOJT
//
//  Created by jiemin on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject
@property (nonatomic, retain) UIImage *img;
@property (retain) NSString *title;
+ (id) addTitle:(NSString *) title withImg:(UIImage *) img;
@end
