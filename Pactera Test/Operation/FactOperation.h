//
//  FactOperation.h
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OperationErrorHandler)(NSError * error);

@interface FactOperation : NSObject

+ (void) getFactListOperationCompletion:(void (^)(id))completionHandler errorHandler:(OperationErrorHandler)errorHandler;

@end
