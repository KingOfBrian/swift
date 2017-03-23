// RUN: %target-swift-frontend -Xllvm -emit-sil -O -wmo %s %S/class_declared.swift -module-name main | %FileCheck %s

extension Base {
  func inBE() {}
}

class Derived: Base {
  func inDD() {}
}

// CHECK: sil_vtable Derived {
// Add vtable checks
// CHECK: }

// CHECK-NOT: sil_vtable Base {
