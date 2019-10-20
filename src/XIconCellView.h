#import "Constants.h"

@interface XIconCellView: UICollectionViewCell
@property (strong, nonatomic) UILabel* appName;
@property (strong, nonatomic) UIImageView* appIcon;

@property (nonatomic) NSString* bundleId;

-(XIconCellView*)initWithFrame:(CGRect)frame;
-(void)setAppId:(NSString*)appId;
-(void)launchApp;
@end

@interface UIApplication (Undocumented)
- (void) launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended; 
@end