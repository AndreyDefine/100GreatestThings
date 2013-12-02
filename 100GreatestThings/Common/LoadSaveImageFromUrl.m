//
//  LoadSaveImageFromUrl.m
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "LoadSaveImageFromUrl.h"

@implementation LoadSaveImageFromUrl

//Get Image From URL
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
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
