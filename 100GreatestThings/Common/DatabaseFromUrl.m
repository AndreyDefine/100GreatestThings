//
//  DatabaseFromUrl.m
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//
#import "DatabaseFromUrl.h"
#import "Things_list.h"
#import "NSString+Hash.h"
#import "LoadSaveImageFromUrl.h"
#import "EmbriaRequest.h"
#import "CommonUserDefaults.h"

@interface DatabaseFromUrl()
-(DatabaseFromUrl*)init;
- (void) LoadDataFromJSONList:(id)response;
- (void) LoadDataFromJSONTask:(id)response  curlist:(Things_list*)things_list;
- (void) SaveImageToDisk:(NSString*)value;
@end

@implementation DatabaseFromUrl

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//singleton не защищённый

static DatabaseFromUrl *sDatabaseFromUrl = nil;
static NSString* dataBaseName=@"MainDataBase.sqlite";
static NSString* momdDataBaseName=@"MainDataBase";

+ (DatabaseFromUrl *) getSharedInstance
{
    @synchronized(self)
    {
        if (sDatabaseFromUrl == nil)
        {
            sDatabaseFromUrl = [[DatabaseFromUrl alloc] init];
        }
    }
    return sDatabaseFromUrl;
}

-(DatabaseFromUrl*)init;
{
    self=[super init];
    if(self)
    {
    }
    
    return self;
}


#pragma mark - LoadSaveData from url
- (void) LoadDataFromURL:(void (^)(void))responseBlock
{
    //необходимо грузить всё с сервера
    EmbriaRequest* embriaRequest=[[EmbriaRequest alloc] init];
    embriaRequest.makeAsync=true;
    
    embriaRequest.responseblock=^(EmbriaRequest* request,id response) {
        [self LoadDataFromJSONList:response];
        responseBlock();
    };
    embriaRequest.useURLConnection=true;
    [embriaRequest makeRequest:@"http://hgt.phereo.com/api/lists"];
}

- (void) SaveImageToDisk:(id)value
{
    if (value == nil||value == [NSNull null]){
        return;
    }
    
    NSString* imgname=value;
    LoadSaveImageFromUrl *loadSaveImageFromUrl=[[LoadSaveImageFromUrl alloc]init];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //Get Image From URL
    UIImage * imageFromURL = [loadSaveImageFromUrl getImageFromURL:imgname];
    
    NSString*extension=[imgname pathExtension];
    imgname=[NSString stringWithFormat: @"%@.%@",[imgname md5],extension];
    //Save Image to Directory
    [loadSaveImageFromUrl saveImage:imageFromURL withFileName:imgname inDirectory:documentsDirectoryPath];
}

- (void) LoadDataFromJSONTask:(id)response  curlist:(Things_list*)things_list
{
    if(!response)
        return;
    //NSLog(@"%@",response);
    NSArray *jsonArray=(NSArray *)response;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Things_task *things_task;
    
    for(int i=0;i<jsonArray.count;i++)
    {
        //проверить содержится ли объект в базе
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Things_task" inManagedObjectContext:context];
        [request setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id == %@", [jsonArray[i] objectForKey:@"id"]];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        //объект есть в базе
        if(result.count>0)
        {
            things_task=result[0];
        }
        else
        {

            things_task = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Things_task"
                       inManagedObjectContext:context];
        }
        
        NSMutableSet* set=[[NSMutableSet alloc]initWithSet:things_list.to_Things_task];
        [set addObject:things_task];
        
        things_list.to_Things_task=set;
        
        [self safeSetValuesForKeysWithDictionary:jsonArray[i] object:things_task];
        
        [self SaveImageToDisk:[jsonArray[i] objectForKey:@"image_url"]];
        NSLog(@"%@",[jsonArray[i] objectForKey:@"image_url"]);
    }

}


-(void) LoadDataFromJSONList:(id)response
{
    if(!response)
        return;
    
    NSArray *jsonArray=(NSArray *)response;
    NSManagedObjectContext *context = [self managedObjectContext];
    Things_list *things_list;
    EmbriaRequest* embriaRequest;
    for(int i=0;i<jsonArray.count;i++)
    {
        things_list = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Things_list"
                       inManagedObjectContext:context];
        
        
        [self safeSetValuesForKeysWithDictionary:jsonArray[i] object:things_list];
        
        //необходимо выкачать все таски
        NSLog(@"%@",[jsonArray[i] objectForKey:@"tasks_url"]);
        
        id value = [jsonArray[i] objectForKey:@"tasks_url"];
        if (value&&value != [NSNull null]){
            embriaRequest=[[EmbriaRequest alloc] init];
            embriaRequest.makeAsync=false;
            
            embriaRequest.responseblock=^(EmbriaRequest* request,id response) {
                [self LoadDataFromJSONTask:response curlist:things_list];
            };
            embriaRequest.useURLConnection=true;
            [embriaRequest makeRequest:value];
        }
        
        //load images
        [self SaveImageToDisk:[jsonArray[i] objectForKey:@"image_url"]];
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"All saved to database.");
    }
}

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues object:(id)inobject
{
    NSDictionary * attributes=[[inobject entity] attributesByName];
    NSString *nameInKeyedValues;
    for (NSString *attribute in attributes) {
        
        nameInKeyedValues=attribute;
        if([nameInKeyedValues isEqualToString:@"_description"])
        {
            nameInKeyedValues=@"description";
        }
        
        id value = [keyedValues objectForKey:nameInKeyedValues];
        if (value == nil){
            // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
            continue;
        }
        
        if(value == [NSNull null])
        {
            value=nil;
        }
        
        
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value  integerValue]];
        } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        }
        
        if([attribute isEqualToString:@"image_url"])
        {
            NSString*extension=[value pathExtension];
            id value_disk_image=[NSString stringWithFormat: @"%@.%@",[value md5],extension];
            [inobject setValue:value_disk_image forKey:@"disk_image_url"];
        }
        //запишем данные в базу
        [inobject setValue:value forKey:attribute];
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:momdDataBaseName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    //no preload
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dataBaseName];
    
    /*if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
     NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CoreDataTutorial2" ofType:@"sqlite"]];
     
     NSError* err = nil;
     
     if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
     NSLog(@"Oops, could copy preloaded data");
     }
     }*/
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
