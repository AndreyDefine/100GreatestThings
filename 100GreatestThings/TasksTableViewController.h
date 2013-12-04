//
//  TasksTableViewController.h
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "Things_list.h"

@interface TasksTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Things_list *things_list;


@property (nonatomic, strong) IBOutlet UITableViewCell *headerCell;
- (void)reloadData;

@end
