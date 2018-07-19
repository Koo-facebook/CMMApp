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

+(instancetype _Nullable)createVote:(NSDictionary *_Nonnull)voteDictionary {
    CMMVote *newVote = [CMMVote new];
    newVote.language = @"en";
    newVote.partnerId = @"37362";
    newVote.sendConfirmationReminderEmails = (BOOL)voteDictionary[@"sendConfirmationReminderEmails"];
    newVote.collectEmailAddress = voteDictionary[@"collectEmailAddress"];
    newVote.dateOfBirth = voteDictionary[@"dateOfBirth"];
    newVote.licenseId = voteDictionary[@"licenseId"];
    newVote.emailAddress = voteDictionary[@"emailAddress"];
    newVote.firstRegistration = (BOOL)voteDictionary[@"firstRegistration"];
    newVote.homeZipCode = voteDictionary[@"homeZipCode"];
    newVote.usCitizen = (BOOL)voteDictionary[@"usCitizen"];
    newVote.hasLicense = (BOOL)voteDictionary[@"hasLicense"];
    newVote.isEighteenOrOlder = (BOOL)voteDictionary[@"isEighteenOrOlder"];
    newVote.nameTitle = voteDictionary[@"nameTitle"];
    newVote.firstName = voteDictionary[@"firstName"];
    newVote.middleName = voteDictionary[@"middleName"];
    newVote.lastName = voteDictionary[@"lastName"];
    newVote.nameSuffix = voteDictionary[@"nameSuffix"];
    newVote.homeAddress = voteDictionary[@"homeAddress"];
    newVote.homeUnit = voteDictionary[@"homeUnit"];
    newVote.homeCity = voteDictionary[@"homeCity"];
    newVote.homeStateId = voteDictionary[@"homeStateId"];
    newVote.hasMailingAddress = (BOOL)voteDictionary[@"hasMailingAddress"];
    newVote.mailingAddress = voteDictionary[@"mailingAddress"];
    newVote.mailingUnit = voteDictionary[@"mailingUnit"];
    newVote.mailingCity = voteDictionary[@"mailingCity"];
    newVote.mailingStateId = voteDictionary[@"mailingStateId"];
    newVote.mailingZipCode = voteDictionary[@"mailingZipCode"];
    newVote.race = voteDictionary[@"race"];
    newVote.phone = voteDictionary[@"phone"];
    newVote.phoneType = voteDictionary[@"phoneType"];
    newVote.changeOfName = (BOOL)voteDictionary[@"changeOfName"];
    newVote.previousNameTitle = voteDictionary[@"previousNameTitle"];
    newVote.previousFirstName = voteDictionary[@"previousFirstname"];
    newVote.previousMiddleName = voteDictionary[@"previousMiddleName"];
    newVote.previousLastName = voteDictionary[@"previousLastName"];
    newVote.previousNameSuffix = voteDictionary[@"previousNameSuffix"];
    newVote.changeOfAddress = (BOOL)voteDictionary[@"changeOfAddress"];
    newVote.previousAddress = voteDictionary[@"previousAddress"];
    newVote.previousUnit = voteDictionary[@"previousUnit"];
    newVote.previousCity = voteDictionary[@"previousCity"];
    newVote.previousStateId = voteDictionary[@"previousStateId"];
    newVote.previousZipCode = voteDictionary[@"previousZipCode"];
    newVote.optInEmail = (BOOL)voteDictionary[@"optInEmail"];
    newVote.optInSMS = (BOOL)voteDictionary[@"optInSMS"];
    newVote.optInVolunteer = (BOOL)voteDictionary[@"optInVolunteer"];
    newVote.partnerOptInSMS = NO;
    newVote.partnerOptInEmail = NO;
    newVote.partnerOptInVolunteer = NO;

    return newVote;
}
@end
