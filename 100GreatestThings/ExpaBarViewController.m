//
//  ExpaBarViewController.m
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "ExpaBarViewController.h"

@interface ExpaBarViewController ()

@end

@implementation ExpaBarViewController
static ExpaBarViewController *expaBarViewController = nil;


@synthesize expabar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    float width=CGRectGetWidth(screenBounds);
    float leftmargin=60;
    float topmargin=9;
    self.expabar=[CustomProgressBar addProgressBarInFrame:CGRectMake(leftmargin, topmargin, width-leftmargin*2, 14.f) onView:self.view withRange:629 image1:@"expabar_progressdone" imagebackground:@"expabar_progressnotdone" fullRange:10000];
    //[self.expabar setProgress:800];
    //not best way to make singleton, returns last created bar, otherwise we create it only in interface builder so can't make mistake
    //lazy singleton
    expaBarViewController=self;
}

+(ExpaBarViewController*)getSharedInstance
{
    return expaBarViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
