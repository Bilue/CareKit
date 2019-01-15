//
//  OCKCustomCareCardViewController.h
//  CareKit
//
//  Created by Damian Dara on 15/1/19.
//  Copyright © 2019 carekit.org. All rights reserved.
//

#import <CareKit/CareKit.h>


NS_ASSUME_NONNULL_BEGIN

@class OCKCarePlanStore, OCKCustomCareCardViewController;

/**
 An object that adopts the `OCKCareCardViewControllerDelegate` protocol can use it modify or update the events before they are displayed.
 */
@protocol OCKCustomCareCardViewControllerDelegate <NSObject>

@optional

/**
 Asks the delegate if care card view controller should automatically mark the state of an intervention activity when
 the user selects and deselects the intervention circle button. If this method is not implemented, care card view controller
 handles all event completion by default.

 If returned NO, the `careCardViewController:didSelectButtonWithInterventionEvent` method can be implemeted to provide
 custom logic for completion.

 @param viewController              The view controller providing the callback.
 @param interventionActivity        The intervention activity that the user selected.
 */
- (BOOL)careCardViewController:(OCKCustomCareCardViewController *)viewController shouldHandleEventCompletionForActivity:(OCKCarePlanActivity *)interventionActivity;

/**
 Tells the delegate when the user tapped an intervention event.

 If the user must perform some activity in order to complete the intervention event,
 then this method can be implemented to show a custom view controller.

 If the completion status of the event is dependent on the presented activity, the developer can implement
 the `careCardViewController:shouldHandleEventCompletionForActivity` to control the completion status of the event.

 @param viewController              The view controller providing the callback.
 @param interventionEvent           The intervention event that the user selected.
 */
- (void)careCardViewController:(OCKCustomCareCardViewController *)viewController didSelectButtonWithInterventionEvent:(OCKCarePlanEvent *)interventionEvent;

/**
 Tells the delegate when the user selected an intervention activity.

 This can be implemented to show a custom detail view controller.
 If not implemented, a default detail view controller will be presented.

 @param viewController              The view controller providing the callback.
 @param interventionActivity        The intervention activity that the user selected.
 */
- (void)careCardViewController:(OCKCustomCareCardViewController *)viewController didSelectRowWithInterventionActivity:(OCKCarePlanActivity *)interventionActivity;

/**
 Tells the delegate when a new set of events is fetched from the care plan store.

 This is invoked when the date changes or when the care plan store's `carePlanStoreActivityListDidChange` delegate method is called.
 This provides a good opportunity to update the store such as fetching data from HealthKit.

 @param viewController          The view controller providing the callback.
 @param events                  An array containing the fetched set of intervention events grouped by activity.
 @param dateComponents          The date components for which the events will be displayed.
 */
- (void)careCardViewController:(OCKCustomCareCardViewController *)viewController willDisplayEvents:(NSArray<NSArray<OCKCarePlanEvent*>*>*)events dateComponents:(NSDateComponents *)dateComponents;

/**
 Asks the delegate if the care card view controller should enable pull-to-refresh behavior on the activities list. If not implemented,
 pull-to-refresh will not be enabled.

 If returned YES, the `careCardViewController:didActivatePullToRefreshControl:` method should be implemented to provide custom
 refreshing behavior when triggered by the user.

 @param viewController              The view controller providing the callback.
 */
- (BOOL)shouldEnablePullToRefreshInCareCardViewController:(OCKCustomCareCardViewController *)viewController;

/**
 Tells the delegate the user has triggered pull to refresh on the activities list.

 Provides the opportunity to refresh data in the local store by, for example, fetching from a cloud data store.
 This method should always be implmented in cases where `shouldEnablePullToRefreshInCareCardViewController:` might return YES.

 @param viewController              The view controller providing the callback.
 @param refreshControl              The refresh control which has been triggered, where `isRefreshing` should always be YES.
 It is the developers responsibility to call `endRefreshing` as appropriate, on the main thread.
 */
- (void)careCardViewController:(OCKCustomCareCardViewController *)viewController didActivatePullToRefreshControl:(UIRefreshControl *)refreshControl;

@end


/**
 The `OCKCareCardViewController` class is a view controller that displays the activities and events
 from an `OCKCarePlanStore` that are of intervention type (see `OCKCarePlanActivityTypeIntervention`).

 It includes a master view and a detail view. Therefore, it must be embedded inside a `UINavigationController`.
 */
OCK_CLASS_AVAILABLE
@interface OCKCustomCareCardViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

/**
 Returns an initialized care card view controller using the specified store.

 @param store        A care plan store.

 @return An initialized care card view controller.
 */
- (instancetype)initWithCarePlanStore:(OCKCarePlanStore *)store;

/**
 The care plan store that provides the content for the care card.

 The care card displays activites and events that are of intervention type (see `OCKCarePlanActivityTypeIntervention`).
 */
@property (nonatomic, readonly) OCKCarePlanStore *store;

/**
 The delegate can be used to modify or update the internvention events before they are displayed.

 See the `OCKCareCardViewControllerDelegate` protocol.
 */
@property (nonatomic, weak, nullable) id<OCKCustomCareCardViewControllerDelegate> delegate;

/**
 The last intervention activity selected by the user.

 This value is nil if no intervention activity has been selected yet.
 */
@property (nonatomic, readonly, nullable) OCKCarePlanActivity *lastSelectedInterventionActivity;

/**
 The last intervention event selected by the user.

 This value is nil if no intervention event has been selected yet.
 */
@property (nonatomic, readonly, nullable) OCKCarePlanEvent *lastSelectedInterventionEvent;

/**
 A reference to the `UITableView` contained in the view controller
 */
@property (nonatomic, readonly, nonnull) UITableView *tableView;

/**
 A reference to the `UIButton` container in the view controller
 */
@property (nonatomic, nonnull) UIButton *actionButton;

/**
 A message that will be displayed in the table view's background view if there are
 no intervention activities to display.

 If the value is not specified, nothing will be shown when the table is empty.
 */
@property (nonatomic, nullable) NSString *noActivitiesText;

/**
 Header's title 
 */
@property (nonatomic, nullable) NSString *headerTitleText;

/**
 Date label's text value
 */
@property (nonatomic, nullable) NSString *dateTitleText;

/**
 Action button title located at the bottom of the page
 */
@property (nonatomic, nullable) NSString *actionButtonTitle;

/**
 Action button background color
 */
@property (nonatomic, nullable) UIColor *buttonColor;

/**
 The property that allows activities to be grouped.

 If true, the activities will be grouped by groupIdentifier into sections,
 otherwise the activities will all be in one section and groupIdentifier is ignored.

 The default is false.
 */
@property (nonatomic) BOOL isGrouped;

/**
 The property that allows activities to be sorted.

 If true, the activities will be sorted alphabetically by title and by groupIdentifier if isGrouped is true,
 otherwise the activities will be sorted in the order they are added in the care plan store.

 The default is true.
 */
@property (nonatomic) BOOL isSorted;

@end

NS_ASSUME_NONNULL_END
