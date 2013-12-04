//
//  EnergyBarViewController.h
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProgressBar.h"

@interface EnergyBarViewController : UIViewController
{
    NSTimer *aTimer;
}

@property (strong, nonatomic) CustomProgressBar* energybar;

+(EnergyBarViewController*)getSharedInstance;
-(IBAction)getMoreMoney:(id)sender;

-(void)addenergy:(float)inenergy;
-(void)setmaxenergy:(float)inenergy;

@end
