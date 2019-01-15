//
//  OCKCustomCareCardViewController.m
//  CareKit
//
//  Created by Damian Dara on 15/1/19.
//  Copyright © 2019 carekit.org. All rights reserved.
//

#import "OCKCustomCareCardViewController.h"
#import "OCKWeekView.h"
#import "OCKCareCardDetailViewController.h"
#import "OCKWeekViewController.h"
#import "NSDateComponents+CarePlanInternal.h"
#import "OCKHeaderView.h"
#import "OCKLabel.h"
#import "OCKCareCardTableViewCell.h"
#import "OCKWeekLabelsView.h"
#import "OCKCarePlanStore_Internal.h"
#import "OCKHelpers.h"
#import "OCKDefines_Private.h"
#import "OCKGlyph_Internal.h"
#import "CustomHeaderView.h"


#define RedColor() OCKColorFromRGB(0xEF445B);


@interface OCKCustomCareCardViewController() <OCKCarePlanStoreDelegate, OCKCareCardCellDelegate, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (nonatomic) NSDateComponents *selectedDate;

@end

@implementation OCKCustomCareCardViewController {
    NSMutableArray<NSMutableArray<OCKCarePlanEvent *> *> *_events;
    NSCalendar *_calendar;
    NSMutableArray *_constraints;
    NSMutableArray *_sectionTitles;
    NSMutableArray<NSMutableArray <NSMutableArray <OCKCarePlanEvent *> *> *> *_tableViewData;
    NSString *_otherString;
    NSString *_optionalString;
    BOOL _isGrouped;
    BOOL _isSorted;
    UIRefreshControl *_refreshControl;
    OCKLabel *_noActivitiesLabel;
    CustomHeaderView *_headerView;
}

- (instancetype)init {
    OCKThrowMethodUnavailableException();
    return nil;
}

- (instancetype)initWithCarePlanStore:(OCKCarePlanStore *)store {
    self = [super init];
    if (self) {
        _store = store;
        _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        _isGrouped = NO;
        _isSorted = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _otherString = OCKLocalizedString(@"ACTIVITY_TYPE_OTHER_SECTION_HEADER", nil);
    _optionalString = OCKLocalizedString(@"ACTIVITY_TYPE_OPTIONAL_SECTION_HEADER", nil);

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.store.careCardUIDelegate = self;

    _headerView = [CustomHeaderView new];
    _headerView.title = self.headerTitleText;
    _headerView.date = self.dateTitleText;
    _headerView.tintColor = self.buttonColor;
    [self.view addSubview:_headerView];

    _actionButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_actionButton setTitle:self.actionButtonTitle forState:UIControlStateNormal];
    [_actionButton setBackgroundColor: self.buttonColor];
    [self.view addSubview:_actionButton];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    [self prepareView];

    self.selectedDate = [NSDateComponents ock_componentsWithDate:[NSDate date] calendar:_calendar];

    _tableView.estimatedRowHeight = 90.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;

    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(didActivatePullToRefreshControl:) forControlEvents:UIControlEventValueChanged];
    _tableView.refreshControl = _refreshControl;
    [self updatePullToRefreshControl];

    _noActivitiesLabel = [OCKLabel new];
    _noActivitiesLabel.hidden = YES;
    _noActivitiesLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _noActivitiesLabel.textStyle = UIFontTextStyleTitle2;
    _noActivitiesLabel.textColor = [UIColor lightGrayColor];
    _noActivitiesLabel.text = self.noActivitiesText;
    _noActivitiesLabel.textAlignment = NSTextAlignmentCenter;
    _noActivitiesLabel.numberOfLines = 0;
    _tableView.backgroundView = _noActivitiesLabel;

    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:245.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)showToday:(id)sender {
    self.selectedDate = [NSDateComponents ock_componentsWithDate:[NSDate date] calendar:_calendar];
    if (_tableViewData.count > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)didActivatePullToRefreshControl:(UIRefreshControl *)sender
{
    if (nil == _delegate ||
        ![_delegate respondsToSelector:@selector(careCardViewController:didActivatePullToRefreshControl:)]) {

        return;
    }

    [_delegate careCardViewController:self didActivatePullToRefreshControl:sender];
}

- (void)prepareView {

    _tableView.showsVerticalScrollIndicator = NO;

    [self setUpConstraints];
}

- (void)setUpConstraints {
    [NSLayoutConstraint deactivateConstraints:_constraints];

    _constraints = [NSMutableArray new];

    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    _actionButton.translatesAutoresizingMaskIntoConstraints = NO;

    [_constraints addObjectsFromArray:@[
                                        [NSLayoutConstraint constraintWithItem:_headerView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_headerView
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_headerView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_headerView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:132],

                                        [NSLayoutConstraint constraintWithItem:_tableView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_headerView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_tableView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_actionButton
                                                                     attribute: NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_tableView
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_tableView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        // Button
                                        [_actionButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor],

                                        [NSLayoutConstraint constraintWithItem:_actionButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:44.0],

                                        [NSLayoutConstraint constraintWithItem:_actionButton
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:0.0],

                                        [NSLayoutConstraint constraintWithItem:_actionButton
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:0.0]

                                        ]];

    [NSLayoutConstraint activateConstraints:_constraints];
}

- (void)setSelectedDate:(NSDateComponents *)selectedDate {
    NSDateComponents *today = [self today];
    _selectedDate = [selectedDate isLaterThan:today] ? today : selectedDate;

    [self fetchEvents];
}

- (void)setDelegate:(id<OCKCustomCareCardViewControllerDelegate>)delegate
{
    _delegate = delegate;

    if ([NSOperationQueue currentQueue] != [NSOperationQueue mainQueue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updatePullToRefreshControl];
        });
    } else {
        [self updatePullToRefreshControl];
    }
}

