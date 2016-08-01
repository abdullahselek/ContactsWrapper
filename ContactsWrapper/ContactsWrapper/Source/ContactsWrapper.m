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

- (void)getContactsWithKeys:(NSArray<id<CNKeyDescriptor>> *)keys completionBlock:(nullable void (^)(NSArray<CNContact *> * _Nullable contacts, NSError  * _Nullable error))completionBlock
{
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
    {
        [self takeContactsWithStore:self.contactStore key:keys completionBlock:completionBlock];
    }
    else
    {
        [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted)
            {
                [self takeContactsWithStore:self.contactStore key:keys completionBlock:completionBlock];
            }
            else
            {
                completionBlock(nil, error);
            }
        }];
    }
}

- (void)takeContactsWithStore:(CNContactStore *)store key:(NSArray<id<CNKeyDescriptor>> *)keys completionBlock:(void (^)(NSArray<CNContact *> *contacts, NSError *error))completionBlock

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
        completionBlock(nil, contactError);
    }
    else
    {
        completionBlock(contacts, nil);
    }
}

@end
