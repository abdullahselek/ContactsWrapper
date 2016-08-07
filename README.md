![Build Status](https://travis-ci.org/abdullahselek/ContactsWrapper.svg?branch=master)
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ContactsWrapper.svg)

# ContactsWrapper
Contacts wrapper for iOS 9 or upper with Objective-C

# Requirements
iOS 9.0+

# CocoaPods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
	
	$ gem install cocoapods

To integrate ASCollectionView into your Xcode project using CocoaPods, specify it in your Podfile:

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '9.0'
	use_frameworks!

	target '<Your Target Name>' do
    	pod 'ContactsWrapper', '0.0.3'
	end

Then, run the following command:

	$ pod install

# Available methods
### Get all contacts if available with CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey descriptors
	- (void)getContacts:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError  * _Nullable error))completionBlock
	
### Get all contacts with given key descriptors
	- (void)getContactsWithKeys:(NSArray<id<CNKeyDescriptor>> *)keys
            completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError  * _Nullable error))completionBlock

### Saves given contact
	- (void)saveContact:(CNMutableContact *)contact
    completionBlock:(void (^)(bool isSuccess, NSError * _Nullable error))completionBlock

### Get contacts with given name
	- (void)getContactsWithGivenName:(NSString *)givenName
                 completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error))completionBlock

### Get contacts with given and family name
	- (void)getContactsWithGivenName:(NSString *)givenName
                     familyName:(NSString *)familyName
                completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error))completionBlock

### Updates given contact
    - (void)updateContact:(CNMutableContact *)contact
      completionBlock:(void (^)(bool isSuccess, NSError * _Nullable error))completionBlock

### Get contacts with given email address
	- (void)getContactsWithEmailAddress:(NSString *)emailAddress
                    completionBlock:(void (^)(NSArray<CNContact *> * _Nullable contacts, NSError * _Nullable error))completionBlock

### Delete given contact
	- (void)deleteContact:(CNMutableContact *)contact
      completionBlock:(void (^)(bool isSuccess, NSError * _Nullable error))completionBlock

### Add given group to contacts list
	- (void)addGroup:(CNMutableGroup *)group
 		completionBlock:(void (^)(bool isSuccess, NSError * _Nullable error))completionBlock

### Add given member to given group
	- (void)addGroupMember:(CNContact *)contact
                 group:(CNGroup *)group
       completionBlock:(void (^)(bool isSuccess, NSError * _Nullable error))completionBlock

### Fething groups
	- (void)getGroupsWithCompletionBlock:(void (^)(NSArray<CNGroup *> * _Nullable groups, NSError * _Nullable error))completionBlock

# License

The MIT License (MIT)

Copyright (c) 2016 Abdullah Selek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.