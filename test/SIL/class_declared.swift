// RUN: %target-swift-frontend -Xllvm -emit-sil -O -primary-file %s %S/class_extension.swift -module-name main | %FileCheck %s


class Base {
  func inBD() {}
}

// CHECK: sil_vtable Base {
// Add vtable checks
// CHECK: }


extension Derived {
  func inDE() {}

  override func inBE() {}
  override func inBD() {}
}

// CHECK-NOT: sil_vtable Derived {
