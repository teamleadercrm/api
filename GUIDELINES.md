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

We avoid abbreviations, for clarity.

There are exceptions however:

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
 - `400` - Bad Request, if the request contains invalid data
 - `401` - Unauthorized, invalid or missing access token
 - `403` - Forbidden, not allowed to access this resource
 - `404` - Not Found, resource not found
 - `429` - Too Many Requests, client has reached the API rate limit
 - `500` - Internal Server Error, something went wrong on our end

### Content-Type & Accept headers

 - `application/json` or `application/json;charset=utf-8` for request accept headers.
 - `application/json;charset=utf-8` for response content-type headers.

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

## Designing properties

### Adding and modifying endpoints

Adding endpoints and properties are typically always non-breaking and backwards compatible. Modifying, renaming and removing endpoints and properties is allowed during the beta period. Once our API is released, we will tag our API with a new version for each breaking change.

### Empty properties

If a property has an empty value, we return `null` as value.

```json
{
  "data": {
    "id": "ee72ae60-d4df-4f27-beec-d105d5b3e170",
    "name": "John Doe",
    "email": null
  }
}
```

### Date and time

Dates, times and datetimes returned must follow the `ISO8601` standard. Times and datetimes may include timezone information. In PHP this can be generated using `format('c')`.

We follow these rules for the property names:

 - Dates must end on `_on`.
 - Time and datetimes must end on `_at`.

Examples:

```json
{
  "contacted_on": "2017-10-13",
  "updated_at": "2017-10-15T10:01:49+01:00",
  "available_at": "11:00:00",
}
```

### Money

When representing money in requests or responses, we must always follow this data structure:

```json
{
    "amount": 123.03,
    "currency": "EUR"
}
```

### Relationships

When referring to related objects, we always use a relation structure that includes the type of the related object. This way there is no difference between regular and dynamic relationships where the related object can have different types.

Example:

```json
{
   "buyer" : {
      "type": "contact",
      "id": "ee72ae60-d4df-4f27-beec-d105d5b3e170"
   }
}

```

This also allows us to add meta data in the future.
