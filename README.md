# Target-list

An awk script that lists all documented targets in a Makefile. This is intended to be used by a Makefile to generate a help message.

## Example

See the `test/Makefile` and `test/support/target-list.awk`
for an example of how to use this script.

```
$ cd test
$ make help
Manage the building and testing this project

Usage:
   make <target>  Examples make compile hw.c
                           make c hw.c

Targets:
help h H   Show this help message
lib.<cmd>  `make lib.<cmd> PKG=<pkg>` -> `arduino-cli lib <cmd> "$(PKG)"`. For lib help `make lib.help`. Example: `make lib.install PKG="ArduinoJson"`
compile c  Build the project from source
clean      Remove build artifacts
```

## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.
