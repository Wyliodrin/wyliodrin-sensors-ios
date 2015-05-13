//
//  SimpleTableCellTableViewCell.m
//  DeviceSender
//
//  Created by Laur Neagu on 11/05/15.
//  Copyright (c) 2015 Laur Neagu. All rights reserved.
//

#import "SimpleTableCellTableViewCell.h"

@implementation SimpleTableCellTableViewCell

@synthesize nameLabel = _nameLabel;
@synthesize enabledSwitch = _enabledSwitch;
@synthesize thumbnailImageView = _thumbnailImageView;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
