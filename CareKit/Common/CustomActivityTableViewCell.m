//
//  CustomActivityTableViewCell.m
//  CareKit
//
//  Created by Damian Dara on 9/1/19.
//  Copyright © 2019 carekit.org. All rights reserved.
//

#import "OCKLabel.h"
#import "OCKHelpers.h"
#import "CustomActivityTableViewCell.h"

static const CGFloat TopMargin = 5.0;
static const CGFloat BottomMargin = -5.0;
static const CGFloat HorizontalMargin = 5.0;

@implementation CustomActivityTableViewCell {
    OCKLabel *_titleLabel;
    OCKLabel *_valueLabel;
    OCKLabel *_updatedAtLabel;
    UIView *_roundedView;
    NSMutableArray *_constraints;
}

- (void)setEvent:(OCKCarePlanEvent *)event {
    _event = event;
    [self prepareView];
}

- (void)prepareView {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = nil;

    if (!_roundedView) {
        _roundedView = [UIView new];
        _roundedView.layer.cornerRadius = 5.0;
        _roundedView.layer.masksToBounds = YES;
        _roundedView.backgroundColor = _event.activity.tintColor;
        [self.contentView addSubview:_roundedView];
    }

    if (!_titleLabel) {
        _titleLabel = [OCKLabel new];
        _titleLabel.textStyle = UIFontTextStyleHeadline;
        _titleLabel.textColor = [UIColor whiteColor];
        [_roundedView addSubview:_titleLabel];
    }

    if (!_valueLabel) {
        _valueLabel = [OCKLabel new];
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.font = [UIFont systemFontOfSize:49 weight:UIFontWeightRegular];
        _valueLabel.textAlignment = NSLayoutAttributeRight;
        [_roundedView addSubview:_valueLabel];
    }

    if (!_updatedAtLabel) {
        _updatedAtLabel = [OCKLabel new];
        _updatedAtLabel.textColor = [UIColor whiteColor];
        _updatedAtLabel.textStyle = UIFontTextStyleFootnote;
        _updatedAtLabel.textAlignment = NSLayoutAttributeRight;
        [_roundedView addSubview:_updatedAtLabel];
    }

    [self updateView];
    [self setUpConstraints];
}

- (NSAttributedString *)attributedStringFromResult:(OCKCarePlanEventResult *) result {
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentRight;
    NSDictionary *resultStringAttributes = @{ NSParagraphStyleAttributeName: paragraphStyle };
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:@"" attributes: resultStringAttributes];

    NSDictionary *valueStringAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:49 weight:UIFontWeightRegular] };
    NSAttributedString *valueString = [[NSAttributedString alloc] initWithString:result.valueString attributes: valueStringAttributes];
    [resultString appendAttributedString: valueString];

    NSDictionary *unitStringAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:20 weight:UIFontWeightMedium] };
    NSAttributedString *unitString = [[NSAttributedString alloc] initWithString: result.unitString attributes: unitStringAttributes];
    [resultString appendAttributedString:unitString];

    return resultString;
}

- (void)updateView {
    _titleLabel.text = _event.activity.title;

    if (_event.state == OCKCarePlanEventStateCompleted) {
        _valueLabel.attributedText = [self attributedStringFromResult:_event.result];
        NSString *updatedAt = OCKShortStyleTimeStringFromDate(_event.result.creationDate);
        _updatedAtLabel.text = [NSString stringWithFormat:@"Today at %@", updatedAt];
    } else {
        _updatedAtLabel.text = @"NOT COMPLETED";
    }

}

- (void)setUpConstraints {
    [NSLayoutConstraint deactivateConstraints:_constraints];

    _constraints = [NSMutableArray new];

    _roundedView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _updatedAtLabel.translatesAutoresizingMaskIntoConstraints = NO;

    CGFloat LeadingMargin = self.separatorInset.left;
    CGFloat TrailingMargin = (self.separatorInset.right > 0) ? -self.separatorInset.right : -15;

    [_constraints addObjectsFromArray:@[
                                        [NSLayoutConstraint constraintWithItem:_roundedView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:TopMargin],

                                        [NSLayoutConstraint constraintWithItem:_roundedView
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:LeadingMargin],

                                        [NSLayoutConstraint constraintWithItem:_roundedView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:TrailingMargin],

                                        [NSLayoutConstraint constraintWithItem:_roundedView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:-2.5],

                                        [NSLayoutConstraint constraintWithItem:_valueLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_roundedView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:TopMargin],

                                        [NSLayoutConstraint constraintWithItem:_valueLabel
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_roundedView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:-12.0],

                                        [NSLayoutConstraint constraintWithItem:_valueLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_titleLabel
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:HorizontalMargin],

                                        [NSLayoutConstraint constraintWithItem:_valueLabel
                                                                     attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:nil
                                                                     attribute: NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:50.0],

                                        [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_roundedView
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:8.0],

                                        [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_valueLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_updatedAtLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_titleLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_updatedAtLabel
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_valueLabel
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_updatedAtLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_valueLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:HorizontalMargin],

                                        [NSLayoutConstraint constraintWithItem:_updatedAtLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_roundedView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:BottomMargin]
                                        ]];

    [NSLayoutConstraint activateConstraints:_constraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUpConstraints];
}

@end
