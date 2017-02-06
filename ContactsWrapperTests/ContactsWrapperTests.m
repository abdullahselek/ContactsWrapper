//
//  ContactsWrapperTests.m
//  ContactsWrapperTests
//
//  Created by Abdullah Selek on 01/08/16.
//  Copyright © 2016 Abdullah Selek. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Abdullah Selek
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Quick/Quick.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <JPSimulatorHacks/JPSimulatorHacks.h>
#import "ContactsWrapper.h"

static NSString *const CWErrorDomain = @"TEST_DOMAIN";
static NSString *const CWContactGivenName = @"TEST_NAME";
static NSString *const CWContactFamilyName = @"TEST_FAMILY_NAME";
static NSString *const CWContactUpdateFamilyName = @"FamilyName";
static NSString *const CWContactEmailAddress = @"test@email.com";
static NSString *const CWContactGivenNameDelete = @"CONTACT";
static NSString *const CWContactFamilyNameDelete = @"DELETE";
static NSString *const CWContactGroupName = @"TEST_GROUP";

@interface ContactsWrapper (Test)

@property (nonatomic) CNContactStore *contactStore;

- (void)fetchContactsWithStore:(CNContactStore *)store
                           key:(NSArray<id<CNKeyDescriptor>> *)keys
               completionBlock:(void (^)(NSArray<CNContact *> *contacts, NSError *error))completionBlock;
- (void)getAuthorizationWithCompletionBlock:(void (^)(BOOL isSuccess, NSError *error))completionBlock;

@end

@interface ContactsWrapperTests : QuickSpec

@property (nonatomic) ContactsWrapper *contactsWrapper;
@property (nonatomic) CNMutableContact *contact;
@property (nonatomic) CNMutableGroup *group;

@end

@implementation ContactsWrapperTests

