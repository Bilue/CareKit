//
//  CustomSegmentedControlSection.h
//  CareKit
//
//  Created by Damian Dara on 14/1/19.
//  Copyright © 2019 carekit.org. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomSegmentedControlSection : UITableViewHeaderFooterView

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
