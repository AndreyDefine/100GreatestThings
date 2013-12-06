//
//  DatabaseFromUrlBridge.m
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//
#import "DatabaseFromUrlBridge.h"
#import "Things_list.h"
#import "Things_level.h"
#import "NSString+Hash.h"
#import "LoadSaveImageFromUrl.h"
#import "EmbriaRequest.h"
#import "CommonUserDefaults.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DatabaseFromUrlBridge()
-(DatabaseFromUrlBridge*)init;
- (void) LoadDataFromJSONList:(id)response;
- (void) LoadDataFromJSONSettings:(id)response;
- (void) LoadDataFromJSONLevels:(id)response;
- (void) LoadDataFromJSONTask:(id)response  curlist:(Things_list*)things_list;
- (void)safeSetValuesForKeysWithDictionaryManagedObject:(NSDictionary *)keyedValues object:(id)inobject;

- (NSManagedObject*) findCreateEntityForName:(NSString*)entityname withPredicate:(NSPredicate*)predicate withSortFieldName:(NSString*)sortfieldname create:(BOOL)needcreation;
@end

@implementation DatabaseFromUrlBridge

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//singleton не защищённый

static DatabaseFromUrlBridge *sDatabaseFromUrlBridge = nil;
static NSString* dataBaseName=@"MainDataBase.sqlite";
static NSString* momdDataBaseName=@"MainDataBase";

+ (DatabaseFromUrlBridge *) getSharedInstance
{
    @synchronized(self)
    {
        if (sDatabaseFromUrlBridge == nil)
        {
            sDatabaseFromUrlBridge = [[DatabaseFromUrlBridge alloc] init];
        }
    }
    return sDatabaseFromUrlBridge;
}

-(DatabaseFromUrlBridge*)init;
{
    self=[super init];
    if(self)
    {
    }
    
    return self;
}

- (NSManagedObject*) findCreateEntityForName:(NSString*)entityname withPredicate:(NSPredicate*)predicate withSortFieldName:(NSString*)sortfieldname create:(BOOL)needcreation
{
    NSManagedObject* managedobject;
    
    //проверить содержится ли объект в базе
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityname inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortfieldname ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    //объект есть в базе
    if(result.count>0)
    {
        managedobject=result[0];
    }
    else
    {
        if(needcreation)
        {
        
            managedobject = [NSEntityDescription insertNewObjectForEntityForName:entityname inManagedObjectContext:self.managedObjectContext];
        }
    }
    return managedobject;
}

-(int)getExpaForLevel:(int)level
{
    Things_level *things_level;
    int exp=0;
    
    //проверить содержится ли объект в базе
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"level == %d", level];
    things_level=(Things_level*)[self findCreateEntityForName:@"Things_level" withPredicate:predicate withSortFieldName:@"level" create:NO];
    
    if(things_level){
        exp=[things_level.exp intValue];
    }
    return exp;
}

-(int)getEnergyForLevel:(int)level
{
    Things_level *things_level;
    int exp=0;
    //проверить содержится ли объект в базе
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"level == %d", level];
    things_level=(Things_level*)[self findCreateEntityForName:@"Things_level" withPredicate:predicate withSortFieldName:@"level" create:NO];
    
    if(things_level){
        exp=[things_level.max_energy intValue];
    }
    return exp;
}

#pragma mark - load settings from url
- (void) GetSettings:(void (^)(NSError*))responseBlock
{
    //необходимо грузить всё с сервера
    EmbriaRequest* embriaRequest=[[EmbriaRequest alloc] init];
    embriaRequest.makeAsync=true;
    
    embriaRequest.responseblock=^(EmbriaRequest* request,id response,NSError* error) {
        [self LoadDataFromJSONSettings:response];
        if(responseBlock)
        {
            responseBlock(error);
        }
    };
    embriaRequest.useURLConnection=true;
    [embriaRequest makeRequest:@"http://hgt.phereo.com/api/settings"];
}

#pragma mark - load levels from url
- (void) GetLevels:(void (^)(NSError*))responseBlock
{
    //необходимо грузить всё с сервера
    EmbriaRequest* embriaRequest=[[EmbriaRequest alloc] init];
    embriaRequest.makeAsync=true;
    
    embriaRequest.responseblock=^(EmbriaRequest* request,id response,NSError* error) {
        [self LoadDataFromJSONLevels:response];
        if(responseBlock)
        {
            responseBlock(error);
        }
    };
    embriaRequest.useURLConnection=true;
    [embriaRequest makeRequest:@"http://hgt.phereo.com/api/levels"];
}

#pragma mark - LoadSaveData from url
- (void) LoadDataFromURL:(void (^)(NSError*))responseBlock
{
    //необходимо грузить всё с сервера
    EmbriaRequest* embriaRequest=[[EmbriaRequest alloc] init];
    embriaRequest.makeAsync=true;
    
    embriaRequest.responseblock=^(EmbriaRequest* request,id response,NSError* error) {
        [self LoadDataFromJSONList:response];
        if(responseBlock)
        {
            responseBlock(error);
        }
    };
    embriaRequest.useURLConnection=true;
    [embriaRequest makeRequest:@"http://hgt.phereo.com/api/lists"];
}

