//
//  WUUserGuideViewController.m
//  iSplitter
//
//  Created by James Yu on 5/8/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUUserGuideViewController.h"
#import "WUMainViewController.h"

@interface WUUserGuideViewController () {
    float height;
    float width;
    NSString *filePrefix;
}

@end

@implementation WUUserGuideViewController

@synthesize scrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initUserGuide];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initUserGuide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define GUIDE_PICTURE_NUMBER 8

- (void)initUserGuide
{
    height = [[UIScreen mainScreen] bounds].size.height;
    width = [[UIScreen mainScreen] bounds].size.width;
    
    filePrefix = @"user_guide_%d.png";
    
    [scrollView setContentSize:CGSizeMake(320*GUIDE_PICTURE_NUMBER,0)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setPagingEnabled:YES];
    
    for (int i = 0; i<GUIDE_PICTURE_NUMBER; i++) {
        [self addGuidePictureAtIndex:i];
    }    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(320*(GUIDE_PICTURE_NUMBER-1)+100, 300, 120, 40);
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitle:@"Start" forState:UIControlStateNormal];
    [btn setTitle:@"GO!" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(userGuideFinishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:btn];
    
}

- (void)addGuidePictureAtIndex:(int)index
{
    NSLog(@"add picture at index %d..", index);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*index+20, 30, width-40, height-60)];
    NSString *imageName = [NSString stringWithFormat:filePrefix, index];
    if (index == 0) {
        imageName = @"user_guide_start.png";
    } else if ( index == GUIDE_PICTURE_NUMBER-1) {
        imageName = @"user_guide_go.png";
    }
    [imageView  setImage: [UIImage imageNamed:imageName]];
    [scrollView addSubview:imageView];
}

- (void)userGuideFinishButtonPressed
{
    if (self.delegate) {
        [self.delegate helpViewControllerDidFinished:self];
    } else {
        WUMainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self presentViewController:mainViewController animated:YES completion:nil];
    }
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
