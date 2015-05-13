//
//  SimpleTableCellTableViewCell.h
//  DeviceSender
//
//  Created by Laur Neagu on 11/05/15.
//  Copyright (c) 2015 Laur Neagu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCellTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UISwitch *enabledSwitch;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@end
