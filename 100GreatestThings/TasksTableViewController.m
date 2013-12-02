//
//  TasksTableViewController.m
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "TasksTableViewController.h"
#import "DatabaseFromUrl.h"
#import "Things_task.h"
#import "Things_list.h"
#import "TaskCell.h"
#import "CustomCell.h"
#import "LoadSaveImageFromUrl.h"
#import "ListButton.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TasksTableViewController ()
-(void)connectToDataBase;

@end

@implementation TasksTableViewController
@synthesize things_list;
@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)connectToDataBase
{
    self.managedObjectContext = [DatabaseFromUrl getSharedInstance].managedObjectContext;
    
    /*NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self connectToDataBase];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self configureCellTop:(CustomCell*)self.headerCell atIndexPath:nil];
    self.tableView.tableHeaderView=self.headerCell;
}


#pragma mark - Table view data source


/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self configureCellTop:(CustomCell*)self.headerCell atIndexPath:nil];
    return self.headerCell;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    //return [sectionInfo numberOfObjects];
    
    return things_list.to_Things_task.count;
}

- (void)configureCellTop:(CustomCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.navigationController=self.navigationController;
    cell.storyboard=self.storyboard;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Clearing out cell background
    
    ((ListButton*)cell.buttonView1).parentCell=cell;
    
    cell.labelListName.text=self.things_list.title;
    
    UIImage *img = [[UIImage imageNamed:@"shadow.png"]
                    resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 44, 14)];
    UIImageView* imageViewShadow = [[UIImageView alloc] initWithImage:img];
    
    CGRect rect=CGRectMake(cell.roundRectView.frame.origin.x-1, cell.roundRectView.frame.origin.y, cell.roundRectView.frame.size.width+2, cell.roundRectView.frame.size.height+37);
    imageViewShadow.frame=rect;
    
    [cell.viewBack1 addSubview:imageViewShadow];
    [cell.viewBack1 sendSubviewToBack:imageViewShadow];
    
    //add image to first button
    NSString*imgname=self.things_list.disk_image_url;
    LoadSaveImageFromUrl *loadSaveImageFromUrl=[[LoadSaveImageFromUrl alloc]init];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    UIImage *image=[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imgname];
    if(!image)
    {
        image = [loadSaveImageFromUrl loadImage:imgname inDirectory:documentsDirectoryPath];
    }
    if (image){
        [[SDImageCache sharedImageCache] storeImage:image forKey:imgname];
        [cell.imageView1 setImage:image];
    }
}

- (void)configureCell:(TaskCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Things_task *tasks_list;// = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    NSArray *myArray = [things_list.to_Things_task allObjects];
    
    tasks_list=[myArray objectAtIndex:indexPath.row];
    
    
    cell.titleView1.text=tasks_list.title;
    cell.rowNumber.text=[[NSNumber numberWithInteger:indexPath.row+1] stringValue];
    
    //image
    LoadSaveImageFromUrl *loadSaveImageFromUrl=[[LoadSaveImageFromUrl alloc]init];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*imgname=tasks_list.disk_image_url;
    UIImage *image=[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imgname];
    if(!image)
    {
        image = [loadSaveImageFromUrl loadImage:imgname inDirectory:documentsDirectoryPath];
    }
    if (image){
        [[SDImageCache sharedImageCache] storeImage:image forKey:imgname];
        
        [cell.imageView1 setImage:image];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"Cell";
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:(TaskCell*)cell atIndexPath:indexPath];
    
    return cell;
}

-(void)didReceiveMemoryWarning {
}



//Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Things_task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"to_Things_list ==", things_list.to_Things_task];
    //[fetchRequest setPredicate:pred];

    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    //[fetchRequest setFetchBatchSize:100];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(TaskCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}



@end
