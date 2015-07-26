//
//  Fact.m
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import "Fact.h"

static NSString* const kTitle = @"title";
static NSString* const kDescription = @"description";
static NSString* const kImage = @"imageHref";

@implementation Fact

+ (NSArray *) arrayFromJSONArray:(NSArray*)inArrayOfJSONObjects
{
    if ([inArrayOfJSONObjects class] == [NSNull class])
        inArrayOfJSONObjects = nil;
    
    NSMutableArray * resultArray = [NSMutableArray array];
    
    for (NSDictionary * jsonObject in inArrayOfJSONObjects)
    {
        Fact * fact = [[self alloc] initWithJSONData:jsonObject];
        if (fact)
        {
            [resultArray addObject:fact];
        }
    }
    
    return resultArray;
}

-(Fact *)initWithJSONData:(NSDictionary*)inDict
{
    self = [self init];
    
    NSAssert(self != nil, @"Unable to initialize User");
    
    if (self)
    {
        _title  = [inDict objectForKey:kTitle] != [NSNull null] ?[inDict objectForKey:kTitle]:NSLocalizedString(@"No title available", nil);
        _detail = [inDict objectForKey:kDescription] != [NSNull null]?[inDict objectForKey:kDescription]:NSLocalizedString(@"No detail available", nil);
        _image  = [inDict objectForKey:kImage] != [NSNull null]?[inDict objectForKey:kImage]:@"";
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Title: %@; Detail: %@, Image: %@", _title, _detail, _image];
}

@end
