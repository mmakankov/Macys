//
//  MCColorCell.h
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCColorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIView *viewColor;
@property (weak, nonatomic) IBOutlet UILabel *labelKey;

@end
