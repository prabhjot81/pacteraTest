//
//  FactTableViewCell.m
//  Pactera Test
//
//  Created by Prabhjot Singh on 26/07/2015.
//  Copyright (c) 2015 Pactera. All rights reserved.
//

#import "FactTableViewCell.h"
#import "AppDelegate.h"

@interface FactTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

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
    
    [self layoutIfNeeded];
    
    CGFloat y = CGRectGetMaxY(self.detailLabel.frame);
    
    if (y < 60) { // Default case: cell height should be equivant to image height
        y = 60;
    }
    self.height = y + 10;
}

- (void)setHeight:(CGFloat)newHeight
{
    CGRect frameRect = [self.contentView frame];
    frameRect.size.height = newHeight;
    [self.contentView setFrame:frameRect];
}

- (void) updateCellConstraintsForFact:(Fact *) inFact {
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
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
        self.factImageWidthConstraint = [NSLayoutConstraint constraintWithItem:_factImage
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:60];
        [self.contentView addConstraint:self.factImageWidthConstraint];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_factImage
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:60]];
    } else {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTrailingMargin
                                                                    multiplier:1
                                                                      constant:0]];
    }
    [self layoutIfNeeded];
}

@end
