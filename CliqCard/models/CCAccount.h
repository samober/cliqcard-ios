//
//  CCAccount.h
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import <Foundation/Foundation.h>
#import "PlankModelRuntime.h"
@class CCAccountBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface CCAccount : NSObject<NSCopying, NSSecureCoding>
@property (nonnull, nonatomic, copy, readonly) NSString * lastName;
@property (nullable, nonatomic, copy, readonly) NSString * email;
@property (nonatomic, assign, readonly) NSInteger identifier;
@property (nonnull, nonatomic, copy, readonly) NSDate * updatedAt;
@property (nonnull, nonatomic, copy, readonly) NSString * fullName;
@property (nonnull, nonatomic, copy, readonly) NSDate * createdAt;
@property (nonnull, nonatomic, copy, readonly) NSString * firstName;
@property (nonnull, nonatomic, copy, readonly) NSString * phoneNumber;
+ (NSString *)className;
+ (NSString *)polymorphicTypeIdentifier;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithModelDictionary:(NS_VALID_UNTIL_END_OF_SCOPE NSDictionary *)modelDictionary;
- (instancetype)initWithBuilder:(CCAccountBuilder *)builder;
- (instancetype)initWithBuilder:(CCAccountBuilder *)builder initType:(PlankModelInitType)initType;
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(CCAccountBuilder *builder))block;
- (BOOL)isEqualToAccount:(CCAccount *)anObject;
- (instancetype)mergeWithModel:(CCAccount *)modelObject;
- (instancetype)mergeWithModel:(CCAccount *)modelObject initType:(PlankModelInitType)initType;
- (NSDictionary *)dictionaryObjectRepresentation;
@end

@interface CCAccountBuilder : NSObject
@property (nonnull, nonatomic, copy, readwrite) NSString * lastName;
@property (nullable, nonatomic, copy, readwrite) NSString * email;
@property (nonatomic, assign, readwrite) NSInteger identifier;
@property (nonnull, nonatomic, copy, readwrite) NSDate * updatedAt;
@property (nonnull, nonatomic, copy, readwrite) NSString * fullName;
@property (nonnull, nonatomic, copy, readwrite) NSDate * createdAt;
@property (nonnull, nonatomic, copy, readwrite) NSString * firstName;
@property (nonnull, nonatomic, copy, readwrite) NSString * phoneNumber;
- (instancetype)initWithModel:(CCAccount *)modelObject;
- (CCAccount *)build;
- (void)mergeWithModel:(CCAccount *)modelObject;
@end

NS_ASSUME_NONNULL_END