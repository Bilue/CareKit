//
//  CustomHeaderView.h
//  CareKit
//
//  Created by Damian Dara on 15/1/19.
//  Copyright © 2019 carekit.org. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomHeaderView : UIView

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) UIColor *tintColor;

@end


NS_ASSUME_NONNULL_END
