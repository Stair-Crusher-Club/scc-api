# SCC API Specification Guidelines

OpenAPI 3.0 스펙 (Source of Truth). YAML 작성 절차/예제/패턴은 `/scc-api-spec-design` skill 참조.

## 파일 구성

| 파일 | 용도 | 소비자 |
|------|------|--------|
| `api-spec.yaml` | 사용자/클라이언트 API | scc-app, scc-server |
| `admin-api-spec.yaml` | 어드민 API | scc-admin, scc-server |

## Naming (MANDATORY)

- **모든 component schema는 `Dto` suffix** — enum 타입도 동일 (`PlaceDoorDirectionTypeDto`, `FloorMovingMethodDto`)
  - 이유: 스펙 일관성 + 백엔드 Kotlin DTO 클래스와 정렬 + codegen 안정성
- 타임스탬프: `~~At` suffix = `EpochMillisTimestamp` $ref, `~~Date` suffix = `format: date-time` 문자열
- operationId: camelCase 동사+명사 (`listPlaces`, `registerPlaceAccessibility`)

## Versioning

- V2 API는 closed beta용 — V1 하위 호환을 유지한 채 독립 진화하도록 **별도 V2 suffix DTO** 사용 (예: `POST /v2/registerPlaceAccessibilityV2`)
- 하위 호환: 기존 필드 제거/required 전환 금지

## Idempotency

- 등록(POST) 엔드포인트는 `X-SCC-REQUEST-ID` 헤더 지원 (optional) — 중복 요청 시 이전 결과 반환, tracing/logging에도 사용

## Schema Reusability

- 관련 필드는 flat 나열 대신 별도 DTO로 묶고, 동일 enum이 3곳 이상 반복되면 별도 스키마로 분리해 `$ref` 참조
- 새 스키마 작성 전 기존 `components/schemas`에서 재사용 가능한 것을 먼저 검색
- 표준 Register Request/Response 구조와 예시는 `/scc-api-spec-design` 참조

---

이 파일은 fact만 담는다. 작성 절차/예제는 `/scc-api-spec-design`, 강제 규칙은 workspace `.claude/hooks/` 참조. 줄수 상한 120.