- (void)setNoActivitiesText:(NSString *)noActivitiesText {
    _noActivitiesText = noActivitiesText;
    _noActivitiesLabel.text = noActivitiesText;
}

- (void)setHeaderTitleText:(NSString *)headerTitleText {
    _headerTitleText = headerTitleText;
    _headerView.title = headerTitleText;
}

- (void)setButtonColor:(UIColor *)buttonColor {
    _buttonColor = buttonColor;
    _headerView.tintColor = buttonColor;
    [_actionButton setBackgroundColor:buttonColor];
}

- (void)setActionButtonTitle:(NSString *)actionButtonTitle {
    _actionButtonTitle = actionButtonTitle;
    [_actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
}

- (void)setDateTitleText:(NSString *)dateTitleText {
    _dateTitleText = dateTitleText;
    _headerView.date = dateTitleText;
}

#pragma mark - Helpers

- (void)fetchEvents {
    [self.store eventsOnDate:self.selectedDate
                        type:OCKCarePlanActivityTypeIntervention
                  completion:^(NSArray<NSArray<OCKCarePlanEvent *> *> *eventsGroupedByActivity, NSError *error) {
                      NSAssert(!error, error.localizedDescription);
                      dispatch_async(dispatch_get_main_queue(), ^{
                          _events = [NSMutableArray new];
                          for (NSArray<OCKCarePlanEvent *> *events in eventsGroupedByActivity) {
                              [_events addObject:[events mutableCopy]];
                          }

                          if (self.delegate &&
                              [self.delegate respondsToSelector:@selector(careCardViewController:willDisplayEvents:dateComponents:)]) {
                              [self.delegate careCardViewController:self willDisplayEvents:[_events copy] dateComponents:_selectedDate];
                          }

                          _noActivitiesLabel.hidden = (_events.count > 0);
                          [self createGroupedEventDictionaryForEvents:_events];

                          [_tableView reloadData];
                      });
                  }];
}

- (NSDateComponents *)dateFromSelectedIndex:(NSInteger)index {
    NSDateComponents *newComponents = [NSDateComponents new];
    newComponents.year = self.selectedDate.year;
    newComponents.month = self.selectedDate.month;
    newComponents.weekOfMonth = self.selectedDate.weekOfMonth;
    newComponents.weekday = index + 1;

    NSDate *newDate = [_calendar dateFromComponents:newComponents];
    return [NSDateComponents ock_componentsWithDate:newDate calendar:_calendar];
}

- (NSDateComponents *)today {
    return [NSDateComponents ock_componentsWithDate:[NSDate date] calendar:_calendar];
}

- (UIViewController *)detailViewControllerForActivity:(OCKCarePlanActivity *)activity {
    OCKCareCardDetailViewController *detailViewController = [[OCKCareCardDetailViewController alloc] initWithIntervention:activity];
    return detailViewController;
}

- (OCKCarePlanActivity *)activityForIndexPath:(NSIndexPath *)indexPath {
    return _tableViewData[indexPath.section][indexPath.row].firstObject.activity;
}

- (BOOL)delegateCustomizesRowSelection {
    return self.delegate && [self.delegate respondsToSelector:@selector(careCardViewController:didSelectRowWithInterventionActivity:)];
}

- (void)updatePullToRefreshControl
{
    if (nil != _delegate &&
        [_delegate respondsToSelector:@selector(shouldEnablePullToRefreshInCareCardViewController:)] &&
        [_delegate shouldEnablePullToRefreshInCareCardViewController:self]) {

        _tableView.refreshControl = _refreshControl;
    } else {
        [_tableView.refreshControl endRefreshing];
        _tableView.refreshControl = nil;
    }
}

- (UIImage *)createCustomImageName:(NSString*)customImageName {
    UIImage *customImageToReturn;
    if (customImageName != nil) {
        NSBundle *bundle = [NSBundle mainBundle];
        customImageToReturn = [UIImage imageNamed: customImageName inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        OCKGlyphType defaultGlyph = OCKGlyphTypeHeart;
        customImageToReturn = [[OCKGlyph glyphImageForType:defaultGlyph] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }

    return customImageToReturn;
}

- (void)createGroupedEventDictionaryForEvents:(NSArray<NSArray<OCKCarePlanEvent *> *> *)events {
    NSMutableDictionary *groupedEvents = [NSMutableDictionary new];
    NSMutableArray *groupArray = [NSMutableArray new];

    for (NSArray<OCKCarePlanEvent *> *activityEvents in events) {
        OCKCarePlanEvent *firstEvent = activityEvents.firstObject;
        NSString *groupIdentifier = firstEvent.activity.groupIdentifier ? firstEvent.activity.groupIdentifier : _otherString;

        if (firstEvent.activity.optional) {
            groupIdentifier = _optionalString;
        }

        if (!_isGrouped) {
            // Force only one grouping
            groupIdentifier = _otherString;
        }

        if (groupedEvents[groupIdentifier]) {
            NSMutableArray<NSArray *> *objects = [groupedEvents[groupIdentifier] mutableCopy];
            [objects addObject:activityEvents];
            groupedEvents[groupIdentifier] = objects;
        } else {
            NSMutableArray<NSArray *> *objects = [[NSMutableArray alloc] initWithArray:activityEvents];
            groupedEvents[groupIdentifier] = @[objects];
            [groupArray addObject:groupIdentifier];
        }
    }

    if (_isGrouped && _isSorted) {

        NSMutableArray *sortedKeys = [[groupedEvents.allKeys sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        if ([sortedKeys containsObject:_otherString]) {
            [sortedKeys removeObject:_otherString];
            [sortedKeys addObject:_otherString];
        }

        if ([sortedKeys containsObject:_optionalString]) {
            [sortedKeys removeObject:_optionalString];
            [sortedKeys addObject:_optionalString];
        }

        _sectionTitles = [sortedKeys copy];

    } else {

        _sectionTitles = [groupArray mutableCopy];

    }

    NSMutableArray *array = [NSMutableArray new];
    for (NSString *key in _sectionTitles) {
        NSMutableArray *groupArray = [NSMutableArray new];
        NSArray *groupedEventsArray = groupedEvents[key];

        if (_isSorted) {

            NSMutableDictionary *activitiesDictionary = [NSMutableDictionary new];
            for (NSArray<OCKCarePlanEvent *> *events in groupedEventsArray) {
                NSString *activityTitle = events.firstObject.activity.title;
                activitiesDictionary[activityTitle] = events;
            }

            NSArray *sortedActivitiesKeys = [activitiesDictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
            for (NSString *activityKey in sortedActivitiesKeys) {
                [groupArray addObject:activitiesDictionary[activityKey]];
            }

            [array addObject:groupArray];

        } else {

            [array addObject:[groupedEventsArray mutableCopy]];

        }
    }

    _tableViewData = [array mutableCopy];
}


#pragma mark - OCKWeekViewDelegate

- (void)weekViewSelectionDidChange:(UIView *)weekView {
    OCKWeekView *currentWeekView = (OCKWeekView *)weekView;
    NSDateComponents *selectedDate = [self dateFromSelectedIndex:currentWeekView.selectedIndex];
    self.selectedDate = selectedDate;
}

- (BOOL)weekViewCanSelectDayAtIndex:(NSUInteger)index {
    NSDateComponents *today = [self today];
    NSDateComponents *selectedDate = [self dateFromSelectedIndex:index];
    return ![selectedDate isLaterThan:today];
}

#pragma mark - OCKCareCardCellDelegate

- (void)careCardTableViewCell:(OCKCareCardTableViewCell *)cell didUpdateFrequencyofInterventionEvent:(OCKCarePlanEvent *)event {
    _lastSelectedInterventionEvent = event;
    _lastSelectedInterventionActivity = event.activity;

    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(careCardViewController:didSelectButtonWithInterventionEvent:)]) {
        [self.delegate careCardViewController:self didSelectButtonWithInterventionEvent:event];
    }

    BOOL shouldHandleEventCompletion = YES;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(careCardViewController:shouldHandleEventCompletionForActivity:)]) {
        shouldHandleEventCompletion = [self.delegate careCardViewController:self shouldHandleEventCompletionForActivity:event.activity];
    }

    if (shouldHandleEventCompletion) {
        OCKCarePlanEventState state = (event.state == OCKCarePlanEventStateCompleted) ? OCKCarePlanEventStateNotCompleted : OCKCarePlanEventStateCompleted;

        [self.store updateEvent:event
                     withResult:nil
                          state:state
                     completion:^(BOOL success, OCKCarePlanEvent * _Nonnull event, NSError * _Nonnull error) {
                         NSAssert(success, error.localizedDescription);
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSMutableArray *events = [cell.interventionEvents mutableCopy];
                             [events replaceObjectAtIndex:event.occurrenceIndexOfDay withObject:event];
                             cell.interventionEvents = events;
                         });
                     }];
    }
}

