// RUN: %target-swift-frontend -Xllvm -new-mangling-for-tests -emit-sil -O -primary-file %s %S/vtable_extension_b.swift %S/vtable_extension_c.swift -module-name main | %FileCheck %s

class Base {
  func inBD() { }
}

// CHECK: sil_vtable Base {
// CHECK-NEXT:   #Base.inBEC!1: (Base.Type) -> () -> () : _T04main4BaseC5inBECyyFZ     // static Base.inBEC() -> ()
// CHECK-NEXT:   #Base.inBE!1: (Base) -> () -> () : _T04main4BaseC4inBEyyF	// Base.inBE() -> ()
// CHECK-NEXT:   #Base.inBD!1: (Base) -> () -> () : _T04main4BaseC4inBDyyF	// Base.inBD() -> ()
// CHECK-NEXT:   #Base.deinit!deallocator: _T04main4BaseCfD	// Base.__deallocating_deinit
// CHECK-NEXT:   #Base.init!initializer.1: (Base.Type) -> () -> Base : _T04main4BaseCACycfc	// Base.init() -> Base
// CHECK-NEXT: }
