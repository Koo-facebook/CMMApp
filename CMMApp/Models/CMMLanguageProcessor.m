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

+ (NSMutableArray *)tokenizeText:(NSString *)text {
    NSLinguisticTagger *tagger = [NSLinguisticTagger new];
    NSMutableArray *tokenizedText = [NSMutableArray new];
    tagger.string = text;
    NSRange range = NSMakeRange(0, text.length);
    [tagger enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeTokenType options:options usingBlock:^(NSLinguisticTag  _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        NSString *word = [text substringWithRange:tokenRange];
        [tokenizedText addObject:word];
    }];
    return tokenizedText;
}
+ (NSMutableArray *)lemmatizeText: (NSString *)text {
    NSLinguisticTagger *tagger = [NSLinguisticTagger new];
    NSMutableArray *lemmatizedText = [NSMutableArray new];
    tagger.string = text;
    NSRange range = NSMakeRange(0, text.length);
    [tagger enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeLemma options:options usingBlock:^(NSString* _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if (tag != nil) {
            NSLog(@"%@", tag);
        }
    }];
    return lemmatizedText;
}
+ (NSMutableArray *)partsOfSpeech:(NSString *)text {
    NSLinguisticTagger *tagger = [NSLinguisticTagger new];
    NSMutableArray *parsedText = [NSMutableArray new];
    tagger.string = text;
    NSRange range = NSMakeRange(0, text.length);
    [tagger enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeLexicalClass options:options usingBlock:^(NSString * _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if (tag != nil) {
            NSString *partOfSpeech = [text substringWithRange:tokenRange];
            NSLog(@"%@: %@", partOfSpeech, tag);
        }
    }];
    return parsedText;
}
+ (NSMutableDictionary *)namedEntityRecognition:(NSString *)text {
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeNameType] options:0];
    NSMutableDictionary *entities = [NSMutableDictionary new];
    tagger.string = text;
    NSRange range = NSMakeRange(0, text.length);
    NSArray *tags = @[NSLinguisticTagPersonalName, NSLinguisticTagPlaceName, NSLinguisticTagOrganizationName];
    [tagger enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeNameType options:options usingBlock:^(NSLinguisticTag _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if ((tag != nil) && ([tags containsObject:tag])) {
            NSString *name = [text substringWithRange:tokenRange];
            [entities setObject:tag forKey:name];
        }
    }];
    return entities;
}

@end
