//
//  CMMVote.m
//  CMMApp
//
//  Created by Omar Rasheed on 7/17/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMVote.h"

@implementation CMMVote
    
    @synthesize language;
    @synthesize partnerId;
    @synthesize sendConfirmationReminderEmails;
    @synthesize collectEmailAddress;
    @synthesize dateOfBirth;
    @synthesize licenseId;
    @synthesize emailAddress;
    @synthesize firstRegistration;
    @synthesize homeZipCode;
    @synthesize usCitizen;
    @synthesize hasLicense;
    @synthesize isEighteenOrOlder;
    @synthesize nameTitle;
    @synthesize firstName;
    @synthesize middleName;
    @synthesize lastName;
    @synthesize nameSuffix;
    @synthesize homeAddress;
    @synthesize homeUnit;
    @synthesize homeCity;
    @synthesize homeStateId;
    @synthesize hasMailingAddress;
    @synthesize mailingAddress;
    @synthesize mailingUnit;
    @synthesize mailingCity;
    @synthesize mailingStateId;
    @synthesize mailingZipCode;
    @synthesize race;
    @synthesize phone;
    @synthesize phoneType;
    @synthesize changeOfName;
    @synthesize previousNameTitle;
    @synthesize previousFirstName;
    @synthesize previousMiddleName;
    @synthesize previousLastName;
    @synthesize previousNameSuffix;
    @synthesize changeOfAddress;
    @synthesize previousAddress;
    @synthesize previousUnit;
    @synthesize previousCity;
    @synthesize previousStateId;
    @synthesize previousZipCode;
    @synthesize optInEmail;
    @synthesize optInSMS;
    @synthesize optInVolunteer;
    @synthesize partnerOptInEmail;
    @synthesize partnerOptInSMS;
    @synthesize partnerOptInVolunteer;
    
    + (nonnull NSString *)parseClassName {
        return @"CMMVote";
    }
    
    - (void)registerVoter:(CMMVote *_Nonnull)vote {
        
    }
    
@end
