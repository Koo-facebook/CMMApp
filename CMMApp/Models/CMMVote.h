//
//  CMMVote.h
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CMMVoteAPIManager.h"


@interface CMMVote : PFObject<PFSubclassing>

@property NSString *_Nonnull language;
@property NSString *_Nonnull partnerId;
@property BOOL *_Nonnull sendConfirmationReminderEmails;
@property NSString *_Nullable collectEmailAddress;
@property NSDate *_Nonnull dateOfBirth;
@property NSString *_Nonnull licenseId;
@property NSString *_Nonnull emailAddress;
@property BOOL *_Nonnull firstRegistration;
@property NSString *_Nonnull homeZipCode;
@property BOOL *_Nonnull usCitizen;
@property BOOL *_Nonnull hasLicense;
@property BOOL *_Nonnull isEighteenOrOlder;
@property NSString *_Nonnull nameTitle;
@property NSString *_Nullable firstName;
@property NSString *_Nullable middleName;
@property NSString *_Nonnull lastName;
@property NSString *_Nullable nameSuffix;
@property NSString *_Nonnull homeAddress;
@property NSString *_Nullable homeUnit;
@property NSString *_Nonnull homeCity;
@property NSString *_Nonnull homeStateId;
@property BOOL *_Nonnull hasMailingAddress;
@property NSString *_Nullable mailingAddress;
@property NSString *_Nullable mailingUnit;
@property NSString *_Nullable mailingCity;
@property NSString *_Nullable mailingStateId;
@property NSString *_Nullable mailingZipCode;
@property NSString *_Nullable race;
@property NSString *_Nullable phone;
@property NSString *_Nullable phoneType;
@property BOOL *_Nonnull changeOfName;
@property NSString *_Nullable previousNameTitle;
@property NSString *_Nullable previousFirstName;
@property NSString *_Nullable previousMiddleName;
@property NSString *_Nullable previousLastName;
@property NSString *_Nullable previousNameSuffix;
@property BOOL *_Nonnull changeOfAddress;
@property NSString *_Nullable previousAddress;
@property NSString *_Nullable previousUnit;
@property NSString *_Nullable previousCity;
@property NSString *_Nullable previousStateId;
@property NSString *_Nullable previousZipCode;
@property BOOL *_Nonnull optInEmail;
@property BOOL *_Nonnull optInSMS;
@property BOOL *_Nonnull optInVolunteer;
@property BOOL *_Nonnull partnerOptInEmail;
@property BOOL *_Nonnull partnerOptInSMS;
@property BOOL *_Nonnull partnerOptInVolunteer;

- (void)registerVoter:(CMMVote *_Nonnull)vote;
    
@end
