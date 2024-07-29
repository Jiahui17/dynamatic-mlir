// NOTE: Assertions have been autogenerated by utils/generate-test-checks.py
// RUN: dynamatic-opt --lower-cf-to-handshake --remove-operation-names %s --split-input-file | FileCheck %s

// CHECK-LABEL:   handshake.func @simpleLoadStore(
// CHECK-SAME:                                    %[[VAL_0:.*]]: !handshake.channel<i32>, %[[VAL_1:.*]]: memref<4xi32>,
// CHECK-SAME:                                    %[[VAL_2:.*]]: !handshake.control<>, ...) -> !handshake.control<> attributes {argNames = ["in0", "in1", "in2"], resNames = ["end"]} {
// CHECK:           %[[VAL_3:.*]], %[[VAL_4:.*]] = mem_controller{{\[}}%[[VAL_1]] : memref<4xi32>] (%[[VAL_5:.*]], %[[VAL_6:.*]], %[[VAL_7:.*]], %[[VAL_8:.*]]) {connectedBlocks = [0 : i32]} : (!handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>) -> (!handshake.channel<i32>, !handshake.control<>)
// CHECK:           %[[VAL_5]] = constant %[[VAL_2]] {handshake.bb = 0 : ui32, value = 1 : i32} : <i32>
// CHECK:           %[[VAL_9:.*]] = constant %[[VAL_2]] {handshake.bb = 0 : ui32, value = 1 : i32} : <i32>
// CHECK:           %[[VAL_6]], %[[VAL_7]] = mc_store{{\[}}%[[VAL_0]]] %[[VAL_9]] {handshake.bb = 0 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_8]], %[[VAL_10:.*]] = mc_load{{\[}}%[[VAL_0]]] %[[VAL_3]] {handshake.bb = 0 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_11:.*]] = return {handshake.bb = 0 : ui32} %[[VAL_2]] : <>
// CHECK:           end {handshake.bb = 0 : ui32} %[[VAL_11]], %[[VAL_4]] : <>, <>
// CHECK:         }
func.func @simpleLoadStore(%arg0 : index, %arg1 : memref<4xi32>) {
  %c1 = arith.constant 1 : i32
  memref.store %c1, %arg1[%arg0] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  %0 = memref.load %arg1[%arg0] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  return
}

// -----

// CHECK-LABEL:   handshake.func @storeMulBlocks(
// CHECK-SAME:                                   %[[VAL_0:.*]]: !handshake.channel<i1>, %[[VAL_1:.*]]: !handshake.channel<i32>, %[[VAL_2:.*]]: memref<4xi32>,
// CHECK-SAME:                                   %[[VAL_3:.*]]: !handshake.control<>, ...) -> !handshake.control<> attributes {argNames = ["in0", "in1", "in2", "in3"], resNames = ["end"]} {
// CHECK:           %[[VAL_4:.*]] = mem_controller{{\[}}%[[VAL_2]] : memref<4xi32>] (%[[VAL_5:.*]], %[[VAL_6:.*]], %[[VAL_7:.*]], %[[VAL_8:.*]], %[[VAL_9:.*]], %[[VAL_10:.*]]) {connectedBlocks = [1 : i32, 2 : i32]} : (!handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>) -> !handshake.control<>
// CHECK:           %[[VAL_11:.*]], %[[VAL_12:.*]] = cond_br %[[VAL_0]], %[[VAL_1]] {handshake.bb = 0 : ui32} : <i1>, <i32>
// CHECK:           %[[VAL_13:.*]], %[[VAL_14:.*]] = cond_br %[[VAL_0]], %[[VAL_3]] {handshake.bb = 0 : ui32} : <i1>, <>
// CHECK:           %[[VAL_5]] = constant %[[VAL_15:.*]] {handshake.bb = 1 : ui32, value = 1 : i32} : <i32>
// CHECK:           %[[VAL_16:.*]] = merge %[[VAL_11]] {handshake.bb = 1 : ui32} : <i32>
// CHECK:           %[[VAL_15]], %[[VAL_17:.*]] = control_merge %[[VAL_13]]  {handshake.bb = 1 : ui32} : <>, <i1>
// CHECK:           %[[VAL_18:.*]] = constant %[[VAL_15]] {handshake.bb = 1 : ui32, value = 1 : i32} : <i32>
// CHECK:           %[[VAL_6]], %[[VAL_7]] = mc_store{{\[}}%[[VAL_16]]] %[[VAL_18]] {handshake.bb = 1 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_19:.*]] = br %[[VAL_15]] {handshake.bb = 1 : ui32} : <>
// CHECK:           %[[VAL_8]] = constant %[[VAL_20:.*]] {handshake.bb = 2 : ui32, value = 1 : i32} : <i32>
// CHECK:           %[[VAL_21:.*]] = merge %[[VAL_12]] {handshake.bb = 2 : ui32} : <i32>
// CHECK:           %[[VAL_20]], %[[VAL_22:.*]] = control_merge %[[VAL_14]]  {handshake.bb = 2 : ui32} : <>, <i1>
// CHECK:           %[[VAL_23:.*]] = constant %[[VAL_20]] {handshake.bb = 2 : ui32, value = 2 : i32} : <i32>
// CHECK:           %[[VAL_9]], %[[VAL_10]] = mc_store{{\[}}%[[VAL_21]]] %[[VAL_23]] {handshake.bb = 2 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_24:.*]] = br %[[VAL_20]] {handshake.bb = 2 : ui32} : <>
// CHECK:           %[[VAL_25:.*]], %[[VAL_26:.*]] = control_merge %[[VAL_19]], %[[VAL_24]]  {handshake.bb = 3 : ui32} : <>, <i1>
// CHECK:           %[[VAL_27:.*]] = return {handshake.bb = 3 : ui32} %[[VAL_25]] : <>
// CHECK:           end {handshake.bb = 3 : ui32} %[[VAL_27]], %[[VAL_4]] : <>, <>
// CHECK:         }
func.func @storeMulBlocks(%arg0 : i1, %arg1 : index, %arg2 : memref<4xi32>) {
  cf.cond_br %arg0, ^bb1, ^bb2
^bb1:
  %c1 = arith.constant 1 : i32
  memref.store %c1, %arg2[%arg1] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  cf.br ^bb3
^bb2:
  %c2 = arith.constant 2 : i32
  memref.store %c2, %arg2[%arg1] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  cf.br ^bb3
^bb3:
  return
}

