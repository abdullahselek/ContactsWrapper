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

@interface ContactsWrapper (Test)

@property (nonatomic) CNContactStore *contactStore;

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
                ContactsWrapper *mockWrapper = OCMClassMock([ContactsWrapper class]);
                CNContact *contact = [[CNContact alloc] init];
                NSArray<CNContact *> *contactArray = @[contact];
                OCMStub([(id) mockWrapper sharedInstance]).andReturn(mockWrapper);
                OCMStub([mockWrapper getContacts:OCMOCK_ANY]).andDo(^(NSInvocation *invocation)
                {
                    void (^completionBlock)(NSArray<CNContact *> *contacts);
                    [invocation getArgument:&completionBlock atIndex:2];
                    completionBlock(contactArray);
                });
                [[ContactsWrapper sharedInstance] getContacts:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
                OCMStub([(id) mockWrapper stopMocking]);
            });
        });
        context(@"Check Get Contacts with keys without authorization", ^{
            it(@"Return any valid contact", ^ {
                ContactsWrapper *mockWrapper = OCMClassMock([ContactsWrapper class]);
                CNContact *contact = [[CNContact alloc] init];
                NSArray<CNContact *> *contactArray = @[contact];
                OCMStub([(id) mockWrapper sharedInstance]).andReturn(mockWrapper);
                OCMStub([mockWrapper getContactsWithKeys:@[] completionBlock:OCMOCK_ANY]).andDo(^(NSInvocation *invocation)
                {
                    void (^completionBlock)(NSArray<CNContact *> *contacts);
                    [invocation getArgument:&completionBlock atIndex:2];
                    completionBlock(contactArray);
                });
                [[ContactsWrapper sharedInstance] getContactsWithKeys:OCMOCK_ANY completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
                OCMStub([(id) mockWrapper stopMocking]);
            });
        });
        context(@"Check Get Contacts with keys without authorization", ^{
            it(@"Return an error", ^ {
                ContactsWrapper *mockWrapper = OCMClassMock([ContactsWrapper class]);
                OCMStub([(id) mockWrapper sharedInstance]).andReturn(mockWrapper);
                NSError *error = [NSError errorWithDomain:@"TEST_DOMAIN" code:204 userInfo:@{}];
                OCMStub([mockWrapper getContactsWithKeys:@[] completionBlock:OCMOCK_ANY]).andDo(^(NSInvocation *invocation)
                {
                    void (^completionBlock)(NSError * error);
                    [invocation getArgument:&completionBlock atIndex:2];
                    completionBlock(error);
                });
                [[ContactsWrapper sharedInstance] getContactsWithKeys:OCMOCK_ANY completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(error).notTo.beNil();
                }];
                OCMStub([(id) mockWrapper stopMocking]);
            });
        });
        context(@"Save contact success", ^ {
            it(@"Should return true", ^ {
                self.contact = [CNMutableContact new];
                self.contact.givenName = @"TEST_NAME";
                self.contact.familyName = @"TEST_FAMILY_NAME";
                [[ContactsWrapper sharedInstance] saveContact:self.contact completionBlock:^(bool isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
        context(@"Check Get Contacts with given name", ^{
            it(@"Return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getContactWithGivenName:@"TEST_NAME" completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Check Get Contacts with given and family name", ^{
            it(@"Return a valid array", ^ {
                [[ContactsWrapper sharedInstance] getContactWithGivenName:@"TEST_NAME" familyName:@"TEST_FAMILY_NAME" completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
                    expect(contacts).notTo.beNil();
                }];
            });
        });
        context(@"Update contact success", ^{
            it(@"Should return success", ^ {
                self.contact.familyName = @"Familyname";
                [[ContactsWrapper sharedInstance] updateContact:self.contact completionBlock:^(bool isSuccess, NSError * _Nullable error) {
                    expect(isSuccess).beTruthy();
                }];
            });
        });
    });
}

@end
