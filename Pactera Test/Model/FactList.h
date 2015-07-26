//
//  FactList.h
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactList : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSArray * facts;

-(FactList *)initWithJSONData:(NSDictionary*)inDict;

@end
