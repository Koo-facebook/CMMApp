//
//  CMMLanguageProcessor.m
//  CMMApp
//
//  Created by Omar Rasheed on 8/10/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CMMLanguageProcessor.h"
#import "SentimentPolarity.h"

static NSLinguisticTaggerOptions const options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;

@implementation CMMLanguageProcessor

+ (NSDictionary *)runSentimentAnalysis: (NSString *)text {
    NSMutableDictionary *results = [NSMutableDictionary new];
    NSMutableDictionary *wordCounts = [NSMutableDictionary new];
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:0];
    tagger.string = text;
    NSRange range = NSMakeRange(0, text.length);
    
    [tagger enumerateTagsInRange:range scheme:NSLinguisticTagSchemeNameType options:options usingBlock:^(NSLinguisticTag  _Nullable tag, NSRange tokenRange, NSRange sentenceRange, BOOL * _Nonnull stop) {
        NSString *token = [[text substringWithRange:tokenRange] lowercaseString];
        if (token.length < 3) {
            return;
        }
        
        if ([wordCounts objectForKey:token] == nil) {
            wordCounts[token] = [NSNumber numberWithDouble:1.0];
        } else {
            wordCounts[token] = [NSNumber numberWithDouble:([(NSNumber *)wordCounts[token] floatValue] + 1.0)];
        }
    }];
    SentimentPolarity *model = [SentimentPolarity new];
    SentimentPolarityOutput *output = [model predictionFromInput:wordCounts error:nil];
    results[@"classLabel"] = output.classLabel;
    results[@"classProbability"] = output.classProbability;
    return results;
}

+ (NSMutableArray *)tokenizeText:(NSString *)text {
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:0];
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
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:0];
    NSMutableArray *lemmatizedText = [NSMutableArray new];
    tagger.string = text;
    NSRange range = NSMakeRange(0, text.length);
    
    [tagger enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeLemma options:options usingBlock:^(NSString* _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if (tag != nil) {
            [lemmatizedText addObject:tag];
        }
    }];
    return lemmatizedText;
}

+ (NSMutableDictionary *)partsOfSpeech:(NSString *)text {
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:0];
    NSMutableDictionary *parsedText = [NSMutableDictionary new];
    tagger.string = text;
    NSRange range = NSMakeRange(0, text.length);
    [tagger enumerateTagsInRange:range unit:NSLinguisticTaggerUnitWord scheme:NSLinguisticTagSchemeLexicalClass options:options usingBlock:^(NSString * _Nullable tag, NSRange tokenRange, BOOL * _Nonnull stop) {
        if (tag != nil) {
            NSString *word = [text substringWithRange:tokenRange];
            NSLog(@"%@: %@", word, tag);
            if ([parsedText objectForKey:tag] == nil) {
                NSMutableArray *tagsArray = [NSMutableArray arrayWithObject:word];
                [parsedText setObject:tagsArray forKey:tag];
            } else {
                NSMutableArray *tagsArray = [parsedText objectForKey:tag];
                [tagsArray addObject:word];
                [parsedText setObject:tagsArray forKey:tag];
            }
        }
    }];
    return parsedText;
}

+ (NSMutableDictionary *)namedEntityRecognition:(NSString *)text {
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:0];
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
