//
//  FactTableViewCell.m
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import "FactTableViewCell.h"
#import "AppDelegate.h"

dispatch_queue_t myBackgroundQueue;

@interface FactTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *factImage;

@end

@implementation FactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier fact:(Fact *) fact {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLabel setTextColor:[UIColor blueColor]];
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] init];
        [_detailLabel setTextColor:[UIColor blackColor]];
        [_detailLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_detailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_detailLabel setNumberOfLines:0];
        [self.contentView addSubview:_detailLabel];
        
        if (fact.image.length > 0) {
            _factImage = [[UIImageView alloc] init];
            _factImage.contentMode = UIViewContentModeScaleAspectFit;
            [_factImage setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_factImage setImage:[UIImage imageNamed:@"default-placeholder"]];
            [self.contentView addSubview:_factImage];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self updateCellConstraintsForFact:fact];
    }
    
    return self;
}

- (void) configureCell: (Fact *) inFact {
    self.titleLabel.text = inFact.title;
    self.detailLabel.text = inFact.detail;

    if (inFact.image.length > 0) {
        
        // set default user image while image is being downloaded
        self.factImage.image = [UIImage imageNamed:@"default-placeholder"];
        
        // download the image asynchronously
        myBackgroundQueue = dispatch_queue_create("com.pactera.photo", NULL);
        dispatch_async(myBackgroundQueue, ^(void) {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:inFact.image]];
            if (imageData) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    self.factImage.image = [UIImage imageWithData:imageData];
                });
            }
        });
    }
}

- (void) updateCellConstraintsForFact:(Fact *) inFact {
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTopMargin
                                                                multiplier:.5
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0]];
    
    if (inFact.image.length > 0) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_factImage
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:-5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_factImage
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_factImage
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTrailingMargin
                                                                    multiplier:1
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_factImage
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:60]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_factImage
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:60]];
        [self.contentView removeConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTrailingMargin
                                                                    multiplier:1
                                                                      constant:0]];
    } else {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTrailingMargin
                                                                    multiplier:1
                                                                      constant:0]];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
