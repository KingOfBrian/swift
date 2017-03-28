// RUN: %target-swift-frontend -Xllvm -new-mangling-for-tests -emit-sil -O -primary-file %s %S/vtable_extension_a.swift %S/vtable_extension_c.swift -module-name main | %FileCheck %s

extension Base {
  func inBE() { print("Base.inBE()") }
  final func finBE() { print("Base.finBE()") }
}

class Derived: Base {
  func inDD() { print("Derived.inDD()") }
}

// CHECK: sil_vtable Derived {
// CHECK:   #Base.inBD!1: (Base) -> () -> () : _T04main7DerivedC4inBDyyF	// Derived.inBD() -> ()
// CHECK:   #Base.init!initializer.1: (Base.Type) -> () -> Base : _T04main7DerivedCACycfc	// Derived.init() -> Derived
// CHECK:   #Base.inBE!1: (Base) -> () -> () : _T04main7DerivedC4inBEyyF	// Derived.inBE() -> ()
// CHECK:   #Derived.inDE!1: (Derived) -> () -> () : _T04main7DerivedC4inDEyyF	// Derived.inDE() -> ()
// CHECK:   #Derived.inDD!1: (Derived) -> () -> () : _T04main7DerivedC4inDDyyF	// Derived.inDD() -> ()
// CHECK:   #Derived.deinit!deallocator: _T04main7DerivedCfD	// Derived.__deallocating_deinit
// CHECK: }

// CHECK-NOT: sil_vtable Base
