//
//  Books_VC.m
//  mm-bookclub
//
//  Created by Christopher Serra on 3/31/16.
//  Copyright © 2016 plugh. All rights reserved.
//

#import "Books_VC.h"
#import "Person.h"
#import "AppDelegate.h"
#import "Book.h"

@interface Books_VC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *myBooks;
@property NSManagedObjectContext *moc;
@end

@implementation Books_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));

    // snapshot of Core Data set
    self.myBooks = self.personCore.books.allObjects;
    
    // navbar
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationItem.title = self.personCore.name;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    
}

#pragma mark - Core Data
- (Book *)coreCreateBook:(NSString *)bookTitle {
    NSLog(@"[%@ %@] \"%@\"", self.class, NSStringFromSelector(_cmd), bookTitle);
    Book *bCore = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.moc];
    bCore.title = bookTitle;
    return bCore;
}
-(Book *)coreReadBook:(NSString *)bookTitle {
    NSLog(@"[%@ %@] \"%@\"", self.class, NSStringFromSelector(_cmd), bookTitle);
    
    if (!self.moc) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        self.moc = appDelegate.managedObjectContext;
    }
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
    req.predicate = [NSPredicate predicateWithFormat:@"title == %@", bookTitle];
    
    NSError *error;
    NSArray *results = [self.moc executeFetchRequest:req error:&error];
    if (!error) {
        NSLog(@"core load ok: %i results", results.count);
    } else {
        NSLog(@"core load error: %@", error);
    }
    
    if (results.count == 0) { return nil; }
    return results[0];
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


#pragma mark - UITableView - Select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    
    //Person *pCore = self.peopleCore[indexPath.row];
//    [self performSegueWithIdentifier:@"toBooks" sender:pCore];
}

- (void)reloadData {
    self.myBooks = self.personCore.books.allObjects;
    [self.tableView reloadData];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"[%@ %@] \"%@\"", self.class, NSStringFromSelector(_cmd), textField.text);

    // add book
    [self addBook:textField.text];
    [self reloadData];

    // clear text field
    textField.text = @"";

    return YES;
}
- (void)addBook:(NSString *)t {

    // check if book exists
    Book *bookCore = [self coreReadBook:t];

    // if not exist, create book object
    if (!bookCore) {
        bookCore = [self coreCreateBook:t];
        NSLog(@"new book \"%@\"", t);
    } else {
        NSLog(@"loaded book \"%@\"", t);
    }

    // add to pCore.books list
    [self.personCore addBooksObject:bookCore];
    
    // save to core
    [self saveToCore];
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myBooks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@] %lu", self.class, NSStringFromSelector(_cmd), indexPath.row);

    Book *bCore = self.myBooks[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
    cell.textLabel.text = bCore.title;
    return cell;
}

@end
