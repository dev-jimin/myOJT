//
//  MyTableViewCell.h
//  myOJT
//
//  Created by jiemin on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface MyTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (retain, nonatomic) IBOutlet UILabel *tvTitle;
@end
