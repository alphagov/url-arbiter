# URL Arbiter

Minimal API to arbitrate URLs on GOV.UK.  This maintains a list of all the URL
paths in use on GOV.UK, and for each one records which publishing app owns that
path.

## API Endpoints

### Getting details about a path

To get details of a path:

``` sh
curl http://url-arbiter-api.example.com/paths/foo/bar
```

This will return details of the reserved path as JSON - eg:

``` json
{
  "path": "/foo/bar",
  "publishing_app": "foo_publisher",
  "created_at": "2014-08-13T13:25:17.184Z",
  "updated_at": "2014-08-13T13:25:17.184Z"
}
```

### Reserving a path

To reserve a path:

``` sh
curl http://url-arbiter-api.example.com/paths/foo/bar -X PUT \
    -H 'Content-type: application/json' \
    -d '{"publishing_app": "foo_publisher"}'
```

This will return a 200 or 201 status on success along with JSON details as above.

A 409 status will be returned if the path has already been reserved by a
different publishing application.

A 422 status will be returned for any validation errors.

These errors will also include a JSON response including an "errors" field with
any error messages.