- (void)careCardTableViewCell:(OCKCareCardTableViewCell *)cell didSelectInterventionActivity:(OCKCarePlanActivity *)activity {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    OCKCarePlanActivity *selectedActivity = [self activityForIndexPath:indexPath];
    _lastSelectedInterventionActivity = selectedActivity;

    if ([self delegateCustomizesRowSelection]) {
        [self.delegate careCardViewController:self didSelectRowWithInterventionActivity:selectedActivity];
    } else {
        [self.navigationController pushViewController:[self detailViewControllerForActivity:selectedActivity] animated:YES];
    }
}


#pragma mark - OCKCarePlanStoreDelegate

- (void)carePlanStore:(OCKCarePlanStore *)store didReceiveUpdateOfEvent:(OCKCarePlanEvent *)event {
    for (int i = 0; i < _tableViewData.count; i++) {
        NSMutableArray<NSMutableArray <OCKCarePlanEvent *> *> *groupedEvents = _tableViewData[i];

        for (int j = 0; j < groupedEvents.count; j++) {
            NSMutableArray<OCKCarePlanEvent *> *events = groupedEvents[j];

            if ([events.firstObject.activity.identifier isEqualToString:event.activity.identifier]) {
                if (events[event.occurrenceIndexOfDay].numberOfDaysSinceStart == event.numberOfDaysSinceStart) {
                    [events replaceObjectAtIndex:event.occurrenceIndexOfDay withObject:event];
                    _tableViewData[i][j] = events;

                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    OCKCareCardTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                    cell.interventionEvents = events;
                }
                break;
            }

        }

    }

    if ([event.date isInSameWeekAsDate: self.selectedDate]) {
    }
}

