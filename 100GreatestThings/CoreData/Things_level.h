//
//  Things_level.h
//  100GreatestThings
//
//  Created by baskakov on 05/12/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Things_level : NSManagedObject

@property (nonatomic, retain) NSNumber * exp;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * max_energy;

@end
