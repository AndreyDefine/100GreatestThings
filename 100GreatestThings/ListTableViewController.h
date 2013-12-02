//
//  ListTableViewController.h
//  100GreatestThings
//
//  Created by Nick on 7/25/12.
//  Copyright (c) 2012 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ListTableViewController : UITableViewController  <NSFetchedResultsControllerDelegate>
{
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


@end
