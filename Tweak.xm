#import <SpringBoard/SpringBoard.h>
#import <AppList/AppList.h>
#import <GraphicsServices/GraphicsServices.h>

// Statics
static CGSize screen;
static CGSize icon = CGSizeMake(ALApplicationIconSizeLarge, ALApplicationIconSizeLarge);
static int statusBarHeight = 20;

@interface UIApplication (Undocumented)
- (void) launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended; 
@end


@interface XIconCellView: UICollectionViewCell
@property (strong, nonatomic) UIImageView* imageView;
-(XIconCellView*)initWithFrame:(CGRect)frame;
-(void)setImage:(UIImage*)img;
@end

@implementation XIconCellView
-(XIconCellView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icon.width, icon.height)];
    _imageView.layer.cornerRadius = 12;//icon.width/2;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.shouldRasterize = YES; 
    _imageView.layer.rasterizationScale = [UIScreen mainScreen].scale; 
    _imageView.layer.borderColor = [[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1] CGColor];
    _imageView.layer.borderWidth = 1.0;



    [self addSubview:_imageView];
    return self;
}
-(void)setImage:(UIImage*)img {
    _imageView.image = img;
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
UICollectionView *_collectionView;

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
	NSPredicate *filter = [NSPredicate predicateWithFormat:@"isSystemApplication = FALSE"];
	applications = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:filter onlyVisible:YES titleSortedIdentifiers:&outIds];
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, xDrawerView.frame.size.width, xDrawerView.frame.size.height) collectionViewLayout:layout];
    [_collectionView setContentInset:UIEdgeInsetsMake(30, 30, 0, 30)];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];

    [_collectionView registerClass:[XIconCellView class] forCellWithReuseIdentifier:@"cellIdentifier"];
    _collectionView.backgroundColor = nil;

    [xDrawerView addSubview:_collectionView];
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
    [UIView animateWithDuration:0.3
        delay:0
        options: UIViewAnimationCurveEaseOut
        animations:^ {
            CGRect frame = xDrawerView.frame;
            frame.origin.y = screen.height - statusBarHeight;
            xDrawerView.frame = frame;
            xDrawerView.alpha = 0;
         }
         completion:nil];
}

%new
-(void)setupHomeDoubleTap {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHomeDoubleTap:)];
    recognizer.numberOfTapsRequired = 1;
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
    [self onHomeSwipeUp:nil];
}

// Collection view
%new
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return applications.count;
}

%new
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    XIconCellView* cell = (XIconCellView*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setImage:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:bundleIds[indexPath.row]]];
    return cell;
}

%new
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return icon;
}

%new
-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath  {
    [self onDrawerSwipeDown:nil];

    [[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleIds[indexPath.row] suspended:NO];
}

%end