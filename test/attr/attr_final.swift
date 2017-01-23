// RUN: %target-typecheck-verify-swift -swift-version 4

class Super {
  final var i: Int { get { return 5 } } // expected-note{{overridden declaration is here}}
  final func foo() { } // expected-note{{overridden declaration is here}}
  final subscript (i: Int) -> Int { // expected-note{{overridden declaration is here}}
    get { 
      return i
    }
  }
}

class Sub : Super {
  override var i: Int { get { return 5 } } // expected-error{{var overrides a 'final' var}}
  override func foo() { }  // expected-error{{instance method overrides a 'final' instance method}}
  override subscript (i: Int) -> Int {  // expected-error{{subscript overrides a 'final' subscript}}
    get { 
      return i
    }
  }

  final override init() {} // expected-error {{'final' modifier cannot be applied to this declaration}} {{3-9=}}
}


struct SomeStruct {
  final func structFunc() {} // expected-error {{only classes and class members may be marked with 'final'}} {{3-9=}}
}

enum SomeEnum {
  final func enumFunc() {}  // expected-error {{only classes and class members may be marked with 'final'}} {{3-9=}}
}

protocol SomeProto {
  final func protoFunc()  // expected-error {{only classes and class members may be marked with 'final'}} {{3-9=}}
}

extension SomeStruct {
  final func structExtensionFunc() {}  // expected-error {{only classes and class members may be marked with 'final'}} {{3-9=}}
}

extension SomeEnum {
  final func enumExtensionFunc() {}  // expected-error {{only classes and class members may be marked with 'final'}} {{3-9=}}
}

extension SomeProto {
  final func protoExtensionFunc() {}  // expected-error {{only classes and class members may be marked with 'final'}} {{3-9=}}
}

extension Super {
  final func someClassMethod() {} // ok
  
}

final func global_function() {}  // expected-error {{only classes and class members may be marked with 'final'}} {{1-7=}}

final
class Super2 {
  var i: Int { get { return 5 } } // expected-note{{overridden declaration is here}}
  func foo() { } // expected-note{{overridden declaration is here}}
  subscript (i: Int) -> Int { // expected-note{{overridden declaration is here}}
    get {
      return i
    }
  }
}

class Sub2 : Super2 { //// expected-error{{inheritance from a final class 'Super2'}}
  override var i: Int { get { return 5 } } // expected-error{{var overrides a 'final' var}}
  override func foo() { }  // expected-error{{instance method overrides a 'final' instance method}}
  override subscript (i: Int) -> Int {  // expected-error{{subscript overrides a 'final' subscript}}
    get { 
      return i
    }
  }

  final override init() {} // expected-error {{'final' modifier cannot be applied to this declaration}} {{3-9=}}
}

