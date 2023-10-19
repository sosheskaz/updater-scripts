# updater-scripts

Miscellaneous scripts to update binaries directly from the upstream, to an arbitrary location. If
not specified, it will download it to the first binary in the PATH. When there is no binary in the
PATH, it **must** be explicitly specified.

It can be specified with the environment variable, where `x` is the binary:

```
X_BIN=/path/to/x
```

These scripts output to stdout iff an update occurred.
