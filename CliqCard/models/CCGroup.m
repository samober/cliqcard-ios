//
//  CCGroup.m
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import "CCGroup.h"
#import "CCGroupPicture.h"

struct CCGroupDirtyProperties {
    unsigned int CCGroupDirtyPropertyCreatedAt:1;
    unsigned int CCGroupDirtyPropertyIdentifier:1;
    unsigned int CCGroupDirtyPropertyMemberCount:1;
    unsigned int CCGroupDirtyPropertyName:1;
    unsigned int CCGroupDirtyPropertyPicture:1;
    unsigned int CCGroupDirtyPropertyUpdatedAt:1;
};

@interface CCGroup ()
@property (nonatomic, assign, readwrite) struct CCGroupDirtyProperties groupDirtyProperties;
@end

@interface CCGroupBuilder ()
@property (nonatomic, assign, readwrite) struct CCGroupDirtyProperties groupDirtyProperties;
@end

@implementation CCGroup
+ (NSString *)className
{
    return @"CCGroup";
}
+ (NSString *)polymorphicTypeIdentifier
{
    return @"group";
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
            __unsafe_unretained id value = modelDictionary[@"created_at"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_createdAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_groupDirtyProperties.CCGroupDirtyPropertyCreatedAt = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"id"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_identifier = [value integerValue];
                }
                self->_groupDirtyProperties.CCGroupDirtyPropertyIdentifier = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"member_count"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_memberCount = [value integerValue];
                }
                self->_groupDirtyProperties.CCGroupDirtyPropertyMemberCount = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"name"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_name = [value copy];
                }
                self->_groupDirtyProperties.CCGroupDirtyPropertyName = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"picture"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_picture = [CCGroupPicture modelObjectWithDictionary:value];
                }
                self->_groupDirtyProperties.CCGroupDirtyPropertyPicture = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"updated_at"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_updatedAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_groupDirtyProperties.CCGroupDirtyPropertyUpdatedAt = 1;
            }
        }
    if ([self class] == [CCGroup class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (instancetype)initWithBuilder:(CCGroupBuilder *)builder
{
    NSParameterAssert(builder);
    return [self initWithBuilder:builder initType:PlankModelInitTypeDefault];
}
- (instancetype)initWithBuilder:(CCGroupBuilder *)builder initType:(PlankModelInitType)initType
{
    NSParameterAssert(builder);
    if (!(self = [super init])) {
        return self;
    }
    _createdAt = builder.createdAt;
    _identifier = builder.identifier;
    _memberCount = builder.memberCount;
    _name = builder.name;
    _picture = builder.picture;
    _updatedAt = builder.updatedAt;
    _groupDirtyProperties = builder.groupDirtyProperties;
    if ([self class] == [CCGroup class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(initType) }];
    }
    return self;
}
- (NSString *)debugDescription
{
    NSArray<NSString *> *parentDebugDescription = [[super debugDescription] componentsSeparatedByString:@"\n"];
    NSMutableArray *descriptionFields = [NSMutableArray arrayWithCapacity:6];
    [descriptionFields addObject:parentDebugDescription];
    struct CCGroupDirtyProperties props = _groupDirtyProperties;
    if (props.CCGroupDirtyPropertyCreatedAt) {
        [descriptionFields addObject:[@"_createdAt = " stringByAppendingFormat:@"%@", _createdAt]];
    }
    if (props.CCGroupDirtyPropertyIdentifier) {
        [descriptionFields addObject:[@"_identifier = " stringByAppendingFormat:@"%@", @(_identifier)]];
    }
    if (props.CCGroupDirtyPropertyMemberCount) {
        [descriptionFields addObject:[@"_memberCount = " stringByAppendingFormat:@"%@", @(_memberCount)]];
    }
    if (props.CCGroupDirtyPropertyName) {
        [descriptionFields addObject:[@"_name = " stringByAppendingFormat:@"%@", _name]];
    }
    if (props.CCGroupDirtyPropertyPicture) {
        [descriptionFields addObject:[@"_picture = " stringByAppendingFormat:@"%@", _picture]];
    }
    if (props.CCGroupDirtyPropertyUpdatedAt) {
        [descriptionFields addObject:[@"_updatedAt = " stringByAppendingFormat:@"%@", _updatedAt]];
    }
    return [NSString stringWithFormat:@"CCGroup = {\n%@\n}", debugDescriptionForFields(descriptionFields)];
}
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(CCGroupBuilder *builder))block
{
    NSParameterAssert(block);
    CCGroupBuilder *builder = [[CCGroupBuilder alloc] initWithModel:self];
    block(builder);
    return [builder build];
}
- (BOOL)isEqual:(id)anObject
{
    if (self == anObject) {
        return YES;
    }
    if ([anObject isKindOfClass:[CCGroup class]] == NO) {
        return NO;
    }
    return [self isEqualToGroup:anObject];
}
- (BOOL)isEqualToGroup:(CCGroup *)anObject
{
    return (
        (anObject != nil) &&
        (_memberCount == anObject.memberCount) &&
        (_identifier == anObject.identifier) &&
        (_createdAt == anObject.createdAt || [_createdAt isEqualToDate:anObject.createdAt]) &&
        (_name == anObject.name || [_name isEqualToString:anObject.name]) &&
        (_picture == anObject.picture || [_picture isEqual:anObject.picture]) &&
        (_updatedAt == anObject.updatedAt || [_updatedAt isEqualToDate:anObject.updatedAt])
    );
}
- (NSUInteger)hash
{
    NSUInteger subhashes[] = {
        17,
        [_createdAt hash],
        (NSUInteger)_identifier,
        (NSUInteger)_memberCount,
        [_name hash],
        [_picture hash],
        [_updatedAt hash]
    };
    return PINIntegerArrayHash(subhashes, sizeof(subhashes) / sizeof(subhashes[0]));
}
- (instancetype)mergeWithModel:(CCGroup *)modelObject
{
    return [self mergeWithModel:modelObject initType:PlankModelInitTypeFromMerge];
}
- (instancetype)mergeWithModel:(CCGroup *)modelObject initType:(PlankModelInitType)initType
{
    NSParameterAssert(modelObject);
    CCGroupBuilder *builder = [[CCGroupBuilder alloc] initWithModel:self];
    [builder mergeWithModel:modelObject];
    return [[CCGroup alloc] initWithBuilder:builder initType:initType];
}
- (NSDictionary *)dictionaryObjectRepresentation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    if (_groupDirtyProperties.CCGroupDirtyPropertyCreatedAt) {
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
    if (_groupDirtyProperties.CCGroupDirtyPropertyIdentifier) {
        [dict setObject:@(_identifier) forKey: @"id"];
    }
    if (_groupDirtyProperties.CCGroupDirtyPropertyMemberCount) {
        [dict setObject:@(_memberCount) forKey: @"member_count"];
    }
    if (_groupDirtyProperties.CCGroupDirtyPropertyName) {
        if (_name != (id)kCFNull) {
            [dict setObject:_name forKey:@"name"];
        } else {
            [dict setObject:[NSNull null] forKey:@"name"];
        }
    }
    if (_groupDirtyProperties.CCGroupDirtyPropertyPicture) {
        if (_picture != (id)kCFNull) {
            [dict setObject:[_picture dictionaryObjectRepresentation] forKey:@"picture"];
        } else {
            [dict setObject:[NSNull null] forKey:@"picture"];
        }
    }
    if (_groupDirtyProperties.CCGroupDirtyPropertyUpdatedAt) {
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
    _createdAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"created_at"];
    _identifier = [aDecoder decodeIntegerForKey:@"id"];
    _memberCount = [aDecoder decodeIntegerForKey:@"member_count"];
    _name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"name"];
    _picture = [aDecoder decodeObjectOfClass:[CCGroupPicture class] forKey:@"picture"];
    _updatedAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"updated_at"];
    _groupDirtyProperties.CCGroupDirtyPropertyCreatedAt = [aDecoder decodeIntForKey:@"created_at_dirty_property"] & 0x1;
    _groupDirtyProperties.CCGroupDirtyPropertyIdentifier = [aDecoder decodeIntForKey:@"id_dirty_property"] & 0x1;
    _groupDirtyProperties.CCGroupDirtyPropertyMemberCount = [aDecoder decodeIntForKey:@"member_count_dirty_property"] & 0x1;
    _groupDirtyProperties.CCGroupDirtyPropertyName = [aDecoder decodeIntForKey:@"name_dirty_property"] & 0x1;
    _groupDirtyProperties.CCGroupDirtyPropertyPicture = [aDecoder decodeIntForKey:@"picture_dirty_property"] & 0x1;
    _groupDirtyProperties.CCGroupDirtyPropertyUpdatedAt = [aDecoder decodeIntForKey:@"updated_at_dirty_property"] & 0x1;
    if ([self class] == [CCGroup class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.createdAt forKey:@"created_at"];
    [aCoder encodeInteger:self.identifier forKey:@"id"];
    [aCoder encodeInteger:self.memberCount forKey:@"member_count"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.picture forKey:@"picture"];
    [aCoder encodeObject:self.updatedAt forKey:@"updated_at"];
    [aCoder encodeInt:_groupDirtyProperties.CCGroupDirtyPropertyCreatedAt forKey:@"created_at_dirty_property"];
    [aCoder encodeInt:_groupDirtyProperties.CCGroupDirtyPropertyIdentifier forKey:@"id_dirty_property"];
    [aCoder encodeInt:_groupDirtyProperties.CCGroupDirtyPropertyMemberCount forKey:@"member_count_dirty_property"];
    [aCoder encodeInt:_groupDirtyProperties.CCGroupDirtyPropertyName forKey:@"name_dirty_property"];
    [aCoder encodeInt:_groupDirtyProperties.CCGroupDirtyPropertyPicture forKey:@"picture_dirty_property"];
    [aCoder encodeInt:_groupDirtyProperties.CCGroupDirtyPropertyUpdatedAt forKey:@"updated_at_dirty_property"];
}
@end

