//
//  CMMLanguageProcessor.h
//  CMMApp
//
//  Created by Omar Rasheed on 8/10/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMMLanguageProcessor : NSLinguisticTagger

+ (NSMutableArray *)tokenizeText:(NSString *)text;
+ (NSMutableArray *)lemmatizeText: (NSString *)text;
+ (NSMutableArray *)partsOfSpeech:(NSString *)text;
+ (NSMutableDictionary *)namedEntityRecognition:(NSString *)text;

@end
