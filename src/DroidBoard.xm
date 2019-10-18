#import "DroidBoard.h"

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
    if(sender != nil) {
        // Sender is not nil, user is scrolling
        if (xCollectionView.contentOffset.y > 10) {
            // User is scrolling from bottom to top, still not arrived at top
            return;
        }
    } else {
        // Called from code, probably after opening an app; scroll to top
        [xCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:0];
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
