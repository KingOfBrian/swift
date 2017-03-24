// RUN: rm -rf %t
// RUN: mkdir -p %t
// RUN: %target-swift-frontend -disable-objc-attr-requires-foundation-module -emit-module-path %t/Mod.swiftmodule -module-name Mod %S/Inputs/override_other_module.swift
// RUN: %target-typecheck-verify-swift -parse-as-library -swift-version 3 -I %t
// REQUIRES: objc_interop

import Mod

class B : A { }

extension B { 
  override func objcVirtualFunction() { } // expected-warning{{cannot override a non-dynamic class declaration from an extension}}
}
