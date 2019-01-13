//
//  CustomSegmentedControlSection.m
//  CareKit
//
//  Created by Damian Dara on 14/1/19.
//  Copyright © 2019 carekit.org. All rights reserved.
//

#import "OCKLabel.h"
#import "CustomSegmentedControlSection.h"

@implementation CustomSegmentedControlSection {
    OCKLabel *_titleLabel;
    OCKLabel *_subtitleLabel;
    UISegmentedControl *_segmentedControl;
    NSMutableArray<NSLayoutConstraint *> *_constraints;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = backgroundView;

    _titleLabel = [OCKLabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];

    _subtitleLabel = [OCKLabel new];
    _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _subtitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _subtitleLabel.numberOfLines = 0;
    [self.contentView addSubview:_subtitleLabel];

    _segmentedControl = [[UISegmentedControl alloc] initWithItems: @[ @"My Health", @"My Symptoms" ]];
    _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    _segmentedControl.selectedSegmentIndex = 0;
    [self.contentView addSubview:_segmentedControl];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = _subtitle;
}

- (void)initConstraints {
    _constraints = [NSMutableArray arrayWithArray: @[
                                                     // Title Label
                                                     [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1.0
                                                                                   constant:25.0],
                                                     [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1.0
                                                                                   constant:20.0],
                                                     [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                 multiplier:1.0
                                                                                   constant:-15.0],
                                                     // Subtitle Label
                                                     [NSLayoutConstraint constraintWithItem: _subtitleLabel
                                                                                  attribute: NSLayoutAttributeTop
                                                                                  relatedBy: NSLayoutRelationEqual
                                                                                     toItem: _titleLabel
                                                                                  attribute: NSLayoutAttributeBottom
                                                                                 multiplier: 1.0
                                                                                   constant: 5.0],
                                                     [NSLayoutConstraint constraintWithItem: _subtitleLabel
                                                                                  attribute: NSLayoutAttributeTrailing
                                                                                  relatedBy: NSLayoutRelationEqual
                                                                                     toItem: _titleLabel
                                                                                  attribute: NSLayoutAttributeTrailing
                                                                                 multiplier: 1.0
                                                                                   constant: 0.0],
                                                     [NSLayoutConstraint constraintWithItem: _subtitleLabel
                                                                                  attribute: NSLayoutAttributeLeading
                                                                                  relatedBy: NSLayoutRelationEqual
                                                                                     toItem: _titleLabel
                                                                                  attribute: NSLayoutAttributeLeading
                                                                                 multiplier: 1.0
                                                                                   constant: 0.0],
                                                     [NSLayoutConstraint constraintWithItem: _subtitleLabel
                                                                                  attribute: NSLayoutAttributeBottom
                                                                                  relatedBy: NSLayoutRelationEqual
                                                                                     toItem: _segmentedControl
                                                                                  attribute: NSLayoutAttributeTop
                                                                                 multiplier: 1.0
                                                                                   constant: -7.0],
                                                     // Segmented control
                                                     [NSLayoutConstraint constraintWithItem:_segmentedControl
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:_titleLabel
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1.0
                                                                                   constant: 0.0],
                                                     [NSLayoutConstraint constraintWithItem:_segmentedControl
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:_titleLabel
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                 multiplier:1.0
                                                                                   constant:0.0],
                                                     [NSLayoutConstraint constraintWithItem: _segmentedControl
                                                                                  attribute: NSLayoutAttributeBottom
                                                                                  relatedBy: NSLayoutRelationEqual
                                                                                     toItem: self.contentView
                                                                                  attribute: NSLayoutAttributeBottom
                                                                                 multiplier: 1.0
                                                                                   constant: -7.0]
                                                     ]
                    ];
    [NSLayoutConstraint activateConstraints:_constraints];
}

@end

