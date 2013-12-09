//
//  ListTableViewController.h
//  100GreatestThings
//
//  Created by Nick on 7/25/12.
//  Copyright (c) 2012 Phereo.com. All rights reserved.
//

/** Вывод таблицы списков, работает с CoreData по стандартной схеме.
 TableView dataSource и delegate
 */

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ListTableViewController : UITableViewController  <NSFetchedResultsControllerDelegate>
{
}

//CoreData common
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

//Перезагрузить данные таблицы
- (void)reloadData;

@end
