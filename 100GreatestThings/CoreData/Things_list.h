//
//  Things_list.h
//  100GreatestThings
//
//  Created by baskakov on 03/12/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Things_task;

@interface Things_list : NSManagedObject

@property (nonatomic, retain) NSString * badge_url;
@property (nonatomic, retain) NSString * description_;
@property (nonatomic, retain) NSString * disk_image_url;
@property (nonatomic, retain) NSNumber * energy_for_unlock;
@property (nonatomic, retain) NSNumber * exp_reward_for_task;
@property (nonatomic, retain) NSNumber * exp_reward_for_task_delta;
@property (nonatomic, retain) NSNumber * exp_reward_for_unlock;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * network_link_required;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * task_complete_message;
@property (nonatomic, retain) NSString * tasks_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * opened;
@property (nonatomic, retain) NSSet *to_Things_task;
@end

@interface Things_list (CoreDataGeneratedAccessors)

- (void)addTo_Things_taskObject:(Things_task *)value;
- (void)removeTo_Things_taskObject:(Things_task *)value;
- (void)addTo_Things_task:(NSSet *)values;
- (void)removeTo_Things_task:(NSSet *)values;

@end
