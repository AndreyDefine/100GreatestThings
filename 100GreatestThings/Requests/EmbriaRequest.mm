//
//  EmbriaRequest.m
//  HTTP_Embria
//
//  Created by baskakov on 25/11/13.
//  Copyright (c) 2013 baskakov. All rights reserved.
//

#import "EmbriaRequest.h"
@interface EmbriaRequest()
-(void)makeResponse:(NSData*)indata;
@end

@implementation EmbriaRequest

@synthesize responseblock;
@synthesize makeAsync;
@synthesize useURLConnection;

@synthesize delegate;

- (void)makeRequest:(NSString*)inHttp
{
    //установлен ли делегат? если нет, то и запрос выполнять нет смысла
    if ((self.delegate&&[self.delegate respondsToSelector:@selector(EmbriaRequest:response:)])||responseblock)
    {
        NSURL *url=[NSURL URLWithString: inHttp];
    
        if(useURLConnection)
        {
            [self downloadJSONNSURLConnection:url];
        }
        else
        {
            //простой запрос без поддержки параметров
            [self downloadJSONdataWithContentsOfURL:url];
        }
    }
    else
    {
        NSLog(@"EmbriaRequest: No delegate!!!");
        return;
    }
    
}

-(void)downloadJSONdataWithContentsOfURL:(NSURL *)url {
    if(makeAsync)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* data = [NSData dataWithContentsOfURL: url];
            [self makeResponse:data];
        });
    }
    else
    {
        NSData* data = [NSData dataWithContentsOfURL: url];
        [self makeResponse:data];
    }

}

-(void)makeResponse:(NSData*)indata
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:indata //1
                                                         options:kNilOptions
                                                           error:&error];
    if(delegate)
    {
        [self.delegate EmbriaRequest:self response:json];
    }
    
    if(responseblock)
    {
        responseblock(self,json);
    }
}

-(void)downloadJSONNSURLConnection:(NSURL *)url {
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    if(makeAsync)
    {
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [urlConnection start];
    }
    else
    {
        NSURLResponse* response;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        [self makeResponse:data];
    }
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self makeResponse:urlData];
}

@end
