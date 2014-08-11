# URL Arbiter

Minimal API to arbitrate URLs on GOV.UK.  This maintains a list of all the URL
paths in use on GOV.UK, and for each one records which publishing app owns that
path.

## API Endpoints

### Reserving a path

To reserve a path:

``` sh
curl http://url-arbiter-api.example.com/paths/foo/bar -X PUT \
    -H 'Content-type: application/json' \
    -d '{"publishing_app": "foo_publisher"}'
```

This will return a 200 or 201 status on success.

A 409 status will be returns if the path has already been reserved by a
different publishing application.

A 422 status will be returned for any validation errors, and the JSON response
will include an "errors" key with more details.
