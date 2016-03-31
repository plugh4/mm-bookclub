//
//  Book+CoreDataProperties.h
//  mm-bookclub
//
//  Created by Christopher Serra on 3/31/16.
//  Copyright © 2016 plugh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"
@class Person;
@class Review;

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<Review *> *reviews;
@property (nullable, nonatomic, retain) NSSet<Person *> *people;

@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addReviewsObject:(Review *)value;
- (void)removeReviewsObject:(Review *)value;
- (void)addReviews:(NSSet<Review *> *)values;
- (void)removeReviews:(NSSet<Review *> *)values;

- (void)addPeopleObject:(Person *)value;
- (void)removePeopleObject:(Person *)value;
- (void)addPeople:(NSSet<Person *> *)values;
- (void)removePeople:(NSSet<Person *> *)values;

@end

NS_ASSUME_NONNULL_END
