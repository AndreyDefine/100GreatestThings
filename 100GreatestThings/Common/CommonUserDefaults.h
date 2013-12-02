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

@property (nonatomic) BOOL flagNotFirstLaunch;

@end
