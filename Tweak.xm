#import <AppList/AppList.h>
#import <GraphicsServices/GSEvent.h>

// Interfaces - TO BE MOVED ON A SEPARATED FILE
@interface UIApplication (Undocumented)
- (void) launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended; 
@end

@interface XIconCellView: UICollectionViewCell
@property (strong, nonatomic) UIImageView* appIcon;
@property (strong, nonatomic) UILabel* appName;
-(XIconCellView*)initWithFrame:(CGRect)frame;
@end

// Statics
static CGSize screen;
static CGSize icon = CGSizeMake(ALApplicationIconSizeLarge, ALApplicationIconSizeLarge);
static int statusBarHeight = 20;


@implementation XIconCellView
-(XIconCellView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    // - ICON
    _appIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icon.width, icon.height)];
    _appIcon.contentMode = UIViewContentModeScaleAspectFit;    

    int elevation = 2;
    _appIcon.layer.masksToBounds = NO;
    _appIcon.layer.shadowColor = [[UIColor blackColor] CGColor];
    _appIcon.layer.shadowOffset = CGSizeMake(0, elevation);
    _appIcon.layer.shadowOpacity = 0.24;
    _appIcon.layer.shadowRadius = elevation;

    _appIcon.layer.borderWidth = 1.0;
    _appIcon.layer.borderColor = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.35] CGColor];
    _appIcon.layer.cornerRadius = 12;
    _appIcon.layer.shouldRasterize = YES; 
    _appIcon.layer.rasterizationScale = [UIScreen mainScreen].scale; 
    [self addSubview:_appIcon];
    // --- constraints 
    [_appIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_appIcon.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0].active = YES;
    [_appIcon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    //[_appIcon.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.75]:

    // - NAME LABEl
    _appName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _appName.textColor = [UIColor blackColor];
    _appName.textAlignment = NSTextAlignmentCenter;
    _appName.font = [UIFont systemFontOfSize:12];
    [self addSubview:_appName];
    // --- constraints
    [_appName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_appName.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0].active = YES;
    [_appName.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0.0].active = YES;
    [_appName.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0].active = YES;

    return self;
}

@end

@interface SBHomeScreenViewController: UIViewController<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(void)loadApps;
-(void)updateScreenSize;

-(void)setupHomeSwipeUp;
-(void)onHomeSwipeUp:(UIGestureRecognizer*)sender;

-(void)setupDrawerSwipeDown;
-(void)onDrawerSwipeDown:(UIGestureRecognizer*)sender;

-(void)setupHomeDoubleTap;
-(void)onHomeDoubleTap:(UIGestureRecognizer*)sender;

-(void)setupDrawerGrid;
@end

%hook SBHomeScreenViewController

// Properties
UIView* xRootView;
UIView* xHomeView;
UIView* xDrawerView;
UICollectionView* xCollectionView;

NSDictionary *applications;
NSArray *bundleIds;

// Hooked methods

-(void)viewDidAppear:(BOOL)arg1 {
    %orig(arg1);
    [self loadApps];
    [self updateScreenSize];
    
    xRootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height)];
    [self.view addSubview:xRootView];

    xHomeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height - statusBarHeight)];
    [xRootView addSubview:xHomeView];

    xDrawerView = [[UIView alloc]initWithFrame:CGRectMake(0, screen.height, screen.width, screen.height - statusBarHeight)];
    xDrawerView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    xDrawerView.alpha = 0;
    [xRootView addSubview:xDrawerView];

    [self setupDrawerGrid];

    [self setupHomeSwipeUp];
    [self setupDrawerSwipeDown];
    [self setupHomeDoubleTap];
}

// New methods

%new
-(void)loadApps {
	NSArray *outIds;
	//NSPredicate *filter = [NSPredicate predicateWithFormat:@"isSystemApplication = FALSE"];
	//applications = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:filter onlyVisible:YES titleSortedIdentifiers:&outIds];
	applications = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:nil onlyVisible:YES titleSortedIdentifiers:&outIds];
	bundleIds = outIds;
}

%new
-(void)updateScreenSize {
    CGRect scrBounds = [[UIScreen mainScreen] bounds];
    screen = scrBounds.size;
}

%new
-(void)setupDrawerGrid {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    xCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, xDrawerView.frame.size.width, xDrawerView.frame.size.height) collectionViewLayout:layout];
    [xCollectionView setContentInset:UIEdgeInsetsMake(32, 16, 0, 16)];
    [xCollectionView setDataSource:self];
    [xCollectionView setDelegate:self];

    [xCollectionView registerClass:[XIconCellView class] forCellWithReuseIdentifier:@"cellIdentifier"];
    xCollectionView.backgroundColor = nil;

    [xDrawerView addSubview:xCollectionView];
}

%new
-(void)setupHomeSwipeUp {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onHomeSwipeUp:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    [xHomeView addGestureRecognizer:recognizer];
}

%new
-(void)onHomeSwipeUp:(UIGestureRecognizer*)sender {
    if([sender locationInView:self.view].y > screen.height - 90) {
        return;
    }

    [UIView animateWithDuration:0.3
        delay:0
        options: UIViewAnimationCurveEaseIn
        animations:^ {
             CGRect frame = xDrawerView.frame;
             frame.origin.y = statusBarHeight;
             xDrawerView.frame = frame;
             xDrawerView.alpha = 1;
         }
         completion:nil];
}

%new
-(void)setupDrawerSwipeDown {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onDrawerSwipeDown:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    [xDrawerView addGestureRecognizer:recognizer];
}

%new
-(void)onDrawerSwipeDown:(UIGestureRecognizer*)sender {
    if (xCollectionView.contentOffset.y > 10) {
        return;
    }
    [UIView animateWithDuration:0.3
        delay:0
        options: UIViewAnimationCurveEaseOut
        animations:^ {
            CGRect frame = xDrawerView.frame;
            frame.origin.y = screen.height;
            xDrawerView.frame = frame;
            xDrawerView.alpha = 0;
         }
         completion:nil];
}

%new
-(void)setupHomeDoubleTap {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHomeDoubleTap:)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.delegate = self;
    [xHomeView addGestureRecognizer:recognizer];
}

%new
-(void)onHomeDoubleTap:(UIGestureRecognizer*)sender {
    struct GSEventRecord record;
    memset(&record, 0, sizeof(record));
    record.type = kGSEventLockButtonDown;
    record.timestamp = GSCurrentEventTimestamp();
    GSSendSystemEvent(&record);
    record.type = kGSEventLockButtonUp;
    GSSendSystemEvent(&record);
}

// Collection view
%new
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return applications.count;
}

%new
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    XIconCellView* cell = (XIconCellView*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [[cell appIcon] setImage:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:bundleIds[indexPath.row]]];
    [[cell appName] setText:applications[bundleIds[indexPath.row]]];
    return cell;
}

%new
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return CGSizeMake(icon.width, icon.height + 20);
}

%new
-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath  {
    [self onDrawerSwipeDown:nil];

    [[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleIds[indexPath.row] suspended:NO];
}

%new
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

%end
