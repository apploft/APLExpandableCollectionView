#import <UIKit/UIKit.h>

@protocol APLExpandableCollectionViewDelegate <UICollectionViewDelegateFlowLayout>

@optional

/** Tells the delegate that the item at the specified index path was expanded. */
- (void)collectionView:(UICollectionView *)collectionView didExpandItemAtIndexPath:(NSIndexPath *)indexPath;

/** Tells the delegate that the item at the specified index path was collapsed. */
- (void)collectionView:(UICollectionView *)collectionView didCollapseItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface APLExpandableCollectionView : UICollectionView

/** The collection view’s delegate object. */
@property (nonatomic, assign) id <APLExpandableCollectionViewDelegate> delegate;

/** A Boolean value that determines whether users can expand more than one section, default is YES */
@property (nonatomic, assign) BOOL allowsMultipleExpandedSections;

/** Returns YES if the specified section is expanded. */
- (BOOL)isExpandedSection:(NSInteger)section;

/** Inserts a new section at the end of the section list.
 @param isExpanded Specifies whether the new section is initially expanded */
- (void)addExpandedSection:(BOOL)isExpanded;

/** Inserts a new section into the section list at a given index.
 @param isExpanded Specifies whether the new section is initially expanded
 @param index The index at which to insert the new section. This value must not be greater than the count of sections, otherwise this method does nothing.
 */
- (void)insertExpandedSection:(BOOL)isExpanded atIndex:(NSUInteger)index;

/** Collapse all expaneded section.
 */
- (void)collapseAllSections;
@end