- (void)spec
{
    describe(@"Contacts Wrapper", ^ {
        beforeSuite(^{
            [JPSimulatorHacks grantAccessToAddressBook];
        });
        context(@"Initialization", ^ {
            beforeEach(^{
                self.contactsWrapper = [ContactsWrapper sharedInstance];
            });
            it(@"if success", ^ {
                expect(self.contactsWrapper).notTo.beNil();
                expect(self.contactsWrapper.contactStore).notTo.beNil();
            });
        });
        context(@"Check Get Contacts", ^ {
            it(@"Return any valid contact", ^ {
                [[ContactsWrapper sharedInstance] getContacts:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check Get Contacts with keys", ^ {
            it(@"Return any valid contact", ^ {
                [[ContactsWrapper sharedInstance] getContactsWithKeys:@[] completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check Fetch Contacts with store and key", ^ {
            it(@"Return any valid contact", ^ {
                CNContactStore *contactStore = [ContactsWrapper sharedInstance].contactStore;
                [[ContactsWrapper sharedInstance] fetchContactsWithStore:contactStore key:@[] completionBlock:^(NSArray<CNContact *> *contacts, NSError *error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Save contact success", ^ {
            it(@"Should return true", ^ {
                self.contact = [CNMutableContact new];
                self.contact.givenName = CWContactGivenName;
                self.contact.familyName = CWContactFamilyName;
                CNLabeledValue *email = [[CNLabeledValue alloc] initWithLabel:CNLabelEmailiCloud value:CWContactEmailAddress];
                self.contact.emailAddresses = @[email];
                [[ContactsWrapper sharedInstance] saveContact:self.contact completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check Get Contacts with given name", ^ {
            it(@"Return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getContactsWithGivenName:CWContactGivenName completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check Get Contacts with given and family name", ^ {
            it(@"Return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getContactsWithGivenName:CWContactGivenName familyName:CWContactFamilyName completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Update contact success", ^ {
            it(@"Should return success", ^ {
                self.contact.familyName = CWContactUpdateFamilyName;
                [[ContactsWrapper sharedInstance] updateContact:self.contact completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check Get Contacts with email address", ^ {
            it(@"Return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getContactsWithEmailAddress:CWContactEmailAddress completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check delete contact", ^ {
            __block CNMutableContact *contact;
            beforeEach(^ {
                contact = [CNMutableContact new];
                contact.givenName = CWContactGivenNameDelete;
                contact.familyName = CWContactFamilyNameDelete;
                [[ContactsWrapper sharedInstance] saveContact:contact completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
            it(@"Should delete given contact", ^ {
                [[ContactsWrapper sharedInstance] deleteContact:contact completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check get authorization", ^ {
            it(@"Should authorized", ^ {
                CNContactStore *mockContactStore = OCMClassMock([CNContactStore class]);
                OCMStub([(id) mockContactStore authorizationStatusForEntityType:
                         CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
                [[ContactsWrapper sharedInstance] getAuthorizationWithCompletionBlock:^(BOOL isSuccess, NSError *error) {
                    expect(isSuccess).beTruthy();
                }];
                OCMStub([(id) mockContactStore stopMocking]);
            });
        });
        context(@"Check get authorization", ^ {
            it(@"Should also be authorized", ^ {
                CNContactStore *mockContactStore = OCMClassMock([CNContactStore class]);
                OCMStub([(id) mockContactStore authorizationStatusForEntityType:
                         CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
                [[ContactsWrapper sharedInstance] getAuthorizationWithCompletionBlock:^(BOOL isSuccess, NSError *error) {
                    expect(isSuccess).beTruthy();
                }];
                OCMStub([(id) mockContactStore stopMocking]);
            });
        });
        context(@"Check add group", ^ {
            beforeEach(^ {
                self.group = [CNMutableGroup new];
                self.group.name = CWContactGroupName;
            });
            it(@"Should be success", ^ {
                [[ContactsWrapper sharedInstance] addGroup:self.group completionBlock:^(BOOL isSuccess, NSError * _Nonnull error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check add member to group", ^ {
            it(@"Member should be added", ^ {
                [[ContactsWrapper sharedInstance] addGroupMember:self.contact
                                                           group:self.group
                                                 completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check get groups", ^ {
            it(@"Should return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getGroupsWithCompletionBlock:^(NSArray<CNGroup *> * _Nullable groups, NSError * _Nullable error) {
                    expect(groups).notTo.beNil();
                }];
            });
        });
        context(@"Check delete group", ^ {
            beforeEach(^ {
                self.group = [CNMutableGroup new];
                self.group.name = CWContactGroupName;
            });
            it(@"Should be succeed", ^ {
                [[ContactsWrapper sharedInstance] deleteGroup:self.group
                                              completionBlock:^(BOOL isSuccess, NSError * _Nonnull error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check update group", ^{
            beforeEach(^ {
                self.group = [CNMutableGroup new];
                self.group.name = CWContactGroupName;
                [[ContactsWrapper sharedInstance] addGroup:self.group completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    if (error) {
                        failure(@"Update group not ready");
                    }
                }];
            });
            it(@"Should be succeed", ^{
                self.group.name = @"UpdatedGroup";
                [[ContactsWrapper sharedInstance] updateGroup:self.group completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check add group members", ^{
            beforeEach(^ {
                self.group = [CNMutableGroup new];
                self.group.name = CWContactGroupName;
                [[ContactsWrapper sharedInstance] addGroup:self.group completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    if (error) {
                        failure(@"Update group not ready");
                    }
                }];
            });
            it(@"Should add given members to group", ^{
                CNMutableContact *contact1 = [CNMutableContact new];
                contact1.givenName = @"contact";
                contact1.familyName = @"1";
                CNMutableContact *contact2 = [CNMutableContact new];
                contact1.givenName = @"contact";
                contact1.familyName = @"2";
                [[ContactsWrapper sharedInstance] addGroupMembers:@[contact1, contact2] group:self.group completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check get containers", ^{
            it(@"Shold return containers", ^{
                [[ContactsWrapper sharedInstance] getContainers:^(NSArray<CNContainer *> * _Nullable containers, NSError * _Nullable error) {
                    expect(error).to.beNil();
                    expect(containers).notTo.beNil();
                    expect(containers).to.haveCount(1);
                }];
            });
        });
    });
}

@end
