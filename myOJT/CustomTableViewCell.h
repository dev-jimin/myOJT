//
//  CustomTableViewCell.h
//  myOJT
//
//  Created by FrontEnd on 08/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (strong, nonatomic) IBOutlet UILabel *tvTitle;
@end

NS_ASSUME_NONNULL_END
