//
//  CommonUserDefaults.m
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "CommonUserDefaults.h"
@interface CommonUserDefaults()
-(CommonUserDefaults*)init;
@end

@implementation CommonUserDefaults
@synthesize flagNotFirstLaunch=_flagNotFirstLaunch;
@synthesize level=_level;

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
    _flagNotFirstLaunch = [prefs boolForKey:@"flagNotFirstLaunch"];
    /*if(!_flagNotFirstLaunch)
    {
        NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaultPrefs" ofType:@"plist"];
        NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    }*/
    return _flagNotFirstLaunch;
}

- (void)setFlagNotFirstLaunch: (BOOL)newValue {
    _flagNotFirstLaunch=newValue;
    [prefs setBool:_flagNotFirstLaunch forKey:@"flagNotFirstLaunch"];
    //very important at this time to  synchronize
    [prefs synchronize];
}


- (int)level {
    _flagNotFirstLaunch = [prefs integerForKey:@"level"];
    return _flagNotFirstLaunch;
}

- (void)setLevel: (int)newValue {
    _level=newValue;
    [prefs setInteger:_level forKey:@"level"];
    //very important at this time to  synchronize
    [prefs synchronize];
}




@end
