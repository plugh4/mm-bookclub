//
//  ReviewsVC.m
//  mm-bookclub
//
//  Created by Christopher Serra on 3/31/16.
//  Copyright © 2016 plugh. All rights reserved.
//

#import "ReviewsVC.h"
#import "AppDelegate.h"
#import "Book.h"
#import "Review.h"


@interface ReviewsVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property NSArray *myReviews;
@end


@implementation ReviewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));

    // navbar
    self.navigationItem.title = self.bookCore.title;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    [self reloadData];
}


#pragma mark - Core Data
- (void)reloadData {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    // snapshot of Core Data set
    self.myReviews = self.bookCore.reviews.allObjects;
    NSLog(@"%@ has %i reviews", self.bookCore.title, self.myReviews.count);
    [self.tableView reloadData];
}
- (void) initMoc {
    if (!self.moc) {
        NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        self.moc = appDelegate.managedObjectContext;
    }
}
-(void)saveToCore {
    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    NSError *error;
    if (![self.moc save:&error]) { NSLog(@"core save error: %@", error); }
}


#pragma mark - New Review
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"[%@ %@] \"%@\"", self.class, NSStringFromSelector(_cmd), textField.text);

    // add to Core + self
    [self addReview:textField.text];
    [self reloadData];
    
    // clear text field
    textField.text = @"";
    return YES;
}
- (void)addReview:(NSString *)t {
    NSLog(@"[%@ %@] \"%@\"", self.class, NSStringFromSelector(_cmd), t);
    Review *reviewCore = [self coreCreateReview:t];
    [self.bookCore addReviewsObject:reviewCore];
    [self saveToCore];
}
- (Review *)coreCreateReview:(NSString *)t {
    NSLog(@"[%@ %@] \"%@\"", self.class, NSStringFromSelector(_cmd), t);
    [self initMoc];
    Review *r = [NSEntityDescription insertNewObjectForEntityForName:@"Review" inManagedObjectContext:self.moc];
    r.text = t;
    return r;
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myReviews.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@] %i", self.class, NSStringFromSelector(_cmd), indexPath.row);

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    Review *rCore = self.myReviews[indexPath.row];
    cell.textLabel.text = rCore.text;
    return cell;
}


@end
