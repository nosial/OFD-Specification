# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [2.1-R1] - Ongoing

This is an ongoing update


## [2.1] - 2026-10-28

This is an ongoing update. It is a minor version: hosts report `2.1` as the `api_version`, and it is backward
compatible with 2.0.

### Added
- Scan Content accepts files, such as the images of a message, with the content it scans. A request that carries files
  is a `multipart/form-data` body: each file is carried in a part of its own, the `evidence` and `concerns` parts carry
  the JSON text of their values, and a ContentInput object names the parts of its files in a new `files` member. A
  ContentInput object with files may omit `text_content`. JSON requests are unchanged.
- Every host of version 2.1 accepts files for scanning, but may ignore the files of every request, or of requests
  without client permissions, treating them as files it does not interpret. A client does not need to know whether a
  host scans files before submitting them.
- The `max_scan_files` and `max_scan_file_size` members of the ServerInformation object announce the limits a host
  places on the files of a scan request. A host does not announce the media types it interprets.
- A file of a media type the host does not interpret is not an error: the host scans the rest of the content without
  it, so content consisting only of such files keeps the starting risk score of 50.
- Scanned files are not stored: a host discards them after the scan unless it creates evidence from the content, in
  which case it records them as file attachments of that evidence.
- The `file_index` member of the Detection object identifies the file of a ContentInput object a detection relates to.
- Security and privacy considerations for decoding scanned files and for the metadata they carry.


## [2.0] - 2026-10-20

This is an ongoing update. It is a new major version: hosts report `2.0` as the `api_version`, and it is not
backward compatible with 1.x.

### Breaking
- The OperatorRecord object groups its permission groups in a `permissions` member (an OperatorPermissions object
  with `client`, `management` and `operator`) and its settings in a `configuration` member (an
  OperatorConfiguration object), replacing the `client_permissions`, `management_permissions`, `operator_permissions`
  and `auto_assign` members. `permissions.client` is true whenever `permissions.management` is, since management
  permissions inherit client permissions.
- The Update Operator Permissions (`PATCH /operators/{uuid}/permissions`) and Update Operator Configuration
  (`PATCH /operators/{uuid}/configuration`) methods replace Manage Client Permissions, Manage Management Permissions,
  Manage Operator Permissions and Manage Auto Assign. Each takes a partial object and returns the updated object;
  leaving an operator with management permissions but without client permissions is rejected with HTTP 409.
- `auto_assign` is replaced by the `auto_assign_reports` and `auto_assign_automated_reports` configuration settings,
  opting in to the automatic assignment of ordinary and automated reports separately; a host never assigns a report
  automatically to an operator that has not opted in to reports of its kind.

### Added
- The report supporting a blacklist record may concern another entity than the one being blacklisted (eg; the domain a
  reported account advertised), a host no longer rejects it with HTTP 404.
- The `configuration` member of an OperatorRecord is only disclosed to the operator itself and to operators with operator
  permissions, and is null for anyone else. An operator may read and change its own configuration with Update Operator
  Configuration; changing another operator's configuration requires operator permissions.
- Bot operators: the `is_bot` configuration setting makes the evidence and reports an operator submits automated.
- The `automated` member of the EvidenceRecord object, and the `AUTOMATED` and `NOT_AUTOMATED` evidence categories.
  Evidence the host creates itself or a bot operator submits is automated, and automated evidence is created as
  confidential; an operator with management permissions may make it non-confidential afterwards. Reports submitted by
  a bot operator are automated like the reports a host creates itself (Automated Records section).
- Download Attachment responses carry `X-Content-Type-Options: nosniff`.
- Hosts answer CORS preflight (`OPTIONS`) requests without authentication, and `Access-Control-Allow-Origin`
  carries the origin of the base URL rather than the full URL.
- Parameters of a file upload may be carried in the parts of its `multipart/form-data` body.
- Deletion of Records section: a host may delete or retain the records that refer to a deleted record, so references
  can yield HTTP 404; `FileAttachmentRecord.evidence` is null when no evidence record is associated.
