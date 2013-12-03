//
//  Things_task.h
//  100GreatestThings
//
//  Created by baskakov on 03/12/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Things_list;

@interface Things_task : NSManagedObject

@property (nonatomic, retain) NSString * description_;
@property (nonatomic, retain) NSString * disk_image_url;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) id links;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *to_Things_list;
@end

@interface Things_task (CoreDataGeneratedAccessors)

- (void)addTo_Things_listObject:(Things_list *)value;
- (void)removeTo_Things_listObject:(Things_list *)value;
- (void)addTo_Things_list:(NSSet *)values;
- (void)removeTo_Things_list:(NSSet *)values;

@end
