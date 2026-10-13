# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),

## [1.1] - Ongoing 

This is an ongoing update

### Added
 - Upload Attachment accepts a `url` parameter as an alternative to the `file` part, from which the host retrieves the
   file itself (a URL upload). The parameter may be carried in a JSON, form-encoded or multipart body, and a request
   supplying both `file` and `url`, or neither, is rejected with HTTP 400. A host MAY decline to support URL uploads.
   A host MUST reject URLs that are not HTTP or HTTPS or contain user information, MUST NOT retrieve from addresses
   that are not publicly routable unless explicitly configured to, MUST apply the same checks to redirect targets, and
   MUST reject failed, non-2xx, empty or oversized retrievals with HTTP 400. The file name of a URL upload is taken
   from the `Content-Disposition` header of the response, or the last segment of the URL path.
 - Remote Retrieval of Attachments security consideration on server-side request forgery through URL uploads.
 - Added the `allow_url_uploads` member to the ServerInformation object. A host that declines to support URL uploads
   MUST publish it as false, and a client MUST treat it as false when absent, as it is for hosts implementing 1.0.
 - Versioning section defining the interface version as `MAJOR.MINOR`. Minor versions are backward compatible with
   earlier minor versions of the same major version and may only add methods, optional parameters, response members
   and optional capabilities; changes that break compatibility increment the major version. Clients SHOULD check the
   `api_version` of a host before relying on behavior introduced after 1.0, MUST NOT use features newer than the
   version the host reports, and MUST ignore unrecognized members of response objects.
 - Added the `report` member to the AuditLog object, carrying the UUID of the affected report when applicable.
 - HTTP 409 is defined among the error status codes, for requests that conflict with the current state of a record,
   as already used by Create Operator, Update Operator Name and Classify Evidence.
 - Every method now states its successful response: the record or array of records it reads, or the success envelope
   for methods that produce no result data, as already implied by the Success Responses section.

### Fixed
 - A token presented to a method that does not require authentication is ignored like an unaccepted parameter: it
   is not validated and is not an error, and the request is processed as unauthenticated. A request requires
   authentication when its method or domain is not public or when it asks for information returned only to an
   authenticated operator, such as confidential evidence. Entity metadata visibility and the client permission
   requirement for Scan Content were aligned with this rule.
 - List Operator Audit Logs restricts an operator without operator permissions to its own entries only when the
   audit log is not public, so authenticating no longer reduces access.
 - The List Audit Logs request example uses the root path `/`, where the method is served, and the Path Structure
   section notes that the other audit methods are served under `/audit`.
 - Ordering values for the `by` parameter are uppercase strings, as required for values drawn from a fixed set.
   Hosts SHOULD continue to accept them case-insensitively.
 - The `PERMANENTLY_BLOCK_ENTITY` and `TEMPORARILY_BLOCK_ENTITY` suggested actions are based on active blacklist
   records only.
 - In List Blacklist, the `LIFTED` category selects lifted records regardless of `include_lifted`.
 - Update Operator Name compares the reserved names case-insensitively and lists reserved names among its HTTP 400
   conditions, as Create Operator does.
 - Report category values apply to every method that lists or searches reports, not only the operator report
   methods.
 - The ContentInput object permits the members added by a method that extends it, such as Submit Evidence.
 - The Permission Groups section includes managing the `auto_assign` flag among operator permissions, as the
   terminology does.
 - Corrected references to value definitions and method names, entity host and SHA-256 identifier wording, and
   minor editorial issues; the terminology is listed alphabetically.

### Changed
 - A host implementing this version of the specification reports `1.1` as the `api_version` member of the
   ServerInformation object.
 - The File Uploads section describes both direct uploads and URL uploads, and the `file_name` member of the
   FileAttachmentRecord object may be derived from the URL a file was retrieved from.



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