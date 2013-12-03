//
//  ListTableViewController.m
//  100GreatestThings
//
//  Created by Nick on 7/25/12.
//  Copyright (c) 2012 MyCompanyName. All rights reserved.
//

#import "ListTableViewController.h"
#import "CustomCell.h"
#import "AppDelegate.h"
#import "TWTSideMenuViewController.h"
#import "Things_list.h"
#import "MyNavigationControllerViewController.h"
#import "LoadSaveImageFromUrl.h"
#import "ListButton.h"
#import "DatabaseFromUrl.h"
#import "CommonUserDefaults.h"

#import <SDWebImage/UIImageView+WebCache.h>



@interface ListTableViewController ()

-(void)connectToDataBase;

@end

@implementation ListTableViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)connectToDataBase
{
    self.managedObjectContext = [DatabaseFromUrl getSharedInstance].managedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self connectToDataBase];
}



-(void)showMenu:(id)sender
{
    [self.navigationController.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    //return [[self images] count];
}

- (void)configureCell:(CustomCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Things_list *things_list = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.things_list=things_list;
    
    cell.navigationController=self.navigationController;
    cell.storyboard=self.storyboard;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //set cell type
    if([things_list.level integerValue]>[CommonUserDefaults getSharedInstance].level){
        //need level for cell
        cell.customCellType=CustomCellLevel;
    }
    else if(!things_list.opened)
    {
        cell.customCellType=CustomCellExpa;
    }
    else{
        //normal cell
        cell.customCellType=CustomCellOpened;
    }
    
    cell.labelListName.text=things_list.title;
    
    UIImage *img = [[UIImage imageNamed:@"shadow.png"]
                    resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 44, 14)];
    UIImageView* imageViewShadow = [[UIImageView alloc] initWithImage:img];
    
    CGRect rect=CGRectMake(cell.roundRectView.frame.origin.x-1, cell.roundRectView.frame.origin.y, cell.roundRectView.frame.size.width+2, cell.roundRectView.frame.size.height+37);
    imageViewShadow.frame=rect;
    
    [cell.viewBack1 addSubview:imageViewShadow];
    [cell.viewBack1 sendSubviewToBack:imageViewShadow];
    
    //add image to first button
    NSString*imgname=things_list.disk_image_url;
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    [self configureCell:cell atIndexPath:indexPath];
    
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
 

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Things_list" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"level" ascending:YES];
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
            [self configureCell:(CustomCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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