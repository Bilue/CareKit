//
//  CustomHeaderView.m
//  CareKit
//
//  Created by Damian Dara on 15/1/19.
//  Copyright © 2019 carekit.org. All rights reserved.
//

#import "OCKLabel.h"
#import "CustomHeaderView.h"

@implementation CustomHeaderView {
    OCKLabel *_titleLabel;
    OCKLabel *_dateLabel;
    UIView *_separatorView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setDate:(NSString *)date {
    _date = date;
    _dateLabel.text = date;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    _dateLabel.textColor = tintColor;
}

- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];

    _titleLabel = [OCKLabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont systemFontOfSize:26.0 weight:UIFontWeightBold];
    [self addSubview:_titleLabel];

    _dateLabel = [OCKLabel new];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.textColor = self.tintColor;
    _dateLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_dateLabel];

    _separatorView = [UIView new];
    _separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _separatorView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_separatorView];
}

- (void)initConstraints {
    NSMutableArray *constraints = [NSMutableArray arrayWithArray:@[
                                                                   // Title label
                                                                   [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0],
                                                                   [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:50],
                                                                   [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8],
                                                                   [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0],

                                                                   // Date label
                                                                   [NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:7],
                                                                   [NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-20],
                                                                   [NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
                                                                   [NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0],

                                                                   // Separator view
                                                                   [NSLayoutConstraint constraintWithItem:_separatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
                                                                   [NSLayoutConstraint constraintWithItem:_separatorView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0],
                                                                   [NSLayoutConstraint constraintWithItem:_separatorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0],
                                                                   [NSLayoutConstraint constraintWithItem:_separatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]
                                                                   ]];
    [NSLayoutConstraint activateConstraints:constraints];
}

@end
