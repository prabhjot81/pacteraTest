//
//  FactOperation.m
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import "FactOperation.h"

@implementation FactOperation

static NSString* const kURL = @"https://dl.dropboxusercontent.com/u/746330/facts.json";

dispatch_queue_t myBackgroundOperationQueue;

+ (void)getFactListOperationCompletion:(void (^)(id))completionHandler errorHandler:(OperationErrorHandler)errorHandler {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kURL]];
    myBackgroundOperationQueue = dispatch_queue_create("com.pactera.factlist", NULL);
    
    NSOperationQueue *mainQueue = [[NSOperationQueue alloc] init];
    [mainQueue setMaxConcurrentOperationCount:1];
    
    dispatch_async(myBackgroundOperationQueue, ^(void) {
        [NSURLConnection sendAsynchronousRequest:request queue:mainQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
            if (!error) {
                NSString *serverResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
                NSString *jsonString = [serverResponse stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSData *formattedJSON = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSError* error;
                NSDictionary *responseJSONDictionary = [NSJSONSerialization JSONObjectWithData:formattedJSON options:NSJSONReadingAllowFragments error:&error];

                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(responseJSONDictionary);
                });
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorHandler(error);
                });
            }
        }];
    });
    
}

@end
