// RUN: rm -rf %t
// RUN: mkdir -p %t
// RUN: %target-swift-frontend -disable-objc-attr-requires-foundation-module -emit-module-path %t/Mod.swiftmodule -module-name Mod %S/Inputs/override_other_module.swift
// RUN: %target-typecheck-verify-swift -parse-as-library -swift-version 4 -I %t
// REQUIRES: objc_interop

import Mod

class B : A { }

extension B { 
  func f1() { }  // expected-error{{declarations in extensions cannot override yet}}
  func f2() -> B { } // expected-error{{declarations in extensions cannot override yet}}

  override func f3() { } // expected-error{{cannot override a non-dynamic class declaration from an extension}}
  override func f4() -> ObjCClassB { } // expected-error{{cannot override a non-dynamic class declaration from an extension}}
  override var v1: Int { return 1 } // expected-error{{cannot override a non-dynamic class declaration from an extension}}
  override var v2: Int { // expected-error{{cannot override a non-dynamic class declaration from an extension}}
    get { return 1 }
    set { }
  }
  override var v3: Int { // expected-error{{cannot override a non-dynamic class declaration from an extension}}
    willSet { }
    didSet { }
  }

  override func f3D() { }
  override func f4D() -> ObjCClassB { }

  func f5() { }  // expected-error{{declarations in extensions cannot override yet}}
  func f6() -> A { }  // expected-error{{declarations in extensions cannot override yet}}

  @objc override func f7() { }
  @objc override func f8() -> ObjCClassA { }
}

func callOverridden(_ b: B) {
  b.f3()
  _ = b.f4()
  b.f7()
  _ = b.f8()
}

@objc
class Base {
  func meth(_ x: Undeclared) {} // expected-error {{use of undeclared type 'Undeclared'}}
}
@objc
class Sub : Base {
  func meth(_ x: Undeclared) {} // expected-error {{use of undeclared type 'Undeclared'}}
}

// Objective-C method overriding

@objc class ObjCSuper {
  func method(_ x: Int, withInt y: Int) { }

  func method2(_ x: Sub, withInt y: Int) { }

  func method3(_ x: Base, withInt y: Int) { } // expected-note{{method 'method3(_:withInt:)' declared here}}
}

class ObjCSub : ObjCSuper {
  override func method(_ x: Int, withInt y: Int) { } // okay, overrides exactly

  override func method2(_ x: Base, withInt y: Int) { } // okay, overrides trivially

  func method3(_ x: Sub, withInt y: Int) { } // expected-error{{method3(_:withInt:)' with Objective-C selector 'method3:withInt:' conflicts with method 'method3(_:withInt:)' from superclass 'ObjCSuper' with the same Objective-C selector}}
}
