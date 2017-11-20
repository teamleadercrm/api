# Contributing to the Teamleader API Definition

#### IMPORTANT: Do not edit `/apiary.apib`

Apiary expects a single `apiary.apib` API definition file. For maintainability purposes, this file is built from individual files located in the `src` directory.

## Dependencies

All tools and scripts are executed using [Docker](https://www.docker.com).

### Building

Because we split up the blueprint files, we need to combine them back into one `apiary.apib` file so that Apiary can render our documentation. This can be doing using the following script:

```bash
./dev/build
```

There's also an included gulp file to automatically build the main file whenever you make modifications:

```bash
./dev/watch
```

### Linting

You can lint the `apiary.apib` file to make sure it's valid:

```bash
./dev/lint
```

### Preview

If you want to preview the output of the API Blueprint, you can run:

```bash
./dev/preview
```

## Guidelines

Have have documented our [API Design Guidelines](GUIDELINES.md). Please follow these recommendations when making a pull request.
