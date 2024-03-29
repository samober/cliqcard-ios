//
//  CCEmail.m
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import "CCEmail.h"

struct CCEmailDirtyProperties {
    unsigned int CCEmailDirtyPropertyAddress:1;
    unsigned int CCEmailDirtyPropertyCreatedAt:1;
    unsigned int CCEmailDirtyPropertyIdentifier:1;
    unsigned int CCEmailDirtyPropertyIsPrimary:1;
    unsigned int CCEmailDirtyPropertyType:1;
    unsigned int CCEmailDirtyPropertyUpdatedAt:1;
};

@interface CCEmail ()
@property (nonatomic, assign, readwrite) struct CCEmailDirtyProperties emailDirtyProperties;
@end

@interface CCEmailBuilder ()
@property (nonatomic, assign, readwrite) struct CCEmailDirtyProperties emailDirtyProperties;
@end

@implementation CCEmail
+ (NSString *)className
{
    return @"CCEmail";
}
+ (NSString *)polymorphicTypeIdentifier
{
    return @"email";
}
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithModelDictionary:dictionary];
}
- (instancetype)init
{
    return [self initWithModelDictionary:@{}];
}
- (instancetype)initWithModelDictionary:(NS_VALID_UNTIL_END_OF_SCOPE NSDictionary *)modelDictionary
{
    NSParameterAssert(modelDictionary);
    if (!modelDictionary) {
        return self;
    }
    if (!(self = [super init])) {
        return self;
    }
        {
            __unsafe_unretained id value = modelDictionary[@"address"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_address = [value copy];
                }
                self->_emailDirtyProperties.CCEmailDirtyPropertyAddress = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"created_at"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_createdAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_emailDirtyProperties.CCEmailDirtyPropertyCreatedAt = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"id"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_identifier = [value integerValue];
                }
                self->_emailDirtyProperties.CCEmailDirtyPropertyIdentifier = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"is_primary"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_isPrimary = [value boolValue];
                }
                self->_emailDirtyProperties.CCEmailDirtyPropertyIsPrimary = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"type"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_type = [value copy];
                }
                self->_emailDirtyProperties.CCEmailDirtyPropertyType = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"updated_at"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_updatedAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_emailDirtyProperties.CCEmailDirtyPropertyUpdatedAt = 1;
            }
        }
    if ([self class] == [CCEmail class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (instancetype)initWithBuilder:(CCEmailBuilder *)builder
{
    NSParameterAssert(builder);
    return [self initWithBuilder:builder initType:PlankModelInitTypeDefault];
}
- (instancetype)initWithBuilder:(CCEmailBuilder *)builder initType:(PlankModelInitType)initType
{
    NSParameterAssert(builder);
    if (!(self = [super init])) {
        return self;
    }
    _address = builder.address;
    _createdAt = builder.createdAt;
    _identifier = builder.identifier;
    _isPrimary = builder.isPrimary;
    _type = builder.type;
    _updatedAt = builder.updatedAt;
    _emailDirtyProperties = builder.emailDirtyProperties;
    if ([self class] == [CCEmail class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(initType) }];
    }
    return self;
}
- (NSString *)debugDescription
{
    NSArray<NSString *> *parentDebugDescription = [[super debugDescription] componentsSeparatedByString:@"\n"];
    NSMutableArray *descriptionFields = [NSMutableArray arrayWithCapacity:6];
    [descriptionFields addObject:parentDebugDescription];
    struct CCEmailDirtyProperties props = _emailDirtyProperties;
    if (props.CCEmailDirtyPropertyAddress) {
        [descriptionFields addObject:[@"_address = " stringByAppendingFormat:@"%@", _address]];
    }
    if (props.CCEmailDirtyPropertyCreatedAt) {
        [descriptionFields addObject:[@"_createdAt = " stringByAppendingFormat:@"%@", _createdAt]];
    }
    if (props.CCEmailDirtyPropertyIdentifier) {
        [descriptionFields addObject:[@"_identifier = " stringByAppendingFormat:@"%@", @(_identifier)]];
    }
    if (props.CCEmailDirtyPropertyIsPrimary) {
        [descriptionFields addObject:[@"_isPrimary = " stringByAppendingFormat:@"%@", @(_isPrimary)]];
    }
    if (props.CCEmailDirtyPropertyType) {
        [descriptionFields addObject:[@"_type = " stringByAppendingFormat:@"%@", _type]];
    }
    if (props.CCEmailDirtyPropertyUpdatedAt) {
        [descriptionFields addObject:[@"_updatedAt = " stringByAppendingFormat:@"%@", _updatedAt]];
    }
    return [NSString stringWithFormat:@"CCEmail = {\n%@\n}", debugDescriptionForFields(descriptionFields)];
}
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(CCEmailBuilder *builder))block
{
    NSParameterAssert(block);
    CCEmailBuilder *builder = [[CCEmailBuilder alloc] initWithModel:self];
    block(builder);
    return [builder build];
}
- (BOOL)isEqual:(id)anObject
{
    if (self == anObject) {
        return YES;
    }
    if ([anObject isKindOfClass:[CCEmail class]] == NO) {
        return NO;
    }
    return [self isEqualToEmail:anObject];
}
- (BOOL)isEqualToEmail:(CCEmail *)anObject
{
    return (
        (anObject != nil) &&
        (_isPrimary == anObject.isPrimary) &&
        (_identifier == anObject.identifier) &&
        (_address == anObject.address || [_address isEqualToString:anObject.address]) &&
        (_createdAt == anObject.createdAt || [_createdAt isEqualToDate:anObject.createdAt]) &&
        (_type == anObject.type || [_type isEqualToString:anObject.type]) &&
        (_updatedAt == anObject.updatedAt || [_updatedAt isEqualToDate:anObject.updatedAt])
    );
}
- (NSUInteger)hash
{
    NSUInteger subhashes[] = {
        17,
        [_address hash],
        [_createdAt hash],
        (NSUInteger)_identifier,
        (_isPrimary ? 1231 : 1237),
        [_type hash],
        [_updatedAt hash]
    };
    return PINIntegerArrayHash(subhashes, sizeof(subhashes) / sizeof(subhashes[0]));
}
- (instancetype)mergeWithModel:(CCEmail *)modelObject
{
    return [self mergeWithModel:modelObject initType:PlankModelInitTypeFromMerge];
}
- (instancetype)mergeWithModel:(CCEmail *)modelObject initType:(PlankModelInitType)initType
{
    NSParameterAssert(modelObject);
    CCEmailBuilder *builder = [[CCEmailBuilder alloc] initWithModel:self];
    [builder mergeWithModel:modelObject];
    return [[CCEmail alloc] initWithBuilder:builder initType:initType];
}
- (NSDictionary *)dictionaryObjectRepresentation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    if (_emailDirtyProperties.CCEmailDirtyPropertyAddress) {
        if (_address != (id)kCFNull) {
            [dict setObject:_address forKey:@"address"];
        } else {
            [dict setObject:[NSNull null] forKey:@"address"];
        }
    }
    if (_emailDirtyProperties.CCEmailDirtyPropertyCreatedAt) {
        if (_createdAt != (id)kCFNull) {
            NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey];
            if ([[valueTransformer class] allowsReverseTransformation]) {
                [dict setObject:[valueTransformer reverseTransformedValue:_createdAt] forKey:@"created_at"];
            } else {
                [dict setObject:[NSNull null] forKey:@"created_at"];
            }
        } else {
            [dict setObject:[NSNull null] forKey:@"created_at"];
        }
    }
    if (_emailDirtyProperties.CCEmailDirtyPropertyIdentifier) {
        [dict setObject:@(_identifier) forKey: @"id"];
    }
    if (_emailDirtyProperties.CCEmailDirtyPropertyIsPrimary) {
        [dict setObject:@(_isPrimary) forKey: @"is_primary"];
    }
    if (_emailDirtyProperties.CCEmailDirtyPropertyType) {
        if (_type != (id)kCFNull) {
            [dict setObject:_type forKey:@"type"];
        } else {
            [dict setObject:[NSNull null] forKey:@"type"];
        }
    }
    if (_emailDirtyProperties.CCEmailDirtyPropertyUpdatedAt) {
        if (_updatedAt != (id)kCFNull) {
            NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey];
            if ([[valueTransformer class] allowsReverseTransformation]) {
                [dict setObject:[valueTransformer reverseTransformedValue:_updatedAt] forKey:@"updated_at"];
            } else {
                [dict setObject:[NSNull null] forKey:@"updated_at"];
            }
        } else {
            [dict setObject:[NSNull null] forKey:@"updated_at"];
        }
    }
    return dict;
}
#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding
{
    return YES;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super init])) {
        return self;
    }
    _address = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"address"];
    _createdAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"created_at"];
    _identifier = [aDecoder decodeIntegerForKey:@"id"];
    _isPrimary = [aDecoder decodeBoolForKey:@"is_primary"];
    _type = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"type"];
    _updatedAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"updated_at"];
    _emailDirtyProperties.CCEmailDirtyPropertyAddress = [aDecoder decodeIntForKey:@"address_dirty_property"] & 0x1;
    _emailDirtyProperties.CCEmailDirtyPropertyCreatedAt = [aDecoder decodeIntForKey:@"created_at_dirty_property"] & 0x1;
    _emailDirtyProperties.CCEmailDirtyPropertyIdentifier = [aDecoder decodeIntForKey:@"id_dirty_property"] & 0x1;
    _emailDirtyProperties.CCEmailDirtyPropertyIsPrimary = [aDecoder decodeIntForKey:@"is_primary_dirty_property"] & 0x1;
    _emailDirtyProperties.CCEmailDirtyPropertyType = [aDecoder decodeIntForKey:@"type_dirty_property"] & 0x1;
    _emailDirtyProperties.CCEmailDirtyPropertyUpdatedAt = [aDecoder decodeIntForKey:@"updated_at_dirty_property"] & 0x1;
    if ([self class] == [CCEmail class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.createdAt forKey:@"created_at"];
    [aCoder encodeInteger:self.identifier forKey:@"id"];
    [aCoder encodeBool:self.isPrimary forKey:@"is_primary"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.updatedAt forKey:@"updated_at"];
    [aCoder encodeInt:_emailDirtyProperties.CCEmailDirtyPropertyAddress forKey:@"address_dirty_property"];
    [aCoder encodeInt:_emailDirtyProperties.CCEmailDirtyPropertyCreatedAt forKey:@"created_at_dirty_property"];
    [aCoder encodeInt:_emailDirtyProperties.CCEmailDirtyPropertyIdentifier forKey:@"id_dirty_property"];
    [aCoder encodeInt:_emailDirtyProperties.CCEmailDirtyPropertyIsPrimary forKey:@"is_primary_dirty_property"];
    [aCoder encodeInt:_emailDirtyProperties.CCEmailDirtyPropertyType forKey:@"type_dirty_property"];
    [aCoder encodeInt:_emailDirtyProperties.CCEmailDirtyPropertyUpdatedAt forKey:@"updated_at_dirty_property"];
}
@end

