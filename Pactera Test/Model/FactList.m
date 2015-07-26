//
//  FactList.m
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import "FactList.h"
#import "Fact.h"

static NSString* const kTitle = @"title";
static NSString* const kFacts = @"rows";

@implementation FactList

-(FactList *)initWithJSONData:(NSDictionary*)inDict
{
    self = [self init];
    
    NSAssert(self != nil, @"Unable to initialize User");
    
    if (self)
    {
        _title = [inDict objectForKey:kTitle];
        _facts  = [Fact arrayFromJSONArray:[inDict objectForKey:kFacts]];
    }
    
    return self;
}

@end
