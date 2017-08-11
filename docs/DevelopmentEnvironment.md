# Getting Started

The purpose of this document is to help new developers get set up with a
functional development environment.

# Development Environment

The development environment is managed by the script `utils/build-script`. This
script will orchestrate various tools to build various parts of the swift
project. Once the build is setup and configured, it often helps to use the tools
directly to have more control over the build, test and debug process.

There are two possible build engines to use in CMake, xcodebuild or Ninja.
xcodebuild integrates nicely with Xcode.app, but Ninja is a bit faster and
supports more environments.

To build using Xcode, run:

    utils/build-script -x

The Xcode IDE can be used to edit the Swift source code, but it is not currently
fully supported as a build environment for SDKs other than macOS. If you need to
work with other SDKs, you'll need to create a second build using Ninja.

To build using Ninja, run:

    utils/build-script -R --debug-swift

This will build LLVM+Clang with optimizations and no debug symbols, but will
build swift with debug symbols. This is a good starting point since the debugger
will work in the swift code base, and the tests will run faster.

For more possibilities, look for "Typical uses" in `utils/build-script -h`.

## Build Products

All of the build products are placed in `swift-source/build/${TOOL}-${MODE}/${PRODUCT}-${PLATFORM}/`.
If macOS swift with Ninja in DebugAssert mode was built, all of the products
would be in `swift-source/build/Ninja-DebugAssert/swift-macosx-x86_64/`. It
helps to save this directory as an environment variable for future use.

    export SWIFT_BUILD_DIR="~/swift-source/build/Ninja-DebugAssert/swift-macosx-x86_64"

### Xcode

To open the swift in Xcode, open `${SWIFT_BUILD_DIR}/Swift.xcodeproj`. It will
auto-create a *lot* of schemes for all of the available targets. A common debug
flow would involve:

 - Select the ‘swift’ scheme
 - Pull up the scheme editor (⌘+⇧+<)
 - Select the ‘Arguments’ tab and click the ‘+’
 - Add the command line options
 - Close the scheme editor
 - Build and run

### Ninja

Once the first build has been finished with `build-script`, ninja can perform
fast incremental builds of various products.

    cd ${SWIFT_BUILD_DIR}
    ninja swift
    ninja swift-stdlib

These incremental builds are a big timesaver when developing and debugging. It
is still always a good idea to do a full build after using `update-checkout`.
Building the `swift-stdlib` target as an additional layer of testing from time
to time is also a good idea.

# Testing

Testing in Swift is primarily performed with two tools from LLVM, [lit](https://llvm.org/docs/CommandGuide/lit.html),
and [FileCheck](https://llvm.org/docs/CommandGuide/FileCheck.html). `lit` is a
simple test runner, and `FileCheck` implements tests by adding annotations to
specify the commands to run and annotations to specify the expected output.

To run unit tests, invoke `lit` directly:

    ${LLVM_SOURCE_ROOT}/utils/lit/lit.py -sv ${SWIFT_BUILD_ROOT}/test-macosx-x86_64/

You can use the `--filter $REGEX` argument to filter a subset of tests.

See [docs/Testing.md](docs/Testing.md) for a more information on testing.

# Debugging test failures

When a test fails, it will print out the command that caused the failure. Prefix
the command with `lldb --` to run inside the debugger, or select the correct
target in Xcode and paste the output into the scheme's run arguments.

For more debugging techniques, see [docs/DebuggingTheCompiler.rst](docs/DebuggingTheCompiler.rst)

# PR

When you have a change you are ready to submit, make a PR against the Swift
repository. Be sure to explain your changes, and have good set of unit tests to
accompany your changes. Be aware of any compatibility mode considerations. If
you are generating a new error, it must be turned off when running in
compatibility mode.

## Build Bot

There is a build bot that can be triggered by talking to `@swift-ci`, but the
build bot only listens to authorized users. Usually one of these people will
request a build when you make your PR.

# Troubleshooting

## Xcode Version

Make sure you are using the latest release of Xcode to build, including Betas.

## Changing Xcode Versions

If you have changed Xcode versions but still encounter errors that appear to
be related to the Xcode version, try passing `-- --rebuild` to `build-script`.
    
## Confusing test failure diagnostics

On complicated FileCheck RUN directives, sometimes compiler output is printed
instead of the commands that generated the failure. Look at the command
directives at the top of the file to get more context as to how the test is
being ran, and run each one manually to determine the source of the problem.