- (void)carePlanStoreActivityListDidChange:(OCKCarePlanStore *)store {
    [self fetchEvents];
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {

        NSDateComponents *components = [NSDateComponents new];

        NSDate *newDate = [_calendar dateByAddingComponents:components toDate:[_calendar dateFromComponents:self.selectedDate] options:0];

        self.selectedDate = [NSDateComponents ock_componentsWithDate:newDate calendar:_calendar];
    }
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = _sectionTitles[section];
    if ([sectionTitle isEqualToString:_otherString] && (_sectionTitles.count == 1 || (_sectionTitles.count == 2 && [_sectionTitles containsObject:_optionalString]))) {
        sectionTitle = @"";
    }
    return sectionTitle;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableViewData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewData[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CareCardCell";
    OCKCareCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[OCKCareCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CellIdentifier];
    }
    cell.interventionEvents = _tableViewData[indexPath.section][indexPath.row];
    cell.delegate = self;
    return cell;
}


#pragma mark - UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    CGRect headerFrame = [_tableView headerViewForSection:0].frame;

    if (indexPath &&
        !CGRectContainsPoint(headerFrame, location) &&
        ![self delegateCustomizesRowSelection]) {
        CGRect cellFrame = [_tableView cellForRowAtIndexPath:indexPath].frame;
        previewingContext.sourceRect = cellFrame;
        return [self detailViewControllerForActivity:[self activityForIndexPath:indexPath]];
    }

    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

@end


