#import "XHomeView.h"

@implementation XHomeView

@synthesize appLaunchDelegate;
@synthesize coordinatorDelegate;

NSDictionary *applications;
NSArray *bundleIds;

- (void)setAppLaunchDelegate:(id <XAppLaunchDelegate>)delegate {
    appLaunchDelegate = delegate;
}

- (void)setCoordinatorDelegate:(id <XCoordinatorDelegate>)delegate {
    coordinatorDelegate = delegate;
}

-(XHomeView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    [self loadApps];
    [self setupUserAppGrid];
    [self setupSwipeUp];

    return self;
}

-(void)loadApps {
    NSArray *outIds;
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"isSystemApplication = FALSE"];
    applications = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:filter onlyVisible:YES titleSortedIdentifiers:&outIds];
    bundleIds = outIds;
}

-(void)setupUserAppGrid {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _appsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    [_appsCollectionView setContentInset:UIEdgeInsetsMake(32, 16, 0, 16)];
    [_appsCollectionView setDataSource:self];
    [_appsCollectionView setDelegate:self];

    [_appsCollectionView registerClass:[XIconCellView class] forCellWithReuseIdentifier:@"cellIdentifier"];
    _appsCollectionView.backgroundColor = nil;

    [self addSubview:_appsCollectionView];
}

-(void)setupSwipeUp {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeUp:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

-(void)onSwipeUp:(UIGestureRecognizer*)sender {
    if([sender locationInView:self].y > self.bounds.size.height - 90) {
        return;
    }

    [coordinatorDelegate showDrawer];
}

// Collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return applications.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    XIconCellView* cell = (XIconCellView*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [[cell appIcon] setImage:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:bundleIds[indexPath.row]]];
    [[cell appName] setText:applications[bundleIds[indexPath.row]]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return CGSizeMake(icon.width, icon.height + 20);
}

-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath  {
    [appLaunchDelegate launch:bundleIds[indexPath.row]];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

@end