- Resource Exhaustion security consideration, permitting HTTP 429 for requests that exceed a host's limits.
- URL uploads: Upload Attachment accepts a `url` parameter as an alternative to `file`, and the host retrieves the
  file itself. Support is optional and advertised by the new `allow_url_uploads` member of the ServerInformation
  object. Hosts MUST guard retrievals against server-side request forgery, covered
  by the new Remote Retrieval security consideration.
- The `collects_public_scan_content` member of the ServerInformation object, stating whether the host may store
  content submitted to Scan Content by unauthenticated requests, or records derived from it such as automated
  reports and evidence.
- Telephone entities: a telephone number is the named entity `<number>@e164.arpa`, whose local part is the E.164
  international number as 1 through 15 digits without `+` or separators. Unless a host publishes the new
  `public_telephone_entities` member of the ServerInformation object as true, unauthenticated requests see a
  telephone entity only when they identify it by its address or SHA-256 identifier, or submit it for scanning: it is
  omitted from lists, searches and related entities, unresolvable by UUID, stripped of metadata, and kept out of
  audit log messages. Evidence a host creates itself about a telephone entity, including scanned content supporting
  an automated report, MUST be confidential. Scan Content may extract numbers (`telephone` entity positions), and
  hosts are cautioned that presented numbers can be spoofed.
- Content types: the ContentInput object accepts a `content_type` (`TEXT`, `EMAIL`, `SMS`, `WEB_PAGE`, `HOSTNAME` or `URL`,
  defaulting to `TEXT`) and a flat `context` object whose keys are defined per content type. EvidenceRecord carries
  both members. Scan Content interprets the content types published in the new `scan_content_types` member of the
  ServerInformation object, and MAY resolve the names and retrieve the URLs it is given under the restrictions of
  URL uploads.
- Concerns: Scan Content accepts a `concerns` array and Query Entity a `concerns` parameter naming the incident types
  to assess. Only these concerns affect the classification, risk score, suggested action and detections returned,
  and the blocking suggested actions consider only blacklist records of these types. Hosts publish `concerns` and
  `default_concerns` in the ServerInformation object, and SHOULD NOT assess `ADVERTISING` or `TRACKING` by default.
- The `detections` member of the ScannedContent object and the Detection object, recording the concern, the
  mechanism, the related entity and content, and whether the detection relies on unverified client assertions.
- `ADVERTISING` and `TRACKING` incident types.
- A `type` filter on List Blacklist and Search Blacklist selecting records by incident type.
- Client Assertions section: what a client submits is an assertion; a host SHOULD verify what it can determine
  itself, MUST prefer its own observation, and MUST NOT degrade an entity solely because it was submitted for
  scanning. Abuse of the Database and Content Scanning considerations cover fabricated submissions and the privacy
  of submitted names, URLs and retrievals.
- Clients tolerate values they do not recognize in sets of values, which a minor version may extend, and treat an
  unrecognized incident type as `OTHER`.
- Versioning section defining the `MAJOR.MINOR` interface version, backward compatibility between minor versions,
  and how clients use `api_version` to detect supported features.
- The `report` member of the AuditLog object.
- HTTP 409 among the error status codes, as already used by several methods.
- The successful response of every method.

### Fixed
- A request to a publicly accessible method is no longer rejected because of its token: a valid token still
  authenticates its operator, so it can receive information returned only to operators such as entity metadata,
  while a malformed, unknown or disabled token is ignored and the request is processed as unauthenticated.
  Authenticating no longer reduces access (affecting entity metadata, Scan Content and List Operator Audit Logs),
  and List Operator Audit Logs states which entries each requester receives.
- The List Audit Logs example path, and the Path Structure section now notes that other audit methods are served
  under `/audit`.
- Ordering values for `by` are uppercase; hosts SHOULD still accept them case-insensitively.
- Blocking suggested actions consider active blacklist records only.
- The `LIFTED` category of List Blacklist selects lifted records regardless of `include_lifted`.
- Update Operator Name checks reserved names case-insensitively, as Create Operator does.
- Report category values apply to every method that lists or searches reports.
- The ContentInput object permits members added by methods that extend it.
- The Permission Groups section includes managing operator configuration among operator permissions.
- An access token is disclosed exactly once, in the response that creates the operator or generates the token, and
  only a hash of it is persisted, so the requester must retain it; Generate Access Token and Generate Operator Access
  Token now state this as Create Operator does.
