#import "PopOverManager.h"
#import "Constants.h"
#import "MenuPopOver.h"


@interface PopOverManager ()

- (void) dismissWithPopOver;

@end

@implementation PopOverManager

@synthesize currentPopoverController;
@synthesize permitCurrentPopoverControllerToDismiss;
@synthesize appDelegate;
@synthesize mainMenu;
@synthesize delegate;


static PopOverManager *sharedManager = nil;

+ (void)initialize {
    if (self == [PopOverManager class]) {
        sharedManager = [[self alloc] init];
        sharedManager.permitCurrentPopoverControllerToDismiss = YES;
        sharedManager.appDelegate = [[UIApplication sharedApplication] delegate];
        sharedManager.mainMenu = [sharedManager.appDelegate.navigationController.viewControllers objectAtIndex:0];
    }
}

+ (id)sharedManager {
    return sharedManager;
}



#pragma mark - Instance Methods

- (void)setCurrentPopoverController:(UIPopoverController *)pc
{
    [self dismissCurrentPopoverController:YES];
    
    if (pc != currentPopoverController) {
        [currentPopoverController release];
        currentPopoverController = [pc retain];
        currentPopoverController.delegate = self;
    }
    self.permitCurrentPopoverControllerToDismiss = YES;
}

- (void)presentPopoverController:(UIPopoverController *)pc fromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    self.currentPopoverController = pc;
    [self.currentPopoverController presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
}

- (void)presentPopoverController:(UIPopoverController *)pc fromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    self.currentPopoverController = pc;
    [self.currentPopoverController presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
}

- (void)dismissCurrentPopoverController:(BOOL)animated;
{
    [self.currentPopoverController dismissPopoverAnimated:animated];
}

- (void)presentControllerInPopoverController:(UIViewController *)vc fromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
{
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:vc];
    [self presentPopoverController:pc fromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
    [pc release];
}

- (void)presentControllerInPopoverController:(UIViewController *)vc fromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
{
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:vc];
    [self presentPopoverController:pc fromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
    [pc release];
}

- (void) createMenuPopOver:(int) type fromButton:(id) button{
    MenuPopOver *menuVC = [[[MenuPopOver alloc] initWithStyle:UITableViewStylePlain] autorelease];
    menuVC.menuType = type;

    UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:menuVC];
    
    switch (type) {
        case accountProfileMenu:
            popOver.popoverContentSize = CGSizeMake(320, 44*3);
            break;
            
        case formManagerMenu:
            popOver.popoverContentSize = CGSizeMake(320, 44*5);
            break;
            
        default:
            break;
    }
    
    [self presentPopoverController:popOver fromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void) dismissWithPopOver{
    
}

- (void)dismissCurrentPopoverController:(BOOL)animated withSelectedOption:(int) selectedOption{
    [self dismissCurrentPopoverController:YES];

    switch (selectedOption) {
        case menuAirPrintFormSelected:
            if([delegate respondsToSelector:@selector(airPrintForm)])
               [self.delegate airPrintForm];
            
            break;
            
        case menuEmailFormSelected:
            if([delegate respondsToSelector:@selector(emailForm)])
                [self.delegate emailForm];

            break;
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverDimissed" object:popoverController];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return self.permitCurrentPopoverControllerToDismiss;
}

@end
