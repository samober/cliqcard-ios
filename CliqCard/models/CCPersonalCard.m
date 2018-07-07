//
//  CCPersonalCard.m
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import "CCAddress.h"
#import "CCPersonalCard.h"

struct CCPersonalCardDirtyProperties {
    unsigned int CCPersonalCardDirtyPropertyAddress:1;
    unsigned int CCPersonalCardDirtyPropertyCellPhone:1;
    unsigned int CCPersonalCardDirtyPropertyEmail:1;
    unsigned int CCPersonalCardDirtyPropertyHomePhone:1;
};

@interface CCPersonalCard ()
@property (nonatomic, assign, readwrite) struct CCPersonalCardDirtyProperties personalCardDirtyProperties;
@end

@interface CCPersonalCardBuilder ()
@property (nonatomic, assign, readwrite) struct CCPersonalCardDirtyProperties personalCardDirtyProperties;
@end

@implementation CCPersonalCard
+ (NSString *)className
{
    return @"CCPersonalCard";
}
+ (NSString *)polymorphicTypeIdentifier
{
    return @"personal_card";
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
                    self->_address = [CCAddress modelObjectWithDictionary:value];
                }
                self->_personalCardDirtyProperties.CCPersonalCardDirtyPropertyAddress = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"cell_phone"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_cellPhone = [value copy];
                }
                self->_personalCardDirtyProperties.CCPersonalCardDirtyPropertyCellPhone = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"email"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_email = [value copy];
                }
                self->_personalCardDirtyProperties.CCPersonalCardDirtyPropertyEmail = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"home_phone"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_homePhone = [value copy];
                }
                self->_personalCardDirtyProperties.CCPersonalCardDirtyPropertyHomePhone = 1;
            }
        }
    if ([self class] == [CCPersonalCard class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (instancetype)initWithBuilder:(CCPersonalCardBuilder *)builder
{
    NSParameterAssert(builder);
    return [self initWithBuilder:builder initType:PlankModelInitTypeDefault];
}
- (instancetype)initWithBuilder:(CCPersonalCardBuilder *)builder initType:(PlankModelInitType)initType
{
    NSParameterAssert(builder);
    if (!(self = [super init])) {
        return self;
    }
    _address = builder.address;
    _cellPhone = builder.cellPhone;
    _email = builder.email;
    _homePhone = builder.homePhone;
    _personalCardDirtyProperties = builder.personalCardDirtyProperties;
    if ([self class] == [CCPersonalCard class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(initType) }];
    }
    return self;
}
- (NSString *)debugDescription
{
    NSArray<NSString *> *parentDebugDescription = [[super debugDescription] componentsSeparatedByString:@"\n"];
    NSMutableArray *descriptionFields = [NSMutableArray arrayWithCapacity:4];
    [descriptionFields addObject:parentDebugDescription];
    struct CCPersonalCardDirtyProperties props = _personalCardDirtyProperties;
    if (props.CCPersonalCardDirtyPropertyAddress) {
        [descriptionFields addObject:[@"_address = " stringByAppendingFormat:@"%@", _address]];
    }
    if (props.CCPersonalCardDirtyPropertyCellPhone) {
        [descriptionFields addObject:[@"_cellPhone = " stringByAppendingFormat:@"%@", _cellPhone]];
    }
    if (props.CCPersonalCardDirtyPropertyEmail) {
        [descriptionFields addObject:[@"_email = " stringByAppendingFormat:@"%@", _email]];
    }
    if (props.CCPersonalCardDirtyPropertyHomePhone) {
        [descriptionFields addObject:[@"_homePhone = " stringByAppendingFormat:@"%@", _homePhone]];
    }
    return [NSString stringWithFormat:@"CCPersonalCard = {\n%@\n}", debugDescriptionForFields(descriptionFields)];
}
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(CCPersonalCardBuilder *builder))block
{
    NSParameterAssert(block);
    CCPersonalCardBuilder *builder = [[CCPersonalCardBuilder alloc] initWithModel:self];
    block(builder);
    return [builder build];
}
- (BOOL)isEqual:(id)anObject
{
    if (self == anObject) {
        return YES;
    }
    if ([anObject isKindOfClass:[CCPersonalCard class]] == NO) {
        return NO;
    }
    return [self isEqualToPersonalCard:anObject];
}
- (BOOL)isEqualToPersonalCard:(CCPersonalCard *)anObject
{
    return (
        (anObject != nil) &&
        (_address == anObject.address || [_address isEqual:anObject.address]) &&
        (_cellPhone == anObject.cellPhone || [_cellPhone isEqualToString:anObject.cellPhone]) &&
        (_email == anObject.email || [_email isEqualToString:anObject.email]) &&
        (_homePhone == anObject.homePhone || [_homePhone isEqualToString:anObject.homePhone])
    );
}
- (NSUInteger)hash
{
    NSUInteger subhashes[] = {
        17,
        [_address hash],
        [_cellPhone hash],
        [_email hash],
        [_homePhone hash]
    };
    return PINIntegerArrayHash(subhashes, sizeof(subhashes) / sizeof(subhashes[0]));
}
- (instancetype)mergeWithModel:(CCPersonalCard *)modelObject
{
    return [self mergeWithModel:modelObject initType:PlankModelInitTypeFromMerge];
}
- (instancetype)mergeWithModel:(CCPersonalCard *)modelObject initType:(PlankModelInitType)initType
{
    NSParameterAssert(modelObject);
    CCPersonalCardBuilder *builder = [[CCPersonalCardBuilder alloc] initWithModel:self];
    [builder mergeWithModel:modelObject];
    return [[CCPersonalCard alloc] initWithBuilder:builder initType:initType];
}
- (NSDictionary *)dictionaryObjectRepresentation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
    if (_personalCardDirtyProperties.CCPersonalCardDirtyPropertyAddress) {
        if (_address != (id)kCFNull) {
            [dict setObject:[_address dictionaryObjectRepresentation] forKey:@"address"];
        } else {
            [dict setObject:[NSNull null] forKey:@"address"];
        }
    }
    if (_personalCardDirtyProperties.CCPersonalCardDirtyPropertyCellPhone) {
        if (_cellPhone != (id)kCFNull) {
            [dict setObject:_cellPhone forKey:@"cell_phone"];
        } else {
            [dict setObject:[NSNull null] forKey:@"cell_phone"];
        }
    }
    if (_personalCardDirtyProperties.CCPersonalCardDirtyPropertyEmail) {
        if (_email != (id)kCFNull) {
            [dict setObject:_email forKey:@"email"];
        } else {
            [dict setObject:[NSNull null] forKey:@"email"];
        }
    }
    if (_personalCardDirtyProperties.CCPersonalCardDirtyPropertyHomePhone) {
        if (_homePhone != (id)kCFNull) {
            [dict setObject:_homePhone forKey:@"home_phone"];
        } else {
            [dict setObject:[NSNull null] forKey:@"home_phone"];
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
    _address = [aDecoder decodeObjectOfClass:[CCAddress class] forKey:@"address"];
    _cellPhone = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"cell_phone"];
    _email = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"email"];
    _homePhone = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"home_phone"];
    _personalCardDirtyProperties.CCPersonalCardDirtyPropertyAddress = [aDecoder decodeIntForKey:@"address_dirty_property"] & 0x1;
    _personalCardDirtyProperties.CCPersonalCardDirtyPropertyCellPhone = [aDecoder decodeIntForKey:@"cell_phone_dirty_property"] & 0x1;
    _personalCardDirtyProperties.CCPersonalCardDirtyPropertyEmail = [aDecoder decodeIntForKey:@"email_dirty_property"] & 0x1;
    _personalCardDirtyProperties.CCPersonalCardDirtyPropertyHomePhone = [aDecoder decodeIntForKey:@"home_phone_dirty_property"] & 0x1;
    if ([self class] == [CCPersonalCard class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.cellPhone forKey:@"cell_phone"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.homePhone forKey:@"home_phone"];
    [aCoder encodeInt:_personalCardDirtyProperties.CCPersonalCardDirtyPropertyAddress forKey:@"address_dirty_property"];
    [aCoder encodeInt:_personalCardDirtyProperties.CCPersonalCardDirtyPropertyCellPhone forKey:@"cell_phone_dirty_property"];
    [aCoder encodeInt:_personalCardDirtyProperties.CCPersonalCardDirtyPropertyEmail forKey:@"email_dirty_property"];
    [aCoder encodeInt:_personalCardDirtyProperties.CCPersonalCardDirtyPropertyHomePhone forKey:@"home_phone_dirty_property"];
}
@end