// -----

// CHECK-LABEL:   handshake.func @forwardLoadToBB(
// CHECK-SAME:                                    %[[VAL_0:.*]]: !handshake.channel<i1>, %[[VAL_1:.*]]: !handshake.channel<i32>, %[[VAL_2:.*]]: memref<4xi32>,
// CHECK-SAME:                                    %[[VAL_3:.*]]: !handshake.control<>, ...) -> !handshake.control<> attributes {argNames = ["in0", "in1", "in2", "in3"], resNames = ["end"]} {
// CHECK:           %[[VAL_4:.*]], %[[VAL_5:.*]] = mem_controller{{\[}}%[[VAL_2]] : memref<4xi32>] (%[[VAL_6:.*]]) {connectedBlocks = [0 : i32]} : (!handshake.channel<i32>) -> (!handshake.channel<i32>, !handshake.control<>)
// CHECK:           %[[VAL_6]], %[[VAL_7:.*]] = mc_load{{\[}}%[[VAL_1]]] %[[VAL_4]] {handshake.bb = 0 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_8:.*]], %[[VAL_9:.*]] = cond_br %[[VAL_0]], %[[VAL_7]] {handshake.bb = 0 : ui32} : <i1>, <i32>
// CHECK:           %[[VAL_10:.*]], %[[VAL_11:.*]] = cond_br %[[VAL_0]], %[[VAL_3]] {handshake.bb = 0 : ui32} : <i1>, <>
// CHECK:           %[[VAL_12:.*]] = merge %[[VAL_8]] {handshake.bb = 1 : ui32} : <i32>
// CHECK:           %[[VAL_13:.*]], %[[VAL_14:.*]] = control_merge %[[VAL_10]]  {handshake.bb = 1 : ui32} : <>, <i1>
// CHECK:           %[[VAL_15:.*]] = source {handshake.bb = 1 : ui32}
// CHECK:           %[[VAL_16:.*]] = constant %[[VAL_15]] {handshake.bb = 1 : ui32, value = 1 : i32} : <i32>
// CHECK:           %[[VAL_17:.*]] = addi %[[VAL_12]], %[[VAL_16]] {handshake.bb = 1 : ui32} : <i32>
// CHECK:           %[[VAL_18:.*]] = br %[[VAL_13]] {handshake.bb = 1 : ui32} : <>
// CHECK:           %[[VAL_19:.*]], %[[VAL_20:.*]] = control_merge %[[VAL_11]], %[[VAL_18]]  {handshake.bb = 2 : ui32} : <>, <i1>
// CHECK:           %[[VAL_21:.*]] = return {handshake.bb = 2 : ui32} %[[VAL_19]] : <>
// CHECK:           end {handshake.bb = 2 : ui32} %[[VAL_21]], %[[VAL_5]] : <>, <>
// CHECK:         }
func.func @forwardLoadToBB(%arg0 : i1, %arg1 : index, %arg2: memref<4xi32>) {
  %0 = memref.load %arg2[%arg1] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  cf.cond_br %arg0, ^bb1, ^bb2
^bb1:
  %c1 = arith.constant 1 : i32
  %1 = arith.addi %0, %c1 : i32
  cf.br ^bb2
^bb2:
  return
}

// -----