- The permission matrix and Scan Content no longer deny public content scanning to an authenticated operator
  without client permissions.
- A client SHOULD NOT submit a URL upload to a host that does not publish `allow_url_uploads` as true, consistent
  with the Versioning section.
- The route conventions describe PUT as an optional alternative to POST for uploads.
- Every search method lists HTTP 400 among its error conditions.
- The permission matrix and the management permissions definition include classifying evidence and linking it to
  reports.
- The cross-collection Search method matches each record type against the members of its dedicated search method.
- A host accepts a JSON request body whether or not its media type carries a `charset` parameter.
- Entity identifiers are resolved in a fixed order (UUID, SHA-256 identifier, entity address), path segments are
  percent-decoded once before validation, and internationalized domain names are represented by their A-labels.
- Access tokens, including the root access token, use `b64token` characters; hosts SHOULD give them at least 128 bits
  of entropy.
- Query Entity defines the relationship group, and hosts that follow relationships further terminate on cycles.
- Suggested action values describe the entity they refer to for both Scan Content and Query Entity.
- Push Entity is idempotent for any repeated registration and lists non-canonical addresses among its HTTP 400
  conditions.
- The cross-collection Search method returns file attachments only to operators with management permissions, as
  Search Attachments does.
- Create Operator states that default permission groups, the default configuration, and case sensitivity of
  name uniqueness are host-defined; Delete Operator discourages self-deletion, which a host MAY reject.
- Set Entity Relationship permits a host to reject a relationship of an entity to itself.
- Close Report ignores `blacklist_expires` when `blacklist_incident_type` is absent.
- A note lists the status codes retained from 1.0 that differ from the general definitions of HTTP 400, 403, 404 and
  409, and the parameter precedence order is noted as retained for compatibility.
- Deleting a file attachment, including one deleted with its evidence, deletes its stored file. An attachment
  retained without evidence is treated as the attachment of confidential evidence, and Delete Attachment no longer
  responds with HTTP 404 because its evidence is missing.
- Upload Attachment attaches files only to evidence the operator submitted, unless it holds management permissions,
  and otherwise responds with HTTP 403.
- Update Evidence Confidentiality rejects making evidence linked to an `ILLEGAL_CONTENT` report non-confidential with
  HTTP 409.
- A host assigns reports automatically only to enabled operators with management permissions, which can close them.
- Assign Operator to Report rejects closed reports with HTTP 400.
- Close Report rejects `blacklist_incident_type` for a report that concerns no entity with HTTP 400, and the
  `reporting_entity` member of the ReportRecord object describes when it is null instead of calling such a report
  anonymous.
- Extend Blacklist rejects an expired blacklist record with HTTP 400.
- A host that deletes the records of a deleted operator requires management permissions to delete an operator that
  created evidence, reports or blacklist records, and otherwise responds with HTTP 403.
- Clients percent-encode `+`, `%`, `&`, `=` and `#` in an entity address carried in a query string or form body, and
  hosts reject a path segment that contains `/` after decoding with HTTP 400.
- Hosts reject entity addresses whose entity host is a subdomain of `e164.arpa`, such as the ENUM domain of a number,
  with HTTP 400.
- Scan Content rejects an `author` that is not a string, or that names the `e164.arpa` namespace without being a
  canonical telephone entity, with HTTP 400.
- Query Entity omits from `active_blacklists` the blacklist records of hidden telephone entities other than the
  queried entity.
- Update Entity lists metadata constraint violations among its HTTP 400 conditions, the general success response rule
  names the methods that create records with HTTP 200, and public methods describe confidential evidence as requiring a
  permission group rather than only authentication.
- Incorrect references, identifier wording and minor editorial issues, including request examples
  of authenticated methods, which now show the `Authorization` header; terminology is listed alphabetically.

### Changed
- Hosts implementing this version report `2.0` as the `api_version`.
- The File Uploads section and the `file_name` member of the FileAttachmentRecord object cover URL uploads.
- Classify Evidence replaces the classification of evidence that is already classified instead of rejecting the
  request with HTTP 409; a request with the classification the evidence already has succeeds without changing it.



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