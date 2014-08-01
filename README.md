APLExpandableCollectionView
=========

UICollectionView subclass with vertically expandable and collapsible sections.

* animated expand and collapse animation
* scrolls expanded section to visible
* customizable flow layout for iPhone and iPad

![iPad Screenshot](screenshot-ipad-landscape.png) ![iPhone Screenshot](screenshot-iphone.png)


## Installation
Install via cocoapods by adding this to your Podfile:

	pod "APLExpandableCollectionView"

## Usage
In your storyboard, set the custom class of your UICollectionView to `APLExpandableCollectionView` and it's layout to custom, using the `APLExpandableSectionFlowLayout` class.

You might want to customize the collection view layout's `sectionInset`, `minimumLineSpacing`, `itemSize`, etc. to fit your layout needs and customize the cell appearance depending on whether it is a section's first cell, which is the "header cell", or a regular item. Check out the demo project as reference.

If you are not interested in expandable cells but would like to use a UICollectionViewFlowLayout which layouts it's sections and their items from top to bottom, left to right instead of left to right, top to bottom as displayed on the iPad screenshot, you could benefit from the `APLSectionTopToBottomFlowLayout`. It is inherited by the `APLExpandableSectionFlowLayout` but could be used on its own.
