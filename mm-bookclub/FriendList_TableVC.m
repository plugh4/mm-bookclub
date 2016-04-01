//
//  FriendList_TableVC.m
//  mm-bookclub
//
//  Created by Christopher Serra on 3/30/16.
//  Copyright © 2016 plugh. All rights reserved.
//

#import "FriendList_TableVC.h"
#import "AppDelegate.h"
#import "Person.h"
#import "Books_VC.h"

@interface FriendList_TableVC ()
@property NSManagedObjectContext *moc;
@property NSArray *peopleCore;
@end


@implementation FriendList_TableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));

    // init Core Data
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = appDelegate.managedObjectContext;
    // sqlite location
    NSURL *url = appDelegate.applicationDocumentsDirectory;
    NSLog(@"sqlite dir = \n%@", url);

    // import from Core
    [self loadFromCore];
    

    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    
    [self loadFromCore];
    [self.tableView reloadData];
}


#pragma mark - Core Data
-(void)loadFromCore {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    req.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    req.predicate = [NSPredicate predicateWithFormat:@"isFriend == TRUE"];
    
    NSError *error;
    self.peopleCore = [[self.moc executeFetchRequest:req error:&error] mutableCopy];
    if (!error) {
        NSLog(@"core load ok");
    } else {
        NSLog(@"core load error: %@", error);
    }
}


#pragma mark - Navigation
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    Person *pCore = self.peopleCore[indexPath.row];
    [self performSegueWithIdentifier:@"toBooks" sender:pCore];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    if ([segue.identifier isEqualToString:@"toBooks"]) {
        Books_VC *dstVC = [segue destinationViewController];
        dstVC.personCore = sender;
    }
}


#pragma mark - UITableView - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    return self.peopleCore.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@] %lu", self.class, NSStringFromSelector(_cmd), indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    Person *pCore = self.peopleCore[indexPath.row];
    cell.textLabel.text = pCore.name;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
