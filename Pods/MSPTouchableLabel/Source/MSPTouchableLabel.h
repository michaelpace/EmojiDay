//
//  MSPTouchableLabel.h
//  MSPTouchableLabel
//
//  Created by Michael Pace on 4/12/15.
//  Copyright (c) 2015 Michael Pace. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@class MSPTouchableLabel;

/**
 @discussion            Representation of a touch event on an MSPTouchableLabel.
 */
typedef struct {
    /** Location of the touch. */
    CGPoint point;
    
    /** Index of the touched piece of text (as supplied by MSPTouchableLabelDataSource's textForTouchableLabel:). */
    NSInteger index;
    
    /** Size of the touched piece of text as if it were drawn on one line. This may or may not be how the piece of text is actually drawn within the MSPTouchableLabel. Intended to be used with MSPTouchEventData.singleLineAdjustedPoint. */
    CGSize textPieceSingleLineSize;
    
    /** Adjusted location of the touch. Indicates where the touch fell within MSPTouchEventData.textPieceSingleLineSize. */
    CGPoint singleLineAdjustedPoint;
    
} MSPTouchEventData;

@protocol MSPTouchableLabelDelegate

@optional
/**
 @discussion            Called as soon as the user touches the touchableLabel.
 @param touchableLabel  The current MSPTouchableLabel.
 @param index           The index (per MSPTouchableLabelDataSource's textForTouchableLabel:).
 */
- (void)touchableLabel:(MSPTouchableLabel*)touchableLabel touchesDidBeginAtIndex:(NSInteger)index;

/**
 @discussion            Called when a user's touch moves from one MSPTouchableLabel index to a new index.
 @param touchableLabel  The current MSPTouchableLabel.
 @param index           The index (per MSPTouchableLabelDataSource's textForTouchableLabel:).
 */
- (void)touchableLabel:(MSPTouchableLabel*)touchableLabel touchesDidMoveToIndex:(NSInteger)index;

/**
 @discussion            Called when the user ends a touch on an MSPTouchableLabel index.
 @param touchableLabel  The current MSPTouchableLabel.
 @param index           The index (per MSPTouchableLabelDataSource's textForTouchableLabel:).
 */
- (void)touchableLabel:(MSPTouchableLabel*)touchableLabel touchesDidEndAtIndex:(NSInteger)index;

/**
 @discussion            Called when a user's touch moves off of the MSPTouchableLabel.
 @param touchableLabel  The current MSPTouchableLabel.
 */
- (void)touchesDidMoveFromLabel:(MSPTouchableLabel*)touchableLabel;

@end

@protocol MSPTouchableLabelDataSource

/**
 @discussion            Called to discover the text to render in the MSPTouchableLabel. Use this instead of setting the UILabel's `text` property.
 @param touchableLabel  The current MSPTouchableLabel.
 @return                Return an NSArray* of NSString*s. The order of the strings here is the `index` parameter in MSPTouchableLabelDelegate methods as well as MSPTouchableLabelDataSource's attributesForTouchableLabel:atIndex:
 */
- (NSArray*)textForTouchableLabel:(MSPTouchableLabel*)touchableLabel;

@optional
/**
 @discussion            Called to discover formatting per string provided in MSPTouchableLabelDataSource's textForTouchableLabel:.
 @param touchableLabel  The current MSPTouchableLabel.
 @param index           The index of the string provided in MSPTouchableLabelDataSource's textForTouchableLabel:.
 @return                Return an NSDictionary* of key-value pairs (e.g., @{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:18.0f] }). Return nil if the index should use the label's default formatting.
 */
- (NSDictionary*)attributesForTouchableLabel:(MSPTouchableLabel*)touchableLabel atIndex:(NSInteger)index;

@end

/**
 @discussion            A label users can interact with. Use it like a UITableView. Set a dataSource to provide text for the label and a delegate to find out how the user interacts with the label. Do not set the `text` property of an MSPTouchableLabel.
 */
@interface MSPTouchableLabel : UILabel

/**
 @brief                 On by default. When on, modifies the strings passed in MSPTouchableLabelDataSource's textForTouchableLabel: to improve rendering performance.
 @discussion            Improves performance by inserting newlines (\n) into the strings to be rendered, and drawing multiple lines at once instead of drawing line by line. This could change the look of the rendered text (e.g., when this is on, a background highlight with NSBackgroundColorAttributeName will extend to the far-right edge of the drawRect before continuing to the next line instead of only highlighting directly behind text that is being rendered).
 */
@property (assign) BOOL multiLineRenderingOptimizationsEnabled;

@property (nonatomic, strong) id<MSPTouchableLabelDataSource> dataSource;
@property (nonatomic, strong) id<MSPTouchableLabelDelegate> delegate;

/**
 @param point           CGPoint representing a point on the MSPTouchableLabel.
 @return                Index of the element at the given point. Returns nil if there is no element at that point.
 */
- (MSPTouchEventData)touchEventDataAtPoint:(CGPoint)point;

/**
 @return                Returns the size an MSPTouchableLabel would occupy with the given textSections and attributes for those textSections within rect.
 */
+ (CGSize)sizeForTouchableLabelGivenText:(NSArray*)textSections withAttributes:(NSArray*)attributes inRect:(CGRect)rect;

@end