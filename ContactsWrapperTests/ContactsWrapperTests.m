//
//  ContactsWrapperTests.m
//  ContactsWrapperTests
//
//  Created by Abdullah Selek on 01/08/16.
//  Copyright © 2016 Abdullah Selek. All rights reserved.
//

#import <Quick/Quick.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "ContactsWrapper.h"

static NSString *const CWErrorDomain = @"TEST_DOMAIN";
static NSString *const CWContactGivenName = @"TEST_NAME";
static NSString *const CWContactFamilyName = @"TEST_FAMILY_NAME";
static NSString *const CWContactUpdateFamilyName = @"FamilyName";
static NSString *const CWContactEmailAddress = @"test@email.com";
static NSString *const CWContactGivenNameDelete = @"CONTACT";
static NSString *const CWContactFamilyNameDelete = @"DELETE";

@interface ContactsWrapper (Test)

@property (nonatomic) CNContactStore *contactStore;

- (void)fetchContactsWithStore:(CNContactStore *)store
                           key:(NSArray<id<CNKeyDescriptor>> *)keys
               completionBlock:(void (^)(NSArray<CNContact *> *contacts, NSError *error))completionBlock;
- (void)getAuthorizationWithCompletionBlock:(void (^)(bool isSuccess, NSError *error))completionBlock;

@end

@interface ContactsWrapperTests : QuickSpec

@property (nonatomic) ContactsWrapper *contactsWrapper;
@property (nonatomic) CNMutableContact *contact;

@end

@implementation ContactsWrapperTests

- (void)spec
{
    describe(@"Contacts Wrapper", ^{
        beforeEach(^{
            self.contactsWrapper = [ContactsWrapper sharedInstance];
        });
        context(@"Initialization", ^{
            it(@"if success", ^ {
                expect(self.contactsWrapper).notTo.beNil();
                expect(self.contactsWrapper.contactStore).notTo.beNil();
            });
        });
        context(@"Check Get Contacts", ^{
            it(@"Return any valid contact", ^ {
                [[ContactsWrapper sharedInstance] getContacts:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check Get Contacts with keys", ^{
            it(@"Return any valid contact", ^ {
                [[ContactsWrapper sharedInstance] getContactsWithKeys:@[] completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check Fetch Contacts with store and key", ^{
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
                [[ContactsWrapper sharedInstance] saveContact:self.contact completionBlock:^(bool isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check Get Contacts with given name", ^{
            it(@"Return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getContactsWithGivenName:CWContactGivenName completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check Get Contacts with given and family name", ^{
            it(@"Return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getContactsWithGivenName:CWContactGivenName familyName:CWContactFamilyName completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Update contact success", ^{
            it(@"Should return success", ^ {
                self.contact.familyName = CWContactUpdateFamilyName;
                [[ContactsWrapper sharedInstance] updateContact:self.contact completionBlock:^(bool isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check Get Contacts with email address", ^{
            it(@"Return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getContactsWithEmailAddress:CWContactEmailAddress completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check delete contact", ^{
            __block CNMutableContact *contact;
            beforeEach(^ {
                contact = [CNMutableContact new];
                contact.givenName = CWContactGivenNameDelete;
                contact.familyName = CWContactFamilyNameDelete;
                [[ContactsWrapper sharedInstance] saveContact:contact completionBlock:^(bool isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
            it(@"Should delete given contact", ^ {
                [[ContactsWrapper sharedInstance] deleteContact:contact completionBlock:^(bool isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check get authorization", ^{
            it(@"Should authorized", ^ {
                CNContactStore *mockContactStore = OCMClassMock([CNContactStore class]);
                OCMStub([(id) mockContactStore authorizationStatusForEntityType:
                         CNEntityTypeContacts]).andReturn(CNAuthorizationStatusAuthorized);
                [[ContactsWrapper sharedInstance] getAuthorizationWithCompletionBlock:^(bool isSuccess, NSError *error) {
                    expect(isSuccess).beTruthy();
                }];
                OCMStub([(id) mockContactStore stopMocking]);
            });
        });
        context(@"Check get authorization", ^{
            it(@"Should also be authorized", ^ {
                CNContactStore *mockContactStore = OCMClassMock([CNContactStore class]);
                OCMStub([(id) mockContactStore authorizationStatusForEntityType:
                         CNEntityTypeContacts]).andReturn(CNAuthorizationStatusDenied);
                [[ContactsWrapper sharedInstance] getAuthorizationWithCompletionBlock:^(bool isSuccess, NSError *error) {
                    expect(isSuccess).beTruthy();
                }];
                OCMStub([(id) mockContactStore stopMocking]);
            });
        });
    });
}

@end
