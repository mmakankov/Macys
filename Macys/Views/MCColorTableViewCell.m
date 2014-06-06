//
//  MCColorCell.m
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "MCColorTableViewCell.h"

@implementation MCColorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    
    self.viewColor.layer.cornerRadius = 13.0f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
