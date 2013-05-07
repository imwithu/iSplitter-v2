//
//  WUNumberKeyboardTableViewCell.h
//  iSplitter
//
//  Created by James Yu on 5/5/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUTableViewCell.h"

@class WUNumberKeyboardTableViewCell;

@protocol WUNumberKeyboardTableViewCellDelegate <NSObject>

@optional
- (void)keyboardCell:(WUNumberKeyboardTableViewCell *)cell keyboardPressed:(NSString *)key;

@end

@interface WUNumberKeyboardTableViewCell : WUTableViewCell {
    UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) UIView *keyboard;
@property (nonatomic, weak) id <WUNumberKeyboardTableViewCellDelegate> delegate;

@end
