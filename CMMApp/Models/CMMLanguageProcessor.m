//
//  CMMLanguageProcessor.m
//  CMMApp
//
//  Created by Omar Rasheed on 8/10/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMLanguageProcessor.h"

static NSLinguisticTaggerOptions const options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;

@implementation CMMLanguageProcessor

+ (instancetype)shared {
    static CMMLanguageProcessor *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initWithTagSchemes:@[NSLinguisticTagSchemeTokenType, NSLinguisticTagSchemeLanguage, NSLinguisticTagSchemeLexicalClass, NSLinguisticTagSchemeNameType, NSLinguisticTagSchemeLemma] options:0];
    });
    return sharedManager;
}

- (NSMutableArray *)tokenizeText:(NSString *)text {
    NSMutableArray *tokenizedText = [NSMutableArray new];
    self.string = text;
    NSRange range = NSMakeRange(0, text.length);
    [self enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeTokenType options:options usingBlock:^(NSLinguisticTag  _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        NSString *word = [text substringWithRange:tokenRange];
        [tokenizedText addObject:word];
    }];
    return tokenizedText;
}
 - (NSMutableArray *)lemmatizeText: (NSString *)text {
    NSMutableArray *lemmatizedText = [NSMutableArray new];
    self.string = text;
    NSRange range = NSMakeRange(0, text.length);
    [self enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeLemma options:options usingBlock:^(NSString* _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if (tag != nil) {
            NSLog(@"%@", tag);
        }
    }];
    return lemmatizedText;
}
 - (NSMutableArray *)partsOfSpeech:(NSString *)text {
    NSMutableArray *parsedText = [NSMutableArray new];
    self.string = text;
    NSRange range = NSMakeRange(0, text.length);
    [self enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeLexicalClass options:options usingBlock:^(NSString * _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if (tag != nil) {
            NSString *partOfSpeech = [text substringWithRange:tokenRange];
            NSLog(@"%@: %@", partOfSpeech, tag);
        }
    }];
    return parsedText;
}
 - (NSMutableArray *)namedEntityRecognition:(NSString *)text {
    NSMutableArray *entities = [NSMutableArray new];
    self.string = text;
    NSRange range = NSMakeRange(0, text.length);
    NSArray *tags = @[NSLinguisticTagPersonalName, NSLinguisticTagPlaceName, NSLinguisticTagOrganizationName];
    [self enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeNameType options:options usingBlock:^(NSLinguisticTag _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if ((tag != nil) && ([tags containsObject:tag])) {
            NSString *name = [text substringWithRange:tokenRange];
            NSLog(@"%@: %@", name, tag);
        }
    }];
    return entities;
}

@end
