#import "XHomeView.h"

@implementation XHomeView

@synthesize coordinatorDelegate;

NSDictionary* applications;
NSArray* bundleIds;

NSSet* homeAppIds;

NSMutableArray* appCells = [[NSMutableArray alloc]init];

NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

BOOL isEditingCellPosition = NO;
int horizontalCellNumber = 4;
int verticalCellNumber = 5;
int cellWidth = 0;
int cellHeight = 0;

- (void)setCoordinatorDelegate:(id <XCoordinatorDelegate>)delegate {
    coordinatorDelegate = delegate;
}

-(XHomeView*)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    cellWidth = self.bounds.size.width / horizontalCellNumber;
    cellHeight = self.bounds.size.height / verticalCellNumber;

    [self loadApps];
    [self setupSwipeUp];

    return self;
}

-(void)loadApps {
    NSArray *outIds;
    applications = [[ALApplicationList sharedApplicationList] applicationsFilteredUsingPredicate:nil onlyVisible:YES titleSortedIdentifiers:&outIds];
    bundleIds = outIds;

    homeAppIds = [prefs objectForKey:@"homeAppIds"];

    [self setupUserAppGrid];
}

-(void)setupUserAppGrid {
    for (UIView *v in [self subviews]) {
        if ([v isKindOfClass:[XIconCellView class]]) {
            [v removeFromSuperview];
        }
    }

    for(NSString* bId in homeAppIds) {
        XIconCellView* cell = [[XIconCellView alloc]initWithFrame:CGRectMake(0, 0, ALApplicationIconSizeLarge, ALApplicationIconSizeLarge + 20)];
        
        cell.posX = [prefs integerForKey:[NSString stringWithFormat:@"pos_x_%@", bId]];
        cell.posY = [prefs integerForKey:[NSString stringWithFormat:@"pos_y_%@", bId]];
        
        [self setPixelPositionFromGridPosition:cell];
 
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
    if(!isEditingCellPosition){
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
}

-(void)onSwipeUp:(UIGestureRecognizer*)sender {
    if(isEditingCellPosition) {
        return;
    }

    // Swipe up must be from at least 80 px above bottom edge
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
    if(isEditingCellPosition){
        XIconCellView* cell = (XIconCellView*)sender.view;
        CGPoint translation = [sender translationInView:self];
        [self bringSubviewToFront:cell];

        cell.center = CGPointMake(cell.center.x + translation.x, cell.center.y + translation.y);
        [sender setTranslation:CGPointZero inView: self];

        if ([sender state] == UIGestureRecognizerStateEnded) {
            [self calculateGridPosition:cell];

            [prefs setInteger:cell.posX forKey:[NSString stringWithFormat:@"pos_x_%@", cell.bundleId]];
            [prefs setInteger:cell.posY forKey:[NSString stringWithFormat:@"pos_y_%@", cell.bundleId]];

            // Bring done button to top
            UIButton* stopCellEditingBtn = (UIButton*)[self viewWithTag:3348];
            [self bringSubviewToFront:stopCellEditingBtn];
        }
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

-(void)calculateGridPosition:(XIconCellView*)cell {
    int validX = cell.center.x;
    int validY = cell.center.y;

    int rootWidth = self.bounds.size.width;
    int rootHeight = self.bounds.size.height;

    if(validX < 0) {
        validX = 0;
    } else if(validX > rootWidth){
        validX = rootWidth;
    }

    if(validY < 0) {
        validY = 0;
    } else if(validY > rootHeight){
        validY = rootHeight;
    }

    int remX = validX % cellWidth;
    int remY = validY % cellHeight;

    cell.posX = (validX - remX)/cellWidth;
    cell.posY = (validY - remY)/cellHeight;

    [self setPixelPositionFromGridPosition:cell];
}

-(void)setPixelPositionFromGridPosition:(XIconCellView*)cell {
    int pixelPosX = cell.posX * cellWidth + cellWidth/2;
    int pixelPosY = cell.posY * cellHeight + cellHeight/2;

    cell.center = CGPointMake(pixelPosX, pixelPosY);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

@end
