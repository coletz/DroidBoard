#import "Constants.h"
#import "XIconCellView.h"

@interface XDrawerView: UIView<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UICollectionView* userAppsCollectionView;
@property (strong, nonatomic) UICollectionView* systemAppsCollectionView;
-(XDrawerView*)initWithFrame:(CGRect)frame;
-(void)show;
-(void)hide;

@end