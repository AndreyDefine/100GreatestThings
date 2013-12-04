//
//  CommonUserDefaults.m
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "CommonUserDefaults.h"
#import "DatabaseFromUrl.h"
@interface CommonUserDefaults()
-(CommonUserDefaults*)init;
@end

@implementation CommonUserDefaults
@synthesize flagNotFirstLaunch;
@synthesize level;
@synthesize expa;
@synthesize maxenergy;
@synthesize energyrange;
@synthesize lastlaunchdate;
//from server
@synthesize energy_growth_rate;
@synthesize facebook_login_energy_reward;
@synthesize facebook_login_exp_reward;
@synthesize twitter_login_energy_reward;
@synthesize twitter_login_exp_reward;

//singleton не защищённый

static CommonUserDefaults *sCommonUserDefaults = nil;

+ (CommonUserDefaults *) getSharedInstance
{
    @synchronized(self)
    {
        if (sCommonUserDefaults == nil)
        {
            sCommonUserDefaults = [[CommonUserDefaults alloc] init];
        }
    }
    return sCommonUserDefaults;
}

-(CommonUserDefaults*)init;
{
    self=[super init];
    if(self)
    {
        prefs=[NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (BOOL)flagNotFirstLaunch {
    flagNotFirstLaunch = [prefs boolForKey:@"flagNotFirstLaunch"];
    return flagNotFirstLaunch;
}

- (void)setFlagNotFirstLaunch: (BOOL)newValue {
    flagNotFirstLaunch=newValue;
    [prefs setBool:newValue forKey:@"flagNotFirstLaunch"];
    //very important at this time to  synchronize
    [prefs synchronize];
}


- (int)level {
    level = [prefs integerForKey:@"level"];
    return level;
}

- (void)setLevel: (int)newValue {
    level=newValue;
    [prefs setInteger:newValue forKey:@"level"];
}

- (int)expa {
    expa = [prefs integerForKey:@"expa"];
    return expa;
}

- (void)setExpa: (int)newValue {
    expa=newValue;
    //проверим может левел ап проверим сколько нужно для следующего уровня
    int neededexpa=[[DatabaseFromUrl getSharedInstance] getExpaForLevel:level+1];
    while(neededexpa>0&&expa>=neededexpa)
    {
        //level up
        self.level++;
        self.maxenergy=[[DatabaseFromUrl getSharedInstance] getEnergyForLevel:level];
        neededexpa=[[DatabaseFromUrl getSharedInstance] getExpaForLevel:level+1];
    }
    [prefs setInteger:newValue forKey:@"expa"];
}

- (float)maxenergy {
    maxenergy = [prefs floatForKey:@"maxenergy"];
    return maxenergy;
}

- (void)setMaxenergy: (float)newValue {
    maxenergy=newValue;
    [prefs setFloat:newValue forKey:@"maxenergy"];
}

- (float)energyrange {
    if(energyrange>self.maxenergy)
    {
        energyrange=maxenergy;
    }
    energyrange = [prefs floatForKey:@"energyrange"];
    return energyrange;
}

- (void)setEnergyrange: (float)newValue {
    if(newValue>maxenergy)
    {
        newValue=maxenergy;
    }
    energyrange=newValue;
    [prefs setFloat:newValue forKey:@"energyrange"];
    
}

- (NSDate*)lastlaunchdate {
    lastlaunchdate = [prefs objectForKey:@"lastlaunchdate"];
    return lastlaunchdate;
}

- (void)setLastlaunchdate: (NSDate*)newValue {
    lastlaunchdate=newValue;
    [prefs setObject:newValue forKey:@"lastlaunchdate"];
    
}

- (float)energy_growth_rate {
    energy_growth_rate = [prefs floatForKey:@"energy_growth_rate"];
    return energy_growth_rate;
}

- (void)setEnergy_growth_rate: (float)newValue {
    energy_growth_rate=newValue;
    [prefs setFloat:newValue forKey:@"energy_growth_rate"];
    
}

- (int)facebook_login_energy_reward {
    facebook_login_energy_reward = [prefs integerForKey:@"facebook_login_energy_reward"];
    return facebook_login_energy_reward;
}

- (void)setFacebook_login_energy_reward: (int)newValue {
    facebook_login_energy_reward=newValue;
    [prefs setInteger:newValue forKey:@"facebook_login_energy_reward"];
}

- (int)facebook_login_exp_reward {
    facebook_login_exp_reward = [prefs integerForKey:@"facebook_login_exp_reward"];
    return facebook_login_exp_reward;
}

- (void)setFacebook_login_exp_reward: (int)newValue {
    facebook_login_exp_reward=newValue;
    [prefs setInteger:newValue forKey:@"facebook_login_exp_reward"];
}

- (int)twitter_login_energy_reward {
    twitter_login_energy_reward = [prefs integerForKey:@"twitter_login_energy_reward"];
    return twitter_login_energy_reward;
}

- (void)setTwitter_login_energy_reward: (int)newValue {
    twitter_login_energy_reward=newValue;
    [prefs setInteger:newValue forKey:@"twitter_login_energy_reward"];
}

- (int)twitter_login_exp_reward {
    twitter_login_exp_reward = [prefs integerForKey:@"twitter_login_exp_reward"];
    return twitter_login_exp_reward;
}

- (void)setTwitter_login_exp_reward: (int)newValue {
    twitter_login_exp_reward=newValue;
    [prefs setInteger:newValue forKey:@"twitter_login_exp_reward"];
}

-(void)saveDefaults
{
    [prefs synchronize];
}


@end
