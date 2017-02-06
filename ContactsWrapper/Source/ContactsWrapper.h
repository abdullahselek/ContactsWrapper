//
//  ContactsWrapper.h
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

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

NS_ASSUME_NONNULL_BEGIN

@interface ContactsWrapper : NSObject

/**
  * Singleton for Contacts Wrapper
  *
  * @return Instance
 */
+ (instancetype)sharedInstance;

/**
  * Get All Contacts with their Family Name, Given Name, Phone Numbers, Image Data
  *
  * @param containerId Container id
  * @param completionBlock Nullable contacts and error
 */
- (void)getContactsWithContainerId:(nullable NSString *)containerId completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError  * _Nullable error))completionBlock;

/**
  * Get All Contacts with given keys
  *
  * @param keys Keys for filling contact data
  * @param containerId Container id
  * @param completionBlock Nullable contacts and error
 */
- (void)getContactsWithKeys:(NSArray<id<CNKeyDescriptor>> *)keys
                containerId:(nullable NSString *)containerId
            completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError  * _Nullable error))completionBlock;

/**
  * Save given contact
  *
  * @param contact Contact object to save
  * @param containerId Container id
  * @param completionBlock isSuccess and error
 */
- (void)saveContact:(CNMutableContact *)contact
        containerId:(nullable NSString *)containerId
    completionBlock:(void (^)(BOOL isSuccess, NSError *error))completionBlock;

/**
  * Get Contacts with given name
  *
  * @param givenName Given name
  * @param completionBlock Nullable contacts and error
 */
- (void)getContactsWithGivenName:(NSString *)givenName
                 completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error))completionBlock;

/**
 * Get Contacts with given name
 *
 * @param givenName Given name
 * @param familyName Family name
 * @param completionBlock Nullable contacts and error
 */
- (void)getContactsWithGivenName:(NSString *)givenName
                      familyName:(NSString *)familyName
                 completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error))completionBlock;

/**
  * Update given contact
  *
  * @param completionBlock isSuccess and error
 */
- (void)updateContact:(CNMutableContact *)contact
      completionBlock:(void (^)(BOOL isSuccess, NSError * _Nullable error))completionBlock;

/**
  * Get contacts with given email address
  *
  * @param emailAddress Email address
  * @param completionBlock Nullable contacts and error
 */
- (void)getContactsWithEmailAddress:(NSString *)emailAddress
                    completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error))completionBlock;

/**
  * Delete given contact
  *
  * @param completionBlock isSuccess and error
 */
- (void)deleteContact:(CNContact *)contact
      completionBlock:(void (^)(BOOL isSuccess, NSError * _Nullable error))completionBlock;

/**
  * Add given group to contacts list
  *
  * @param group Group to add
  * @param containerId Container id
  * @param completionBlock isSuccess and error
 */
- (void)addGroup:(CNMutableGroup *)group
     containerId:(nullable NSString *)containerId
 completionBlock:(void (^)(BOOL isSuccess, NSError * _Nullable error))completionBlock;

/**
  * Delete given group
  *
  * @param completionBlock isSuccess and error
 */
- (void)deleteGroup:(CNMutableGroup *)group
    completionBlock:(void (^)(BOOL isSuccess, NSError * _Nullable error))completionBlock;

/**
  * Update given group
  *
  * @param completionBlock isSuccess and error
 */
- (void)updateGroup:(CNMutableGroup *)group
    completionBlock:(void (^)(BOOL isSuccess, NSError * _Nullable error))completionBlock;

/**
  * Add given contact to given group
  *
  * @param contact Contact will be added to group
  * @param group Group which contact will be added in
  * @param completionBlock isSuccess and error
 */
- (void)addGroupMember:(CNContact *)contact
                 group:(CNGroup *)group
       completionBlock:(void (^)(BOOL isSuccess, NSError * _Nullable error))completionBlock;

/**
  * Add given contacts to given group
  *
  * @param contacts Contacts will be added to group
  * @param group Group which contact will be added in
  * @param completionBlock isSuccess and error
 */
- (void)addGroupMembers:(NSArray<CNMutableContact *> *)contacts
                  group:(CNGroup *)group
        completionBlock:(void (^)(BOOL isSuccess, NSError * _Nullable error))completionBlock;

/**
  * Get groups
  *
  * @param containerId Container id
  * @param completionBlock Nullable groups and error
 */
- (void)getGroupsWithContainerId:(nullable NSString *)containerId completionBlock:(void (^)(NSArray<CNGroup *> * _Nullable groups, NSError * _Nullable error))completionBlock;

/**
  * Get containers
  *
  * @param completionBlock Nullable container and error
 */
- (void)getContainers:(void (^)(NSArray<CNContainer *> * _Nullable containers, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
