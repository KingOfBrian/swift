// RUN: %target-swift-frontend -Xllvm -new-mangling-for-tests -emit-sil -O -primary-file %s %S/vtable_extension_a.swift %S/vtable_extension_b.swift -module-name main | %FileCheck %s

extension Derived {
  func inDE() { print("Derived.inDE()") }

  override func inBE() { print("Derived.inBE()") }
  override func inBD() { print("Derived.inBD()") }
}
// CHECK-NOT: sil_vtable Derived {
// CHECK-NOT: sil_vtable Base {


func invokeBaseExtension(b: Base) {
	b.inBE()
}
// CHECK: [[REF:%.*]] = class_method %0 : $Base, #Base.inBE!1 : (Base) -> () -> (), $@convention(method) (@guaranteed Base) -> ()
// CHECK: apply [[REF]](%0) : $@convention(method) (@guaranteed Base) -> ()

func invokeBaseDeclaration(b: Base) {
  b.inBD()
}
// CHECK: [[REF:%.*]] = class_method %0 : $Base, #Base.inBD!1 : (Base) -> () -> (), $@convention(method) (@guaranteed Base) -> ()
// CHECK: apply [[REF]](%0) : $@convention(method) (@guaranteed Base) -> ()

func invokeFinalBaseExtension(b: Base) {
  b.finBE()
}
// CHECK: [[REF:%.*]] = function_ref @_T04main4BaseC5finBEyyF : $@convention(method) (@guaranteed Base) -> ()
// CHECK: apply [[REF]](%0) : $@convention(method) (@guaranteed Base) -> ()

