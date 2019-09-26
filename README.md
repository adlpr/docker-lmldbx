# lmldbx

Webapp for serving transformed LMLDB XOBIS-XML data from Postgres.

## API reference

| endpoint | returns |
|---:|:---|
| /record/{id}  | full record view |
| /related/{id} | list of IDs of records containing a relationship to the given ID |
| /list/{pe} | list of IDs of records containing a main entry of that principal element type |
| ~~/relationships/{id}~~ | ~~experimental relationship view ?~~ |
|   |   |
|   |   |

```
pe ∈ (being|concept|event|language|object|organization|place|string|time|work)
```