// CHECK-LABEL:   handshake.func @multipleMemories(
// CHECK-SAME:                                     %[[VAL_0:.*]]: !handshake.channel<i1>, %[[VAL_1:.*]]: memref<4xi32>, %[[VAL_2:.*]]: memref<4xi32>,
// CHECK-SAME:                                     %[[VAL_3:.*]]: !handshake.control<>, ...) -> !handshake.control<> attributes {argNames = ["in0", "in1", "in2", "in3"], resNames = ["end"]} {
// CHECK:           %[[VAL_4:.*]], %[[VAL_5:.*]] = mem_controller{{\[}}%[[VAL_1]] : memref<4xi32>] (%[[VAL_6:.*]], %[[VAL_7:.*]], %[[VAL_8:.*]], %[[VAL_9:.*]]) {connectedBlocks = [1 : i32, 2 : i32]} : (!handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>) -> (!handshake.channel<i32>, !handshake.control<>)
// CHECK:           %[[VAL_10:.*]], %[[VAL_11:.*]] = mem_controller{{\[}}%[[VAL_2]] : memref<4xi32>] (%[[VAL_12:.*]], %[[VAL_13:.*]], %[[VAL_14:.*]], %[[VAL_15:.*]]) {connectedBlocks = [1 : i32, 2 : i32]} : (!handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>) -> (!handshake.channel<i32>, !handshake.control<>)
// CHECK:           %[[VAL_16:.*]] = constant %[[VAL_3]] {handshake.bb = 0 : ui32, value = 0 : i32} : <i32>
// CHECK:           %[[VAL_17:.*]] = constant %[[VAL_3]] {handshake.bb = 0 : ui32, value = 0 : i32} : <i32>
// CHECK:           %[[VAL_18:.*]], %[[VAL_19:.*]] = cond_br %[[VAL_0]], %[[VAL_16]] {handshake.bb = 0 : ui32} : <i1>, <i32>
// CHECK:           %[[VAL_20:.*]], %[[VAL_21:.*]] = cond_br %[[VAL_0]], %[[VAL_3]] {handshake.bb = 0 : ui32} : <i1>, <>
// CHECK:           %[[VAL_22:.*]], %[[VAL_23:.*]] = cond_br %[[VAL_0]], %[[VAL_17]] {handshake.bb = 0 : ui32} : <i1>, <i32>
// CHECK:           %[[VAL_6]] = constant %[[VAL_24:.*]] {handshake.bb = 1 : ui32, value = 1 : i32} : <i32>
// CHECK:           %[[VAL_25:.*]] = merge %[[VAL_18]] {handshake.bb = 1 : ui32} : <i32>
// CHECK:           %[[VAL_24]], %[[VAL_26:.*]] = control_merge %[[VAL_20]]  {handshake.bb = 1 : ui32} : <>, <i1>
// CHECK:           %[[VAL_12]], %[[VAL_27:.*]] = mc_load{{\[}}%[[VAL_25]]] %[[VAL_10]] {handshake.bb = 1 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_7]], %[[VAL_8]] = mc_store{{\[}}%[[VAL_25]]] %[[VAL_27]] {handshake.bb = 1 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_28:.*]] = return {handshake.bb = 1 : ui32} %[[VAL_24]] : <>
// CHECK:           %[[VAL_13]] = constant %[[VAL_29:.*]] {handshake.bb = 2 : ui32, value = 1 : i32} : <i32>
// CHECK:           %[[VAL_30:.*]] = merge %[[VAL_23]] {handshake.bb = 2 : ui32} : <i32>
// CHECK:           %[[VAL_29]], %[[VAL_31:.*]] = control_merge %[[VAL_21]]  {handshake.bb = 2 : ui32} : <>, <i1>
// CHECK:           %[[VAL_9]], %[[VAL_32:.*]] = mc_load{{\[}}%[[VAL_30]]] %[[VAL_4]] {handshake.bb = 2 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_14]], %[[VAL_15]] = mc_store{{\[}}%[[VAL_30]]] %[[VAL_32]] {handshake.bb = 2 : ui32} : <i32>, <i32>
// CHECK:           %[[VAL_33:.*]] = return {handshake.bb = 2 : ui32} %[[VAL_29]] : <>
// CHECK:           %[[VAL_34:.*]] = merge %[[VAL_28]], %[[VAL_33]] {handshake.bb = 1 : ui32} : <>
// CHECK:           end {handshake.bb = 1 : ui32} %[[VAL_34]], %[[VAL_5]], %[[VAL_11]] : <>, <>, <>
// CHECK:         }
func.func @multipleMemories(%arg0 : i1, %arg1: memref<4xi32>, %arg2: memref<4xi32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 0 : index
  cf.cond_br %arg0, ^bb1, ^bb2
^bb1:
  %1 = memref.load %arg2[%c0] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  memref.store %1, %arg1[%c0] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  return
^bb2:
  %2 = memref.load %arg1[%c1] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  memref.store %2, %arg2[%c1] {mem_interface = #handshake.mem_interface<MC>} : memref<4xi32>
  return
}
