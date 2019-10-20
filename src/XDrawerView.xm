#import "XDrawerView.h"

@implementation XDrawerView

NSArray *userBundleIds;
NSArray *systemBundleIds;

-(XDrawerView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.alpha = 0;

	[self loadApps];
	[self setupUserAppGrid];
    [self setupSystemAppGrid];
	[self setupSwipeDown];

    return self;
}

-(void)loadApps {
	NSArray *outIds;
	[[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:nil onlyVisible:YES titleSortedIdentifiers:&outIds];
	userBundleIds = outIds;
}

-(void)setupUserAppGrid {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _userAppsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    [_userAppsCollectionView setContentInset:UIEdgeInsetsMake(32, 16, 0, 16)];
    [_userAppsCollectionView setDataSource:self];
    [_userAppsCollectionView setDelegate:self];

    [_userAppsCollectionView registerClass:[XIconCellView class] forCellWithReuseIdentifier:@"cellIdentifier"];
    _userAppsCollectionView.backgroundColor = nil;

    [self addSubview:_userAppsCollectionView];
}

-(void)setupSystemAppGrid {
    // TODO
}

-(void)setupSwipeDown {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeDown:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

-(void)onSwipeDown:(UIGestureRecognizer*)sender {
    
    if (_userAppsCollectionView.contentOffset.y > 10) {
        // User is scrolling from bottom to top, still not arrived at top
        return;
    }
    
    [self hide];
}

-(void)show {
    [UIView animateWithDuration:0.3
            delay:0
            options: UIViewAnimationCurveEaseIn
            animations:^ {
                 CGRect frame = self.frame;
                 frame.origin.y = statusBarHeight;
                 self.frame = frame;
                 self.alpha = 1;
             }
             completion:nil];
}

-(void)hideProgrammatically {
    [_userAppsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:0];
    [self hide];
}

-(void)hide {
    [UIView animateWithDuration:0.3
        delay:0
        options: UIViewAnimationCurveEaseOut
        animations:^ {
            CGRect frame = self.frame;
            frame.origin.y = self.bounds.size.height + statusBarHeight;
            self.frame = frame;
            self.alpha = 0;
         }
         completion:nil];
}

// Collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return userBundleIds.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    XIconCellView* cell = (XIconCellView*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setAppId:userBundleIds[indexPath.row]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return CGSizeMake(icon.width, icon.height + 20);
}

-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath  {
    [self hide];
    XIconCellView* cell = (XIconCellView*) [collectionView cellForItemAtIndexPath:indexPath];
    [cell launchApp];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

@end