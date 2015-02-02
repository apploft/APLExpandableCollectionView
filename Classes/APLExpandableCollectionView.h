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

@end
