# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),

## [1.1] - Ongoing

This is an ongoing update

### Added
- URL uploads: Upload Attachment accepts a `url` parameter as an alternative to `file`, and the host retrieves the
  file itself. Support is optional and advertised by the new `allow_url_uploads` member of the ServerInformation
  object (treated as false when absent). Hosts MUST guard retrievals against server-side request forgery, covered
  by the new Remote Retrieval of Attachments security consideration.
- Versioning section defining the `MAJOR.MINOR` interface version, backward compatibility between minor versions,
  and how clients use `api_version` to detect supported features.
- The `report` member of the AuditLog object.
- HTTP 409 among the error status codes, as already used by several methods.
- The successful response of every method.

### Fixed
- A token presented to a method that does not require authentication is ignored rather than validated, and
  authenticating no longer reduces access (affecting entity metadata, Scan Content and List Operator Audit Logs).
- The List Audit Logs example path, and the Path Structure section now notes that other audit methods are served
  under `/audit`.
- Ordering values for `by` are uppercase; hosts SHOULD still accept them case-insensitively.
- Blocking suggested actions consider active blacklist records only.
- The `LIFTED` category of List Blacklist selects lifted records regardless of `include_lifted`.
- Update Operator Name checks reserved names case-insensitively, as Create Operator does.
- Report category values apply to every method that lists or searches reports.
- The ContentInput object permits members added by methods that extend it.
- The Permission Groups section includes managing the `auto_assign` flag among operator permissions.
- Incorrect references, identifier wording and minor editorial issues; terminology is listed alphabetically.

### Changed
- Hosts implementing this version report `1.1` as the `api_version`.
- The File Uploads section and the `file_name` member of the FileAttachmentRecord object cover URL uploads.



## [1.0-R4] - 2026-10-01

This update introduces changes to the specification

### Changed
- Set Entity Relationship and Clear Entity Relationship now require client permissions instead of operator
  permissions, so management permissions, which inherit client permissions, cover them too. Operator permissions no
  longer authorize them. The "Manage entity relationships and tags" row of the permission matrix is split into
  "Manage entity relationships" (client and manager) and "Update evidence tags" (operator manager, unchanged).
- Removing the leading `www.` label from a DNS entity host is now repeated while another removable `www` label
  leads the host, so `www.www.example.com` canonicalizes to `example.com`.

### Added
- Abuse of the Database security consideration for clients relating a legitimate entity to one about to be
  blacklisted, where a host propagates reputation through entity relationships.



## [1.0-R3] - 2026-09-30

This update introduces safeguards into the specification

### Added
- Added the `allow_illegal_content` member to the ServerInformation object. A host MAY decline to handle illegal
  content; such a host publishes `allow_illegal_content` as false and MUST reject Submit Report requests with the
  `ILLEGAL_CONTENT` incident type with HTTP 403.

### Changed
- Evidence created by Submit Report with the `ILLEGAL_CONTENT` incident type, or linked to such a report by Add
  Evidence to Report, MUST be marked as confidential regardless of the submitted `confidential` value. The
  Confidential Evidence security consideration was extended accordingly.
- Close Report now permits a host to also adjust the reputation of existing entities mentioned in the report's
  evidence, identified with the same named entity extraction as Scan Content, at most once per entity per report.



## [1.0-R2] - 2026-09-29

This update introduces a change in the specification where operators are no longer kept behind authentication, rather
operators should be publicly accessible.

### Changed
- List Operators (`GET /operators`), Get Operator (`GET /operators/{uuid}`) and Search Operators
  (`GET /operators/search`) are now public; a host MUST NOT require authentication for them, and they no longer list
  HTTP 401 (or, for List Operators, HTTP 403) as an error condition.
- Operator records are now included in the results of the cross-collection Search method for every requester, and
  Search Operators counts as a publicly accessible dedicated search method.
- Split the "Read operator accounts" row of the permission matrix: reading operator accounts is public, while Get Self
  Operator still requires an authenticated operator. The "List operators" row, which required operator permissions,
  is folded into "Read operator accounts".
- Documented the successful response of Get Operator.

### Added
- Privacy consideration for operator records being public.


## [1.0-R1] - 2026-09-28

This update introduces corrections to the specification

### Changed
- Changed entity identifier segment handling to accept all forms and enforce canonicalization
- Updated documentation for clarity and consistency, updated references to standards, and improved readability.


## [1.0] - 2026-09-27

Initial release of the OFD-Specification