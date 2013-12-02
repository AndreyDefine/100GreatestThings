//
//  LoadSaveImageFromUrl.h
//  100GreatestThings
//
//  Created by baskakov on 27/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadSaveImageFromUrl : NSObject


-(UIImage *) getImageFromURL:(NSString *)fileURL;
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName inDirectory:(NSString *)directoryPath;
-(UIImage *) loadImage:(NSString *)fileName inDirectory:(NSString *)directoryPath;

@end