@implementation CCGroupBuilder
- (instancetype)initWithModel:(CCGroup *)modelObject
{
    NSParameterAssert(modelObject);
    if (!(self = [super init])) {
        return self;
    }
    struct CCGroupDirtyProperties groupDirtyProperties = modelObject.groupDirtyProperties;
    if (groupDirtyProperties.CCGroupDirtyPropertyCreatedAt) {
        _createdAt = modelObject.createdAt;
    }
    if (groupDirtyProperties.CCGroupDirtyPropertyIdentifier) {
        _identifier = modelObject.identifier;
    }
    if (groupDirtyProperties.CCGroupDirtyPropertyMemberCount) {
        _memberCount = modelObject.memberCount;
    }
    if (groupDirtyProperties.CCGroupDirtyPropertyName) {
        _name = modelObject.name;
    }
    if (groupDirtyProperties.CCGroupDirtyPropertyPicture) {
        _picture = modelObject.picture;
    }
    if (groupDirtyProperties.CCGroupDirtyPropertyUpdatedAt) {
        _updatedAt = modelObject.updatedAt;
    }
    _groupDirtyProperties = groupDirtyProperties;
    return self;
}
- (CCGroup *)build
{
    return [[CCGroup alloc] initWithBuilder:self];
}
- (void)mergeWithModel:(CCGroup *)modelObject
{
    NSParameterAssert(modelObject);
    CCGroupBuilder *builder = self;
    if (modelObject.groupDirtyProperties.CCGroupDirtyPropertyCreatedAt) {
        builder.createdAt = modelObject.createdAt;
    }
    if (modelObject.groupDirtyProperties.CCGroupDirtyPropertyIdentifier) {
        builder.identifier = modelObject.identifier;
    }
    if (modelObject.groupDirtyProperties.CCGroupDirtyPropertyMemberCount) {
        builder.memberCount = modelObject.memberCount;
    }
    if (modelObject.groupDirtyProperties.CCGroupDirtyPropertyName) {
        builder.name = modelObject.name;
    }
    if (modelObject.groupDirtyProperties.CCGroupDirtyPropertyPicture) {
        id value = modelObject.picture;
        if (value != nil) {
            if (builder.picture) {
                builder.picture = [builder.picture mergeWithModel:value initType:PlankModelInitTypeFromSubmerge];
            } else {
                builder.picture = value;
            }
        } else {
            builder.picture = nil;
        }
    }
    if (modelObject.groupDirtyProperties.CCGroupDirtyPropertyUpdatedAt) {
        builder.updatedAt = modelObject.updatedAt;
    }
}
- (void)setCreatedAt:(NSDate *)createdAt
{
    _createdAt = [createdAt copy];
    _groupDirtyProperties.CCGroupDirtyPropertyCreatedAt = 1;
}
- (void)setIdentifier:(NSInteger)identifier
{
    _identifier = identifier;
    _groupDirtyProperties.CCGroupDirtyPropertyIdentifier = 1;
}
- (void)setMemberCount:(NSInteger)memberCount
{
    _memberCount = memberCount;
    _groupDirtyProperties.CCGroupDirtyPropertyMemberCount = 1;
}
- (void)setName:(NSString *)name
{
    _name = [name copy];
    _groupDirtyProperties.CCGroupDirtyPropertyName = 1;
}
- (void)setPicture:(CCGroupPicture *)picture
{
    _picture = picture;
    _groupDirtyProperties.CCGroupDirtyPropertyPicture = 1;
}
- (void)setUpdatedAt:(NSDate *)updatedAt
{
    _updatedAt = [updatedAt copy];
    _groupDirtyProperties.CCGroupDirtyPropertyUpdatedAt = 1;
}
@end
