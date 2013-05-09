//
//  WUUserGuideViewController.h
//  iSplitter
//
//  Created by James Yu on 5/8/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WUUserGuideViewController ;

@protocol WUUserGuideViewControllerDelegate <NSObject>

- (void)helpViewControllerDidFinished:(WUUserGuideViewController *)userGuideViewController;

@end


@interface WUUserGuideViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) id<WUUserGuideViewControllerDelegate> delegate;

@end
