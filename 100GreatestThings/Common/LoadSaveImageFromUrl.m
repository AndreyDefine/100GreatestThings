//
//  LoadSaveImageFromUrl.m
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 Phereo.com. All rights reserved.
//

#import "LoadSaveImageFromUrl.h"
#import "NSString+Hash.h"

@interface LoadSaveImageFromUrl()
//загрузить и сохранить картинку, для заданного адреса
- (UIImage*) LoadAndSave:(NSString *)fileURL;
@end

@implementation LoadSaveImageFromUrl

//Get Image From URL
-(UIImage *) getImageFromURL:(NSString *)fileURL async:(BOOL)asynchronous{
    UIImage * result;
    if(asynchronous)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self LoadAndSave:fileURL];
        });

    }
    else
    {
        result=[self LoadAndSave:fileURL];
    }
    
    return result;
}

//load and save image
- (UIImage*) LoadAndSave:(NSString *)fileURL
{
    UIImage * result;
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    NSString*extension=[fileURL pathExtension];
    fileURL=[NSString stringWithFormat: @"%@.%@",[fileURL md5],extension];
    //Save Image to Directory
    [self saveImage:result withFileName:fileURL inDirectory:documentsDirectoryPath];
    return result;
}

//Save Image
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName inDirectory:(NSString *)directoryPath {
    
    NSString*extension=[imageName pathExtension];
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

//Load Image
-(UIImage *) loadImage:(NSString *)fileName inDirectory:(NSString *)directoryPath {
    
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", directoryPath, fileName]];
    
    return result;
}

@end
