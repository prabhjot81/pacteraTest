//
//  FactTableViewCell.h
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fact.h"

@interface FactTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier fact:(Fact *) fact;
- (void) configureCell: (Fact *) inFact;

@end
