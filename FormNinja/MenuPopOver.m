//
//  MenuPopOver.m
//  FormNinja
//
//  Created by Paul Salazar on 6/10/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "MenuPopOver.h"
#import "Constants.h"
#import "PopOverManager.h"


static NSString* MenuType_toEnum[] = {
    syncMenuOption,
    logoutMenuOption,
    newFormMenuOption,
    newTemplateMenuOption,
    airPrintFormMenuOption,
    emailFormMenuOption
};


@implementation MenuPopOver

@synthesize menuType, menuOptions, selectedAction;

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //Load map types
    if (self.menuType == formManagerMenu || self.menuType == formManagerNoSendMenu){ 
        self.menuOptions = [NSArray arrayWithObjects: airPrintFormMenuOption, emailFormMenuOption, syncMenuOption, logoutMenuOption, newTemplateMenuOption,  nil];
    }
    
    else{
        self.menuOptions = [NSArray arrayWithObjects:syncMenuOption, logoutMenuOption, newTemplateMenuOption, nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Instance Methods

// A method to retrieve the int value from the C array of NSStrings
-(MenuSelectType) menuStringToEnum:(NSString*)strVal
{
    int retVal;
    for(int i=0; i < sizeof(MenuType_toEnum)-1; i++)
    {
        if([(NSString*)MenuType_toEnum[i] isEqual:strVal])
        {
            retVal = i;
            break;
        }
    }
    return (MenuSelectType)retVal;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuOptions count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PopOver Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
	NSString *optionName = [self.menuOptions objectAtIndex:indexPath.row];
	cell.textLabel.text = optionName; 
    
    if (self.menuType == formManagerNoSendMenu && ([optionName isEqualToString:airPrintFormMenuOption] || [optionName isEqualToString:emailFormMenuOption])) {
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[cell textLabel] setTextColor:[UIColor grayColor]];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedAction = [self menuStringToEnum:[menuOptions objectAtIndex:indexPath.row]];
    [[PopOverManager sharedManager] dismissCurrentPopoverController:YES withSelectedOption:self.selectedAction];
}



#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [menuOptions release];
    [super dealloc];
}




@end
