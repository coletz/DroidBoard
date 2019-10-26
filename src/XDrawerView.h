#import "Constants.h"
#import "XCoordinatorDelegate.h"
#import "XIconCellView.h"

@interface XDrawerView: UIView<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (nonatomic, weak) id <XCoordinatorDelegate> coordinatorDelegate;

@property (strong, nonatomic) UICollectionView* userAppsCollectionView;
@property (strong, nonatomic) UICollectionView* systemAppsCollectionView;
-(XDrawerView*)initWithFrame:(CGRect)frame;
-(void)show;
-(void)hide;
-(void)hideProgrammatically;

@end