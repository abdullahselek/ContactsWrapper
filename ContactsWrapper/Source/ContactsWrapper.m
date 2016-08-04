//
//  ContactsWrapper.m
//  ContactsWrapper
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

#import "ContactsWrapper.h"

@interface ContactsWrapper ()

@property (nonatomic) CNContactStore *contactStore;

@end

@implementation ContactsWrapper

+ (instancetype)sharedInstance
{
    static ContactsWrapper *contactsWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contactsWrapper = [[ContactsWrapper alloc] init];
    });
    return contactsWrapper;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _contactStore = [CNContactStore new];
    }
    return self;
}

- (void)getContacts:(nullable void (^)(NSArray<CNContact *> * _Nullable contacts, NSError  * _Nullable error))completionBlock;
{
    [self getContactsWithKeys:@[] completionBlock:completionBlock];
}

- (void)getContactsWithKeys:(NSArray<id<CNKeyDescriptor>> *)keys
            completionBlock:(nullable void (^)(NSArray<CNContact *> * _Nullable contacts, NSError  * _Nullable error))completionBlock
{
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
    {
        [self fetchContactsWithStore:self.contactStore key:keys completionBlock:completionBlock];
    }
    else
    {
        [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted)
            {
                [self fetchContactsWithStore:self.contactStore key:keys completionBlock:completionBlock];
            }
            else
            {
                BLOCK_EXEC(completionBlock, nil, error);
            }
        }];
    }
}

- (void)fetchContactsWithStore:(CNContactStore *)store
                          key:(NSArray<id<CNKeyDescriptor>> *)keys
              completionBlock:(void (^)(NSArray<CNContact *> *contacts, NSError *error))completionBlock

{
    if (keys.count == 0) {
        keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
    }
    NSString *containerId = store.defaultContainerIdentifier;
    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
    NSError *contactError;
    NSArray<CNContact *> *contacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&contactError];
    if (contactError)
    {
        BLOCK_EXEC(completionBlock, nil, contactError)
    }
    else
    {
        BLOCK_EXEC(completionBlock, contacts, nil);
    }
}

- (void)saveContact:(CNMutableContact *)contact completionBlock:(void (^)(bool isSuccess, NSError *error))completionBlock
{
    CNSaveRequest *saveRequest = [CNSaveRequest new];
    [saveRequest addContact:contact toContainerWithIdentifier:self.contactStore.defaultContainerIdentifier];
    NSError *saveContactError;
    [self.contactStore executeSaveRequest:saveRequest error:&saveContactError];
    if (saveContactError)
    {
        BLOCK_EXEC(completionBlock, NO, saveContactError);
    }
    else
    {
        BLOCK_EXEC(completionBlock, YES, nil);
    }
}

- (void)getContactsWithGivenName:(NSString *)givenName completionBlock:(void (^)(NSArray<CNContact *> *contacts, NSError *error))completionBlock
{
    [self fetchContactsWithGivenName:givenName completionBlock:completionBlock];
}

- (void)getContactsWithGivenName:(NSString *)givenName
                     familyName:(NSString *)familyName
                completionBlock:(nullable void (^)(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error))completionBlock
{
    [self fetchContactsWithGivenName:givenName completionBlock:^(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error) {
        if (error)
        {
            BLOCK_EXEC(completionBlock, nil, error);
        }
        else
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"familyName == %@", familyName];
            contacts = [contacts filteredArrayUsingPredicate:predicate];
            BLOCK_EXEC(completionBlock, contacts, nil);
        }
    }];
}

- (void)fetchContactsWithGivenName:(NSString *)givenName completionBlock:(nullable void (^)(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error))completionBlock
{
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:givenName];
    NSError *error;
    NSArray<CNContact *> *contacts = [self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:@[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey] error:&error];
    if (error)
    {
        BLOCK_EXEC(completionBlock, nil, error);
    }
    else
    {
        BLOCK_EXEC(completionBlock, contacts, nil);
    }
}

- (void)updateContact:(CNMutableContact *)contact completionBlock:(nullable void (^)(bool isSuccess, NSError * _Nullable error))completionBlock
{
    CNSaveRequest *saveRequest = [CNSaveRequest new];
    [saveRequest updateContact:contact];
    NSError *updateContactError;
    [self.contactStore executeSaveRequest:saveRequest error:&updateContactError];
    if (updateContactError)
    {
        BLOCK_EXEC(completionBlock, NO, updateContactError);
    }
    else
    {
        BLOCK_EXEC(completionBlock, YES, nil);
    }
}

- (void)getContactsWithEmailAddress:(NSString *)emailAddress
                    completionBlock:(void (^)(NSArray<CNContact *> *contacts, NSError *error))completionBlock
{
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:emailAddress];
    NSError *error;
    NSArray<CNContact *> *contacts = [self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:@[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey] error:&error];
    if (error)
    {
        BLOCK_EXEC(completionBlock, nil, error);
    }
    else
    {
        BLOCK_EXEC(completionBlock, contacts, nil);
    }
}

@end
