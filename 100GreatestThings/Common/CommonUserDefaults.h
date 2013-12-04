//
//  CommonUserDefaults.h
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUserDefaults : NSObject
{
    NSUserDefaults *prefs;
}

+ (CommonUserDefaults *) getSharedInstance;
-(void)saveDefaults;

@property (nonatomic) BOOL flagNotFirstLaunch;
@property (nonatomic) int level;
@property (nonatomic) int expa;
@property (nonatomic) float maxenergy;
@property (nonatomic) float energyrange;
@property (nonatomic,strong) NSDate* lastlaunchdate;
//from server
@property (nonatomic)float energy_growth_rate;
@property (nonatomic)int facebook_login_energy_reward;
@property (nonatomic)int facebook_login_exp_reward;
@property (nonatomic)int twitter_login_energy_reward;
@property (nonatomic)int twitter_login_exp_reward;

@end
