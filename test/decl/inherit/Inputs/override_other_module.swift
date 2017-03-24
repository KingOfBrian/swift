
open class A { 
  open func f1() { } // expected-note{{overridden declaration is here}}
  open func f2() -> A { return self } // expected-note{{overridden declaration is here}}

  @objc open func f3() { } // expected-note{{overridden declaration is here}}
  @objc open func f4() -> ObjCClassA { return ObjCClassA() } // expected-note{{overridden declaration is here}}
  @objc open var v1: Int { return 0 } // expected-note{{overridden declaration is here}}
  @objc open var v2: Int { return 0 } // expected-note{{overridden declaration is here}}
  @objc open var v3: Int = 0 // expected-note{{overridden declaration is here}}

  open dynamic func f3D() { }
  open dynamic func f4D() -> ObjCClassA { return ObjCClassA() }
}

extension A {
  open func f5() { } // expected-note{{overridden declaration is here}}
  open func f6() -> A { return self } // expected-note{{overridden declaration is here}}

  @objc open func f7() { }
  @objc open func f8() -> ObjCClassA { return ObjCClassA() }
}

@objc open class ObjCClassA {}
@objc open class ObjCClassB : ObjCClassA {}
