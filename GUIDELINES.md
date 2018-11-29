# Teamleader API Design Guidelines

## General guidelines

### Endpoints

We are creating an *RPC*-style HTTP API, similar to the [Slack API](https://api.slack.com/methods). Our API endpoints follow a `resource`.`action` structure.

These are common actions for resources:

 - **resource.list** - Get a list objects
 - **resource.info** - Information about a single object
 - **resource.create** - Create a new object (*try to look for better domain language*)
 - **resource.add** - Adding existing objects to a collection (*try to look for better domain language*)
 - **resource.update** - Update an existing object (*try to look for better domain language*)
 - **resource.delete** - Delete an existing object (*try to look for better domain language*)

Usually there will be other actions available for your resource. We need to make sure we make these as explicit and clear as possible. Eg. `invoice.draft` is better than `invoice.create`.

### Casing

For casing, we agreed the following:

- The resource and action of the API endpoint are camelCased
- The API endpoint parameters are snake_cased
- All json properties in a request/response are snake_cased

```
/myResource.myAction?my_parameter=value
```

### Abbreviations

We avoid abbreviations, for clarity. There are exceptions however:

- The `id` field
- Abbreviations common in the **domain** such as `VAT`

### Ids

Ids are **always** returned as uuids. Currently these can not be defined by the client, and are generated on our side.

### Paging

Paging is 1-based. This means that `page.number: 1` returns the very first page.

## HTTP

### Methods

All API endpoints support `POST` requests with a `json` body. For simplicity we also allow `GET` requests on endpoints which are used to retrieve data such as info or list endpoints.

```json
POST deals.list
{
  "page": {
    "size": 10,
    "number": 1
  },
  "filter": {
    "company_id": 123
  }
}
```

### Status codes

We try to interpret HTTP Status codes the right way:

 - `200` - OK
 - `201` - Created, when resources are created
 - `204` - No Content, on resource updates or actions
 - `400` - Bad Request, the request contains invalid data or references non-existing resources
 - `401` - Unauthorized, invalid or missing access token
 - `403` - Forbidden, not allowed to access this resource
 - `404` - Not Found, resource not found
 - `429` - Too Many Requests, client has reached the API rate limit
 - `500` - Internal Server Error, something went wrong on our end

### Content-Type & Accept headers

 - `application/json` or `application/json;charset=utf-8` for request accept headers
 - `application/json;charset=utf-8` for response content-type headers

## Response format

### Fetching objects

Endpoints used to read single or multiple objects **MUST**:

 - Respond with the `200` HTTP status code
 - Return a top level `data` property containing a single object or a list of objects

And **MAY**:

 - Allow filters using the `filter` request parameter
 - Allow an `ids` filter to fetch multiple objects by id
 - Allow pagination using the `page` request parameter
 - Return pagination information in the `meta` response attribute

### Creating objects

Endpoints used to create new objects **MUST**:

 - Return the `id` and `type` of the new object in a top-level `data` attribute
 - Respond with the `201` HTTP status code

### Updating objects

Endpoints used to update existing objects **MUST**:

 - Not have unexpected side effects
 - Respond with an empty response and the `204` HTTP status code

### Errors

When an error occurs, the endpoint **MUST**:

 - Respond a status code that corresponds to the type of error
 - Return a top-level `errors` attribute containing one or more errors

Each error object **MUST**:

 - Have a `title` attribute; a short human readable summary of the problem

The error objects **MAY** have the following members:

 - `code`: an application specific error code to identify where the error is coming from
 - `meta`: additional non-standard meta information about this error

Example of a `400 Bad Request` error:

```json
{
  "errors": [
    {
      "code": 123,
      "title": "Company name must not be empty",
      "status": 400,
      "meta": {
        "field": "name"
      }
    }
  ]
}
```

## Designing properties

### Adding and modifying endpoints

Adding endpoints and properties are typically always non-breaking and backwards compatible. Modifying, renaming and removing endpoints and properties is allowed during the beta period. Once our API is released, we will tag our API with a new version for each breaking change.

### Response Empty properties

Object properties without a value **MUST**:

 - Return null for scalar values
 - Return an empty array if the property returns a list of objects/values

Example:

```json
{
  "data": {
    "id": "ee72ae60-d4df-4f27-beec-d105d5b3e170",
    "name": "John Doe",
    "email": null,
    "tags": []
  }
}
```

### Request Nullable/Optional properties

#### When to use `null` in properties

1. When you want to update a property and unassign its value.
2. If the property is optional and you are creating it you might want to use `null` to avoid the `if`s burden.

#### When not to use `null` in properties

1. Whenever you are updating a property that is optional/nullable and has a value assigned you don't want to remove.

#### Nullable vs Optional

When you set a property to `null` your intention is to remove any assigned value to it.
When a property is optional you don't need to send the key in your request. The value will remain unchanged.

**Note:** `Nullable` applies to the value of the property and `Optional` applies to the key of that property in the payload.

#### Note on Empty strings

Accepting empty strings does not have any meaning. If the goal is to unassign the value of a property then you should use `null` instead of an empty string.

#### Note on Collections

When the property you are updating is a collection, you **MUST** send all elements you want to keep or modify otherwise they will be removed.

### Date and time

Dates, times and datetimes returned must follow the `ISO8601` standard. In PHP this can be generated using `format(DATE_ATOM)`.

Date and datetime properties **MUST**:

 - The property name ends on `_on` for dates.
 - The property name ends on `_at` if they include time (time and datetime).
 - Always be returned in `UTC` (except for some rare domain cases like Calendar events). It is the responsibility of the client to offset the timezone for users.

Examples:

```json
{
  "contacted_on": "2017-10-13",
  "updated_at": "2017-10-15T10:01:49+00:00",
  "available_at": "11:00:00",
}
```

Writing datetime properties **MUST** accept every timezone.

### Money

Monetary values in requests and responses **MUST** be represented as the following data structure:

```json
{
    "amount": 123.03,
    "currency": "EUR"
}
```

### Rich text, html, markdown

Rich text fields **MUST** be returned (and accepted) in **markdown**.


### Creating relationships

If a relation can exist with different types of objects, the request **MUST**:

 - Contain an object structure with both the `id` and `type` of the related object

The support types of related objects will be documented.

Example of a customer that can be both a contact or company:

```json
{
   "customer": {
      "type": "contact",
      "id": "ee72ae60-d4df-4f27-beec-d105d5b3e170"
   }
}
```

If the relation can only exist with a single type of object, we allow a simplified request:

```json
{
   "project_id": "ee72ae60-d4df-4f27-beec-d105d5b3e170"
}
```

### Returning relationships

Object relationships in responses **MUST**:

 - Return the `id` and `type` of the related object

Example:

```json
{
   "customer" : {
      "type": "contact",
      "id": "ee72ae60-d4df-4f27-beec-d105d5b3e170"
   }
}
```

This allows us to identify side loaded objects and add meta data in the future.
