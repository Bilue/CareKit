//
//  CustomSectionView.m
//  CareKit
//
//  Created by Damian Dara on 9/1/19.
//  Copyright © 2019 carekit.org. All rights reserved.
//
#import "OCKLabel.h"
#import "CustomSectionView.h"

@implementation CustomSectionView {
    OCKLabel *_titleLabel;
    OCKLabel *_subtitleLabel;
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
                                                     [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:25.0],
                                                     [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0],
                                                     [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15.0],
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
                                                                                     toItem: self.contentView
                                                                                  attribute: NSLayoutAttributeBottom
                                                                                 multiplier: 1.0
                                                                                   constant: -7.0]
                                                     ]
                    ];
    [NSLayoutConstraint activateConstraints:_constraints];
}

@end
