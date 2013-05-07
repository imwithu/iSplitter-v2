//
//  WUTableViewCell.m
//  iSplitter
//
//  Created by James Yu on 5/6/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUTableViewCell.h"

@implementation WUTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
  //      self.detailTextLabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 将detailTextLabel往左移动一下
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.detailTextLabel.frame;
    frame.origin.x -= 10;
    self.detailTextLabel.frame = frame;
//    self.detailTextLabel.textColor = [UIColor blackColor];
}

@end
