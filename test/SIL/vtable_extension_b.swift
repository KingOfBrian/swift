// RUN: %target-swift-frontend -Xllvm -new-mangling-for-tests -emit-sil -O -primary-file %s %S/vtable_extension_a.swift %S/vtable_extension_c.swift -module-name main | %FileCheck %s

extension Base {
  static func inBES() {  }
  class func inBEC() {  }
  func inBE() {  }
  final func inBEF() {  }
}

class Derived: Base {
  func inDD() {  }
}

// CHECK:sil_vtable Derived {
// CHECK-NEXT:  #Base.inBD!1: (Base) -> () -> () : _T04main7DerivedC4inBDyyF  // Derived.inBD() -> ()
// CHECK-NEXT:  #Base.init!initializer.1: (Base.Type) -> () -> Base : _T04main7DerivedCACycfc // Derived.init() -> Derived
// CHECK-NEXT:  #Base.inBEC!1: (Base.Type) -> () -> () : _T04main7DerivedC5inBECyyFZ  // static Derived.inBEC() -> ()
// CHECK-NEXT:  #Base.inBE!1: (Base) -> () -> () : _T04main7DerivedC4inBEyyF  // Derived.inBE() -> ()
// CHECK-NEXT:  #Derived.inDE!1: (Derived) -> () -> () : _T04main7DerivedC4inDEyyF    // Derived.inDE() -> ()
// CHECK-NEXT:  #Derived.inDD!1: (Derived) -> () -> () : _T04main7DerivedC4inDDyyF    // Derived.inDD() -> ()
// CHECK-NEXT:  #Derived.deinit!deallocator: _T04main7DerivedCfD      // Derived.__deallocating_deinit
// CHECK-NEXT:}


// CHECK-NOT: sil_vtable Base
