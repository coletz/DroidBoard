#import "XHomeView.h"

@implementation XHomeView

@synthesize coordinatorDelegate;

NSDictionary* applications;
NSArray* bundleIds;

NSArray* preferredBundleIds = @[
    @"com.atebits.Tweetie2",
    @"com.google.chrome.ios",
    @"ph.telegra.Telegraph",
    @"com.apple.mobilephone"
];

NSMutableArray* appCells = [[NSMutableArray alloc]init];

BOOL isEditingCellPosition = NO;

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
    applications = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:nil onlyVisible:YES titleSortedIdentifiers:&outIds];
    bundleIds = outIds;
}

-(void)setupUserAppGrid {
    for(NSString* bId in preferredBundleIds) {
        XIconCellView* cell = [[XIconCellView alloc]initWithFrame:CGRectMake(0, 0, ALApplicationIconSizeLarge, ALApplicationIconSizeLarge + 20)];
        [cell setAppId:bId];
        [self addSubview:cell];
        [cell setUserInteractionEnabled:YES];
        
        // Long press = edit position
        UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onCellLongPressed:)];
        [cell addGestureRecognizer:longPressGesture];
        
        // Pan = move, only after long press
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCellDragged:)];
        [cell addGestureRecognizer:panGesture];

        // Single touch = start app
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCellTapped:)];
        tapGesture.numberOfTapsRequired = 1;
        [cell addGestureRecognizer:tapGesture];

        [appCells addObject:cell];
    }
}

-(void)setupSwipeUp {
    UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeUp:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 1;
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

-(void)enableCellEdit {
    isEditingCellPosition = YES;

    UIButton* stopCellEditingBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 60, 24, 52, 24)];
    stopCellEditingBtn.tag = 3348;

    stopCellEditingBtn.clipsToBounds = YES;
    stopCellEditingBtn.layer.cornerRadius = stopCellEditingBtn.bounds.size.height/2;

    stopCellEditingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    stopCellEditingBtn.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    [stopCellEditingBtn setTitle:@"DONE" forState:UIControlStateNormal];
    [stopCellEditingBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] forState:UIControlStateNormal];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onStopCellEditTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    [stopCellEditingBtn addGestureRecognizer:tapGesture];
    [self addSubview:stopCellEditingBtn];
}

-(void)onSwipeUp:(UIGestureRecognizer*)sender {
    if(isEditingCellPosition) {
        return;
    }

    if([sender locationInView:self].y > self.bounds.size.height - 80) {
        return;
    }

    [coordinatorDelegate showDrawer];
}

-(void)onCellLongPressed:(UILongPressGestureRecognizer*)sender {
    if ([sender state] == UIGestureRecognizerStateBegan) {
        [self enableCellEdit];
    }
}

-(void)onCellDragged:(UIPanGestureRecognizer*)sender {
    XIconCellView* cell = (XIconCellView*)sender.view;
    if(isEditingCellPosition){
        CGPoint translation = [sender translationInView:self];
        [self bringSubviewToFront:cell];

        cell.center = CGPointMake(cell.center.x + translation.x, cell.center.y + translation.y);
        [sender setTranslation:CGPointZero inView: self];
    }
}

-(void)onCellTapped:(UITapGestureRecognizer*)sender {
    XIconCellView* cell = (XIconCellView*)sender.view;
    if(!isEditingCellPosition) {
        [cell launchApp];
    }
}

-(void)onStopCellEditTapped:(UITapGestureRecognizer*)sender {
    isEditingCellPosition = NO;

    UIButton* stopCellEditingBtn = (UIButton*)[self viewWithTag:3348];
    [stopCellEditingBtn removeFromSuperview];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

@end