@implementation CCEmailBuilder
- (instancetype)initWithModel:(CCEmail *)modelObject
{
    NSParameterAssert(modelObject);
    if (!(self = [super init])) {
        return self;
    }
    struct CCEmailDirtyProperties emailDirtyProperties = modelObject.emailDirtyProperties;
    if (emailDirtyProperties.CCEmailDirtyPropertyAddress) {
        _address = modelObject.address;
    }
    if (emailDirtyProperties.CCEmailDirtyPropertyCreatedAt) {
        _createdAt = modelObject.createdAt;
    }
    if (emailDirtyProperties.CCEmailDirtyPropertyIdentifier) {
        _identifier = modelObject.identifier;
    }
    if (emailDirtyProperties.CCEmailDirtyPropertyIsPrimary) {
        _isPrimary = modelObject.isPrimary;
    }
    if (emailDirtyProperties.CCEmailDirtyPropertyType) {
        _type = modelObject.type;
    }
    if (emailDirtyProperties.CCEmailDirtyPropertyUpdatedAt) {
        _updatedAt = modelObject.updatedAt;
    }
    _emailDirtyProperties = emailDirtyProperties;
    return self;
}
- (CCEmail *)build
{
    return [[CCEmail alloc] initWithBuilder:self];
}
- (void)mergeWithModel:(CCEmail *)modelObject
{
    NSParameterAssert(modelObject);
    CCEmailBuilder *builder = self;
    if (modelObject.emailDirtyProperties.CCEmailDirtyPropertyAddress) {
        builder.address = modelObject.address;
    }
    if (modelObject.emailDirtyProperties.CCEmailDirtyPropertyCreatedAt) {
        builder.createdAt = modelObject.createdAt;
    }
    if (modelObject.emailDirtyProperties.CCEmailDirtyPropertyIdentifier) {
        builder.identifier = modelObject.identifier;
    }
    if (modelObject.emailDirtyProperties.CCEmailDirtyPropertyIsPrimary) {
        builder.isPrimary = modelObject.isPrimary;
    }
    if (modelObject.emailDirtyProperties.CCEmailDirtyPropertyType) {
        builder.type = modelObject.type;
    }
    if (modelObject.emailDirtyProperties.CCEmailDirtyPropertyUpdatedAt) {
        builder.updatedAt = modelObject.updatedAt;
    }
}
- (void)setAddress:(NSString *)address
{
    _address = [address copy];
    _emailDirtyProperties.CCEmailDirtyPropertyAddress = 1;
}
- (void)setCreatedAt:(NSDate *)createdAt
{
    _createdAt = [createdAt copy];
    _emailDirtyProperties.CCEmailDirtyPropertyCreatedAt = 1;
}
- (void)setIdentifier:(NSInteger)identifier
{
    _identifier = identifier;
    _emailDirtyProperties.CCEmailDirtyPropertyIdentifier = 1;
}
- (void)setIsPrimary:(BOOL)isPrimary
{
    _isPrimary = isPrimary;
    _emailDirtyProperties.CCEmailDirtyPropertyIsPrimary = 1;
}
- (void)setType:(NSString *)type
{
    _type = [type copy];
    _emailDirtyProperties.CCEmailDirtyPropertyType = 1;
}
- (void)setUpdatedAt:(NSDate *)updatedAt
{
    _updatedAt = [updatedAt copy];
    _emailDirtyProperties.CCEmailDirtyPropertyUpdatedAt = 1;
}
@end
