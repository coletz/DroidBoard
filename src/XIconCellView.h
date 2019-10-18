#import "Constants.h"

@interface XIconCellView: UICollectionViewCell
@property (strong, nonatomic) UIImageView* appIcon;
@property (strong, nonatomic) UILabel* appName;
-(XIconCellView*)initWithFrame:(CGRect)frame;
@end