@implementation CCPersonalCardBuilder
- (instancetype)initWithModel:(CCPersonalCard *)modelObject
{
    NSParameterAssert(modelObject);
    if (!(self = [super init])) {
        return self;
    }
    struct CCPersonalCardDirtyProperties personalCardDirtyProperties = modelObject.personalCardDirtyProperties;
    if (personalCardDirtyProperties.CCPersonalCardDirtyPropertyAddress) {
        _address = modelObject.address;
    }
    if (personalCardDirtyProperties.CCPersonalCardDirtyPropertyCellPhone) {
        _cellPhone = modelObject.cellPhone;
    }
    if (personalCardDirtyProperties.CCPersonalCardDirtyPropertyEmail) {
        _email = modelObject.email;
    }
    if (personalCardDirtyProperties.CCPersonalCardDirtyPropertyHomePhone) {
        _homePhone = modelObject.homePhone;
    }
    _personalCardDirtyProperties = personalCardDirtyProperties;
    return self;
}
- (CCPersonalCard *)build
{
    return [[CCPersonalCard alloc] initWithBuilder:self];
}
- (void)mergeWithModel:(CCPersonalCard *)modelObject
{
    NSParameterAssert(modelObject);
    CCPersonalCardBuilder *builder = self;
    if (modelObject.personalCardDirtyProperties.CCPersonalCardDirtyPropertyAddress) {
        id value = modelObject.address;
        if (value != nil) {
            if (builder.address) {
                builder.address = [builder.address mergeWithModel:value initType:PlankModelInitTypeFromSubmerge];
            } else {
                builder.address = value;
            }
        } else {
            builder.address = nil;
        }
    }
    if (modelObject.personalCardDirtyProperties.CCPersonalCardDirtyPropertyCellPhone) {
        builder.cellPhone = modelObject.cellPhone;
    }
    if (modelObject.personalCardDirtyProperties.CCPersonalCardDirtyPropertyEmail) {
        builder.email = modelObject.email;
    }
    if (modelObject.personalCardDirtyProperties.CCPersonalCardDirtyPropertyHomePhone) {
        builder.homePhone = modelObject.homePhone;
    }
}
- (void)setAddress:(CCAddress *)address
{
    _address = address;
    _personalCardDirtyProperties.CCPersonalCardDirtyPropertyAddress = 1;
}
- (void)setCellPhone:(NSString *)cellPhone
{
    _cellPhone = [cellPhone copy];
    _personalCardDirtyProperties.CCPersonalCardDirtyPropertyCellPhone = 1;
}
- (void)setEmail:(NSString *)email
{
    _email = [email copy];
    _personalCardDirtyProperties.CCPersonalCardDirtyPropertyEmail = 1;
}
- (void)setHomePhone:(NSString *)homePhone
{
    _homePhone = [homePhone copy];
    _personalCardDirtyProperties.CCPersonalCardDirtyPropertyHomePhone = 1;
}
@end