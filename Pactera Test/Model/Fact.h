//
//  Fact.h
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Fact : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) NSString * image;
@property (strong, nonatomic) UIImage *userImage;

-(Fact *)initWithJSONData:(NSDictionary*)inDict;
+ (NSArray*) arrayFromJSONArray:(NSArray*)inArrayOfJSONObjects;

@end
