//
//  ExpaBarViewController.m
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "ExpaBarViewController.h"
#import "MKStoreManager.h"
#import "CommonUserDefaults.h"

@interface ExpaBarViewController ()
-(void)timerFired:(id)sender;

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
-(IBAction)getMoreMoney:(id)sender
{
    [self addexpa:10];
    
    [[MKStoreManager sharedManager] buyFeature:@"purchase1"
                                    onComplete:^(NSString* purchasedFeature,
                                                 NSData* purchasedReceipt,
                                                 NSArray* availableDownloads)
     {
         NSLog(@"Purchased: %@", purchasedFeature);
     }
                                   onCancelled:^
     {
         NSLog(@"User Cancelled Transaction");
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //timer for expa
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timerFired:)
                                            userInfo:nil
                                             repeats:YES];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    float width=CGRectGetWidth(screenBounds);
    float leftmargin=60;
    float topmargin=9;
    self.expabar=[CustomProgressBar addProgressBarInFrame:CGRectMake(leftmargin, topmargin, width-leftmargin*2, 14.f) onView:self.view withRange:[CommonUserDefaults getSharedInstance].energyrange image1:@"expabar_progressdone" imagebackground:@"expabar_progressnotdone" fullRange:[CommonUserDefaults getSharedInstance].maxenergy];
    //[self.expabar setProgress:800];
    //not best way to make singleton, returns last created bar, otherwise we create it only in interface builder so can't make mistake
    //lazy singleton
    expaBarViewController=self;
}

-(void)timerFired:(id)sender
{
    float addexpa;
    NSTimeInterval timeInterval = [[CommonUserDefaults getSharedInstance].lastlaunchdate timeIntervalSinceNow];
    float groughrate=60./[CommonUserDefaults getSharedInstance].energy_growth_rate;
    //0.2 every 60 seconds = 1/300
    addexpa=-timeInterval/groughrate;
    //NSLog(@"%f",addexpa);
    [self addexpa:addexpa];
    [CommonUserDefaults getSharedInstance].lastlaunchdate=[NSDate date];
}


-(void)addexpa:(float)inexpa
{
    [CommonUserDefaults getSharedInstance].energyrange+=inexpa;
    [self.expabar setProgress:[CommonUserDefaults getSharedInstance].energyrange];
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
