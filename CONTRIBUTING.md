# Contributing to the Teamleader API Definition

#### IMPORTANT: Do not edit `/apiary.apib` manually.

Apiary expects a single `apiary.apib` API definition file. For maintainability purposes, this file is built from individual files located in the `src` directory.

## Dependencies

All tools and scripts are executed using [Docker](https://www.docker.com).

### Building

Because we split up the blueprint files, we need to combine them back into one `apiary.apib` file so that Apiary can render our documentation. This can be doing using the following script:

```bash
make
```

There's also an included gulp file to automatically build the main file whenever you make modifications:

```bash
make watch
```

### Linting

You can lint the `apiary.apib` file to make sure it's valid:

```bash
make lint
```

### Preview

If you want to preview the output of the API Blueprint, you can run:

```bash
make preview
```

## Guidelines

We have documented our [API Design Guidelines](GUIDELINES.md). Please follow these recommendations when making a pull request.

## Changelog

In every pull request, the essence of the change or addition, should be documented respectively in the [changes](./src/changes-backwards-incompatible.apib) or the [additions](./src/changes-backwards-compatible.apib).

For additions, we list them per month, so if you start a new month, group the old records under a month header.

Changes are grouped under the version number, so make sure the current latest version is updated in the **[Upgrading your API version](https://github.com/teamleadercrm/api/blob/master/src/changes.apib)** section.
