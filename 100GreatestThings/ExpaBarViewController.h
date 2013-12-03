//
//  ExpaBarViewController.h
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProgressBar.h"

@interface ExpaBarViewController : UIViewController
{
    NSTimer *aTimer;
}

@property (strong, nonatomic) CustomProgressBar* expabar;

+(ExpaBarViewController*)getSharedInstance;
-(IBAction)getMoreMoney:(id)sender;

-(void)addexpa:(float)inexpa;

@end
