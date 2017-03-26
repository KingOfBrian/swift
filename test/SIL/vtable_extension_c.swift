// RUN: %target-swift-frontend -Xllvm -new-mangling-for-tests -emit-sil -O -primary-file %s %S/vtable_extension_a.swift %S/vtable_extension_b.swift -module-name main | %FileCheck %s

extension Derived {
  func inDE() {}

  override func inBE() {}
  override func inBD() {}
}
// CHECK-NOT: sil_vtable Derived {


func invokeBaseExtension(b: Base) {
	b.inBE()
	// CHECK: [[REF:%.*]] = class_method %0 : $Base, #Base.inBE!1 : (Base) -> () -> (), $@convention(method) (@guaranteed Base) -> ()
}

func invokeBaseDeclaration(b: Base) {
	b.inBD()
	// CHECK: [[REF:%.*]] = class_method %0 : $Base, #Base.inBD!1 : (Base) -> () -> (), $@convention(method) (@guaranteed Base) -> ()
}


