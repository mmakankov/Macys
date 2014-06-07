//
//  MCMainTableViewCell.h
//  Macys
//
//  Created by mmakankov on 07/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCMainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *viewImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelRegularPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelSalePrice;

@end
