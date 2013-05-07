//
//  WUNumberKeyboardTableViewCell.m
//  iSplitter
//
//  Created by James Yu on 5/5/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUNumberKeyboardTableViewCell.h" 


@implementation WUNumberKeyboardTableViewCell

@synthesize keyboard, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initializeInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeInputView];
    }
    return self;
}

- (void)initializeInputView
{
    self.keyboard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];  //只要宽度和高度不为0，其他不敏感，不知道为什么。如果是CGRectZero的话就显示不出来。
	self.keyboard.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self drawKeyboard];
    
}

- (UIView *)inputView
{
    return self.keyboard;
}

- (UIView *)inputAccessoryView
{
    if (!inputAccessoryView) {
        inputAccessoryView = [[UIToolbar alloc] init];
        inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
        inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [inputAccessoryView sizeToFit];
        CGRect frame = inputAccessoryView.frame;
        frame.size.height = 44.0f;
        inputAccessoryView.frame = frame;
        
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done:)];
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                           target:nil
                                                                                           action:nil];
        
        NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
        [inputAccessoryView setItems:array];
    }
    return inputAccessoryView;

}

- (IBAction)done:(id)sender
{
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
	[self.keyboard setNeedsLayout];
	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	UITableView *tableView = (UITableView *)self.superview;
	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
    [tableView reloadData];
	return [super resignFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
    if (selected) {
        [super becomeFirstResponder];
    }
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)drawKeyboard
{
    [self drawButtonWithFrame:CGRectMake(    0,   0, 107, 54) title:@"7" image:nil];
    [self drawButtonWithFrame:CGRectMake(  107,   0, 106, 54) title:@"8" image:nil];
    [self drawButtonWithFrame:CGRectMake(  213,   0, 107, 54) title:@"9" image:nil];
    [self drawButtonWithFrame:CGRectMake(    0,  54, 107, 54) title:@"4" image:nil];
    [self drawButtonWithFrame:CGRectMake(  107,  54, 106, 54) title:@"5" image:nil];
    [self drawButtonWithFrame:CGRectMake(  213,  54, 107, 54) title:@"6" image:nil];
    [self drawButtonWithFrame:CGRectMake(    0, 108, 107, 54) title:@"1" image:nil];
    [self drawButtonWithFrame:CGRectMake(  107, 108, 106, 54) title:@"2" image:nil];
    [self drawButtonWithFrame:CGRectMake(  213, 108, 107, 54) title:@"3" image:nil];
    [self drawButtonWithFrame:CGRectMake(    0, 162, 107, 54) title:@"Clean" image:nil];
    [self drawButtonWithFrame:CGRectMake(  107, 162, 106, 54) title:@"0" image:nil];
    [self drawButtonWithFrame:CGRectMake(  213, 162, 107, 54) title:@"<" image:nil];
}


-(UIButton *)drawButtonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    UIFont *font = [UIFont fontWithName:@"GillSans" size:24];
    btn.titleLabel.font = font;
    btn.imageView.image = image;
    
    [btn addTarget:self action:@selector(keyboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [keyboard addSubview:btn];
    
    return btn;
}

- (IBAction)keyboardButtonPressed:(UIButton *)sender
{
    if (delegate && [delegate respondsToSelector:@selector(keyboardCell:keyboardPressed:)]) {
		[delegate keyboardCell:self keyboardPressed:sender.titleLabel.text];
	}
}



@end
