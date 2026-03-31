# SCC API Specification Guidelines

## Naming Conventions

### DTO Naming Rule

**IMPORTANT**: All OpenAPI component schemas MUST end with `Dto` suffix.

#### Examples

✅ **Correct**:
- `RegisterPlaceAccessibilityRequestDtoV2`
- `RegisterPlaceAccessibilityResponseDtoV2`
- `RegisterBuildingAccessibilityRequestDtoV2`
- `RegisterBuildingAccessibilityResponseDtoV2`
- `PlaceDoorDirectionTypeDto`
- `BuildingDoorDirectionTypeDto`
- `FloorMovingMethodDto`
- `ElevatorAccessibilityDto`

❌ **Incorrect**:
- `RegisterPlaceAccessibilityRequestV2` (missing Dto suffix)
- `RegisterPlaceAccessibilityResponse` (missing Dto suffix)
- `PlaceDoorDirectionType` (missing Dto suffix)
- `FloorMovingMethod` (missing Dto suffix)

#### Rationale

This naming convention ensures consistency across the API specification and makes it clear that these are Data Transfer Objects used for API communication. It also helps with code generation and maintains alignment with backend Kotlin DTO classes.

## API Versioning

### V2 APIs for Closed Beta

V2 APIs are created for closed beta testing with new features while maintaining backward compatibility with V1 APIs.

**Endpoints**:
- `POST /v2/registerPlaceAccessibilityV2` - 장소 입구 접근성 정보 등록
- `POST /v2/registerBuildingAccessibilityV2` - 건물 입구 및 엘리베이터 접근성 정보 등록

**Key Features**:
- Separate DTOs (V2 suffix) to allow independent evolution
- Idempotency support via `X-SCC-REQUEST-ID` header
- Enhanced fields for detailed entrance and elevator information

## Idempotency

All registration endpoints support idempotency via the `X-SCC-REQUEST-ID` header:

```yaml
parameters:
  - $ref: '#/components/parameters/SccCommonHeaders'
```

The `X-SCC-REQUEST-ID` header:
- Optional (not required)
- Used for tracing, logging, and idempotency
- Prevents duplicate registrations when clients retry requests
- Returns previous result for duplicate request IDs

## Schema Reusability

### 관련 필드는 DTO로 묶기
flat하게 나열하지 말고, 관련 필드를 별도 DTO로 그룹핑한다.
- 나쁜 예: `bbucleRoadType`, `bbucleRoadUrl`, `thumbnailImageUrl`을 각각 flat 필드로
- 좋은 예: `bbucleRoadData: AdminBbucleRoadDataDto`로 묶기

### Enum 중복 제거
동일한 enum이 3곳 이상 반복되면 별도 스키마(`BbucleRoadTypeDto` 등)로 분리하고 `$ref`로 참조한다.

### Common Schemas

Reuse common schemas across different endpoints to maintain consistency:

**Example**: `ElevatorAccessibilityDto`
```yaml
ElevatorAccessibilityDto:
  type: object
  description: 엘리베이터 접근성 정보
  properties:
    elevatorImageUrls:
      type: array
      items:
        type: string
    elevatorStairInfo:
      $ref: '#/components/schemas/StairInfo'
    elevatorStairHeightLevel:
      $ref: '#/components/schemas/StairHeightLevel'
    hasSlope:
      type: boolean
```

This schema is used in:
- `RegisterPlaceAccessibilityRequestDtoV2`
- Can be used in future building-related endpoints

## Enum Naming

Enum types should also follow the Dto suffix convention:

- `PlaceDoorDirectionTypeDto`
- `BuildingDoorDirectionTypeDto`
- `FloorMovingMethodDto`

## Common Patterns

### Registration Request DTO Structure

```yaml
Register{Entity}AccessibilityRequestDtoV2:
  type: object
  description: {설명}
  properties:
    {entity}Id:
      type: string
    # ... other fields
  required:
    - {entity}Id
    - imageUrls
    - stairInfo
    - hasSlope
```

### Registration Response DTO Structure

```yaml
Register{Entity}AccessibilityResponseDtoV2:
  type: object
  description: {설명}
  properties:
    accessibilityInfo:
      $ref: '#/components/schemas/AccessibilityInfoDto'
    registeredUserOrder:
      type: integer
    contributedChallengeInfos:
      type: array
      items:
        $ref: '#/components/schemas/ContributedChallengeInfoDto'
  required:
    - accessibilityInfo
    - registeredUserOrder
```
