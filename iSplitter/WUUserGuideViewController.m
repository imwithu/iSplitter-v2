//
//  WUUserGuideViewController.m
//  iSplitter
//
//  Created by James Yu on 5/8/13.
//  Copyright (c) 2013 Jianqiang Yu. All rights reserved.
//

#import "WUUserGuideViewController.h"
#import "WUMainViewController.h"

@interface WUUserGuideViewController ()

@property (assign, nonatomic) BOOL animating;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation WUUserGuideViewController

@synthesize scrollView, animating, pageControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
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

- (void)initUserGuide
{
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    float widthShrink = 40;
    float heightShrink = 60;
    
    NSArray *guidePictures = [NSArray arrayWithObjects:@"ug_start", @"ug_1", @"ug_2", @"ug_3", @"ug_4", @"ug_5", @"ug_6", @"ug_go", nil];
    if (height > 480) {
        heightShrink = 71;
        guidePictures = [NSArray arrayWithObjects:@"ug_start", @"ug_1-568h@2x", @"ug_2-568h@2x", @"ug_3-568h@2x", @"ug_4-568h@2x", @"ug_5-568h@2x", @"ug_6-568h@2x", @"ug_go", nil];
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100, height-20, 120, 20)];
    pageControl.numberOfPages = [guidePictures count];
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [scrollView setContentSize:CGSizeMake(width*[guidePictures count],0)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO]; //隐藏水平滚动条
    
    UIImageView *imageView = nil;
    UIButton *btn = nil;
    for (int i = 0; i<[guidePictures count]; i++) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*i+widthShrink/2, heightShrink/2, width-widthShrink, height-heightShrink)];
        [imageView setImage: [UIImage imageNamed:[guidePictures objectAtIndex:i]]];
        [scrollView addSubview:imageView];
        if (i<[guidePictures count]-1) {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(width*i+270, 35, 25, 25);
            [btn setImage:[UIImage imageNamed:@"guideviewdelete.png"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(userGuideFinishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
        }
    }
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(width*([guidePictures count]-1)+100, 300, 120, 40);
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitle:@"Start" forState:UIControlStateNormal];
    [btn setTitle:@"GO!" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(userGuideFinishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:btn];
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    [self.view addSubview:pageControl];
}

-(void)scrollViewDidScroll:(UIScrollView *)scroll
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}


- (void)userGuideFinishButtonPressed
{
    [self hideGuide];
}

- (CGRect)onscreenFrame
{
    return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
  	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;  
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

- (void)guideShown
{
    animating = NO;
}

- (void)guideHidden
{
	animating = NO;
	[[[WUUserGuideViewController sharedGuide] view] removeFromSuperview];
}

- (void)showGuide
{
	if (!animating && self.view.superview == nil)
	{
		[WUUserGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[WUUserGuideViewController sharedGuide].view];
		
		animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[WUUserGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
    
}

- (void)hideGuide
{
	if (!animating && self.view.superview != nil)
	{
		animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[WUUserGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

+ (void)show
{
    [[WUUserGuideViewController sharedGuide].scrollView setContentOffset:CGPointMake(0.f, 0.f)];
    [[WUUserGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
    [[WUUserGuideViewController sharedGuide] hideGuide];
}

+ (WUUserGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WUUserGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
            sharedGuide = [[self alloc] init];
        return sharedGuide;
    }
}


@end
