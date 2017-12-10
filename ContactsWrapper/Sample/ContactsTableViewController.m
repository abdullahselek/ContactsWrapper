//
//  ContactsTableViewController.m
//  ContactsWrapper
//
//  Created by Abdullah Selek on 06/08/16.
//  Copyright © 2016 Abdullah Selek. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactsWrapper.h"

@interface ContactsTableViewController ()

@property (nonatomic) NSMutableArray<CNContact *> *contacts;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ContactsWrapper sharedInstance] getContactsWithContainerId:nil completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
        if (contacts)
        {
            self.contacts = [NSMutableArray arrayWithArray:contacts];
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell" forIndexPath:indexPath];
    CNContact *contact = self.contacts[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CNContact *selectedContact = self.contacts[indexPath.row];
        [[ContactsWrapper sharedInstance] deleteContact:selectedContact completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
            if (isSuccess)
            {
                [self.contacts removeObject:selectedContact];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                NSLog(@"Delete contact failed with error : %@", error.localizedDescription);
            }
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
