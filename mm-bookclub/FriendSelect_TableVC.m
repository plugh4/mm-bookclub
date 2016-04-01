//
//  FriendSelect_TableVC.m
//  mm-bookclub
//
//  Created by Christopher Serra on 3/30/16.
//  Copyright © 2016 plugh. All rights reserved.
//

#import "FriendSelect_TableVC.h"
#import "AppDelegate.h"
#import "Person.h"



@interface FriendSelect_TableVC ()
@property NSManagedObjectContext *moc;
@property NSMutableArray *peopleCore;
@end


@implementation FriendSelect_TableVC

- (void)viewDidLoad {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    [super viewDidLoad];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = appDelegate.managedObjectContext;

    // fetch from Core
    [self loadFromCore];
    
    // if empty, import from plist
    if (self.peopleCore.count == 0) {
        NSMutableArray *people2 = [self importReadersFromPlist].mutableCopy;
        
        for (NSString *name in people2) {
            NSLog(@"   Reader: %@", name);
            // create Core object
            Person *pCore = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.moc];
            pCore.name = name;
            pCore.isFriend = [NSNumber numberWithBool:NO];
            // add to array
            [self.peopleCore addObject:pCore];
        }
        [self saveToCore];
    }
}
-(void)loadFromCore {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));

    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    req.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    //    r.predicate = [NSPredicate predicateWithFormat:@"age >= 60 and budget >= 250"];
    
    NSError *error;
    self.peopleCore = [[self.moc executeFetchRequest:req error:&error] mutableCopy];
    if (!error) {
        NSLog(@"core load ok");
    } else {
        NSLog(@"core load error: %@", error);
    }
}
-(void)saveToCore {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    // save to Core
    NSError *error;
    if ([self.moc save:&error]) {
        NSLog(@"core save ok");
    } else {
        NSLog(@"core save error: %@", error);
    }
}

- (NSArray *)importReadersFromPlist {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    NSString *path = [[NSBundle mainBundle] pathForResource:@"readers" ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"plist file exists");
    } else {
        NSLog(@"plist file does not exist!");
    }
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    NSLog(@"plist imported with %lu items", [array count]);
    return array;
}



#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"[%@ %@: %lu]", self.class, NSStringFromSelector(_cmd), self.peopleCore.count);
    return self.peopleCore.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@] %lu", self.class, NSStringFromSelector(_cmd), indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath];
    Person *pCore = self.peopleCore[indexPath.row];
    cell.textLabel.text = pCore.name;
    
    // tell tableView about selections
    if (pCore.isFriend.boolValue) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - Multiple Selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    // set boolean
    Person *pCore = self.peopleCore[indexPath.row];
    pCore.isFriend = [NSNumber numberWithBool:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    // set boolean
    Person *pCore = self.peopleCore[indexPath.row];
    pCore.isFriend = [NSNumber numberWithBool:NO];
}
- (IBAction)onDonePressed:(UIBarButtonItem *)sender {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));

    // get selected cells
    NSArray *selectedPaths = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedPaths) {
        Person *pCore = self.peopleCore[indexPath.row];
        NSLog(@"  selected: %@", pCore.name);
    }
    
    // save to Core (before exit segue)
    [self saveToCore];
    
    // exit to FriendList
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}

@end
