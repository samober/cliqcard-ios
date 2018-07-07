//
//  CCWorkCard.h
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import <Foundation/Foundation.h>
#import "PlankModelRuntime.h"
@class CCAddress;
@class CCWorkCardBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface CCWorkCard : NSObject<NSCopying, NSSecureCoding>
@property (nullable, nonatomic, strong, readonly) CCAddress * address;
@property (nullable, nonatomic, copy, readonly) NSString * officePhone;
@property (nullable, nonatomic, copy, readonly) NSString * email;
+ (NSString *)className;
+ (NSString *)polymorphicTypeIdentifier;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithModelDictionary:(NS_VALID_UNTIL_END_OF_SCOPE NSDictionary *)modelDictionary;
- (instancetype)initWithBuilder:(CCWorkCardBuilder *)builder;
- (instancetype)initWithBuilder:(CCWorkCardBuilder *)builder initType:(PlankModelInitType)initType;
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(CCWorkCardBuilder *builder))block;
- (BOOL)isEqualToWorkCard:(CCWorkCard *)anObject;
- (instancetype)mergeWithModel:(CCWorkCard *)modelObject;
- (instancetype)mergeWithModel:(CCWorkCard *)modelObject initType:(PlankModelInitType)initType;
- (NSDictionary *)dictionaryObjectRepresentation;
@end

@interface CCWorkCardBuilder : NSObject
@property (nullable, nonatomic, strong, readwrite) CCAddress * address;
@property (nullable, nonatomic, copy, readwrite) NSString * officePhone;
@property (nullable, nonatomic, copy, readwrite) NSString * email;
- (instancetype)initWithModel:(CCWorkCard *)modelObject;
- (CCWorkCard *)build;
- (void)mergeWithModel:(CCWorkCard *)modelObject;
@end

NS_ASSUME_NONNULL_END
