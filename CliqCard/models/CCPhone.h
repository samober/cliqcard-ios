//
//  CCPhone.h
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import <Foundation/Foundation.h>
#import "PlankModelRuntime.h"
@class CCPhoneBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface CCPhone : NSObject<NSCopying, NSSecureCoding>
@property (nonnull, nonatomic, copy, readonly) NSDate * updatedAt;
@property (nonatomic, assign, readonly) NSInteger identifier;
@property (nonnull, nonatomic, copy, readonly) NSDate * createdAt;
@property (nonnull, nonatomic, copy, readonly) NSString * number;
@property (nonatomic, assign, readonly) BOOL isPrimary;
@property (nonnull, nonatomic, copy, readonly) NSString * type;
@property (nullable, nonatomic, copy, readonly) NSString * extension;
+ (NSString *)className;
+ (NSString *)polymorphicTypeIdentifier;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithModelDictionary:(NS_VALID_UNTIL_END_OF_SCOPE NSDictionary *)modelDictionary;
- (instancetype)initWithBuilder:(CCPhoneBuilder *)builder;
- (instancetype)initWithBuilder:(CCPhoneBuilder *)builder initType:(PlankModelInitType)initType;
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(CCPhoneBuilder *builder))block;
- (BOOL)isEqualToPhone:(CCPhone *)anObject;
- (instancetype)mergeWithModel:(CCPhone *)modelObject;
- (instancetype)mergeWithModel:(CCPhone *)modelObject initType:(PlankModelInitType)initType;
- (NSDictionary *)dictionaryObjectRepresentation;
@end

@interface CCPhoneBuilder : NSObject
@property (nonnull, nonatomic, copy, readwrite) NSDate * updatedAt;
@property (nonatomic, assign, readwrite) NSInteger identifier;
@property (nonnull, nonatomic, copy, readwrite) NSDate * createdAt;
@property (nonnull, nonatomic, copy, readwrite) NSString * number;
@property (nonatomic, assign, readwrite) BOOL isPrimary;
@property (nonnull, nonatomic, copy, readwrite) NSString * type;
@property (nullable, nonatomic, copy, readwrite) NSString * extension;
- (instancetype)initWithModel:(CCPhone *)modelObject;
- (CCPhone *)build;
- (void)mergeWithModel:(CCPhone *)modelObject;
@end

NS_ASSUME_NONNULL_END