-(void)LoadImage:(NSString*)image_url todisk:(NSString*)disk_image_url toimageview:(UIImageView*)imageview
{
    [imageview setImage:nil];
    LoadSaveImageFromUrl *loadSaveImageFromUrl=[[LoadSaveImageFromUrl alloc]init];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    UIImage *image=[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:disk_image_url];
    if(!image)
    {
        image = [loadSaveImageFromUrl loadImage:disk_image_url inDirectory:documentsDirectoryPath];
    }
    if(!image)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image;
            image=[self SaveImageToDisk:image_url];
            [[SDImageCache sharedImageCache] storeImage:image forKey:disk_image_url];
            
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageview setImage:image];
                });
            }
        });
    }
    if (image){
        [[SDImageCache sharedImageCache] storeImage:image forKey:disk_image_url];
        [imageview setImage:image];
    }
}

- (UIImage*) SaveImageToDisk:(id)value
{
    if (value == nil||value == [NSNull null]){
        return nil;
    }
    
    LoadSaveImageFromUrl *loadSaveImageFromUrl=[[LoadSaveImageFromUrl alloc]init];
    
    //Get Image From URL and save asynchonous
    return [loadSaveImageFromUrl getImageFromURL:value async:false];
}

- (void) LoadDataFromJSONTask:(id)response  curlist:(Things_list*)things_list
{
    if(!response)
        return;
    //NSLog(@"%@",response);
    NSArray *jsonArray=(NSArray *)response;
    
    Things_task *things_task;
    
    for(int i=0;i<jsonArray.count;i++)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id == %@", [jsonArray[i] objectForKey:@"id"]];
        things_task=(Things_task*)[self findCreateEntityForName:@"Things_task" withPredicate:predicate withSortFieldName:@"id" create:YES];
        
        NSMutableSet* set=[[NSMutableSet alloc]initWithSet:things_list.to_Things_task];
        [set addObject:things_task];
        
        things_list.to_Things_task=set;
        
        [self safeSetValuesForKeysWithDictionaryManagedObject:jsonArray[i] object:things_task];
        
        //[self SaveImageToDisk:[jsonArray[i] objectForKey:@"image_url"]];
    }

}

- (void) LoadDataFromJSONSettings:(id)response
{
    if(!response)
        return;
    
    [self safeSetValuesForKeysWithDictionaryUserDefaults:response];
}

- (void)safeSetValuesForKeysWithDictionaryUserDefaults:(NSDictionary *)keyedValues
{
    NSArray *jsonArray=(NSArray *)keyedValues;
    NSString *defaultsName;
    id value;
    CommonUserDefaults* commonuserDefaults=[CommonUserDefaults getSharedInstance];
    
    for (int i=0;i<jsonArray.count;i++)
    {
        defaultsName=[jsonArray[i] objectForKey:@"name"];
        value=[jsonArray[i] objectForKey:@"value"];
        if ([commonuserDefaults respondsToSelector:NSSelectorFromString(defaultsName)]){
            //необходимо установить свойство
            [commonuserDefaults setValue:value forKey:defaultsName];
            //NSLog(@"%@",defaultsName);
        }
        
    }
    [commonuserDefaults saveDefaults];
}

- (void) LoadDataFromJSONLevels:(id)response
{
    if(!response)
        return;
    NSArray *jsonArray=(NSArray *)response;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error = nil;
    Things_level *things_level;
    
    for(int i=0;i<jsonArray.count;i++)
    {
        //проверить содержится ли объект в базе
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"level == %@", [jsonArray[i] objectForKey:@"level"]];
        things_level=(Things_level*)[self findCreateEntityForName:@"Things_level" withPredicate:predicate withSortFieldName:@"level" create:YES];

        [self safeSetValuesForKeysWithDictionaryManagedObject:jsonArray[i] object:things_level];
        
        error = nil;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        else
        {
            //NSLog(@"All saved to database.");
        }

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
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id == %@", [jsonArray[i] objectForKey:@"id"]];
        things_list=(Things_list*)[self findCreateEntityForName:@"Things_list" withPredicate:predicate withSortFieldName:@"id" create:YES];
        
        [self safeSetValuesForKeysWithDictionaryManagedObject:jsonArray[i] object:things_list];
        
        //необходимо выкачать все таски
        id value = [jsonArray[i] objectForKey:@"tasks_url"];
        if (value&&value != [NSNull null]){
            embriaRequest=[[EmbriaRequest alloc] init];
            embriaRequest.makeAsync=false;
            
            embriaRequest.responseblock=^(EmbriaRequest* request,id response,NSError* error) {
                [self LoadDataFromJSONTask:response curlist:things_list];
            };
            embriaRequest.useURLConnection=true;
            [embriaRequest makeRequest:value];
        }
        
        //load images
        //[self SaveImageToDisk:[jsonArray[i] objectForKey:@"image_url"]];
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    else
    {
        //NSLog(@"All saved to database.");
    }
}

- (void)safeSetValuesForKeysWithDictionaryManagedObject:(NSDictionary *)keyedValues object:(id)inobject
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
