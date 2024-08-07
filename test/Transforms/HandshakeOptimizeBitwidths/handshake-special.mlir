// NOTE: Assertions have been autogenerated by utils/generate-test-checks.py
// RUN: dynamatic-opt --handshake-optimize-bitwidths --remove-operation-names %s --split-input-file | FileCheck %s

// CHECK-LABEL:   handshake.func @cmergeToMuxIndexOpt(
// CHECK-SAME:                                        %[[VAL_0:.*]]: !handshake.channel<i32>, %[[VAL_1:.*]]: !handshake.channel<i32>,
// CHECK-SAME:                                        %[[VAL_2:.*]]: !handshake.control<>, ...) -> (!handshake.channel<i32>, !handshake.channel<i32>) attributes {argNames = ["arg0", "arg1", "start"], resNames = ["out0", "out1"]} {
// CHECK:           %[[VAL_3:.*]], %[[VAL_4:.*]] = control_merge %[[VAL_0]], %[[VAL_1]]  : <i32>, <i1>
// CHECK:           %[[VAL_5:.*]] = mux %[[VAL_4]] {{\[}}%[[VAL_0]], %[[VAL_1]]] : <i1>, <i32>
// CHECK:           %[[VAL_6:.*]]:2 = return %[[VAL_3]], %[[VAL_5]] : <i32>, <i32>
// CHECK:           end %[[VAL_6]]#0, %[[VAL_6]]#1 : <i32>, <i32>
// CHECK:         }
handshake.func @cmergeToMuxIndexOpt(%arg0: !handshake.channel<i32>, %arg1: !handshake.channel<i32>, %start: !handshake.control<>) -> (!handshake.channel<i32>, !handshake.channel<i32>) {
  %result, %index = control_merge %arg0, %arg1 : <i32>, <i32>
  %mux = mux %index [%arg0, %arg1] : <i32>, <i32>
  %returnVals:2 = return %result, %mux : <i32>, <i32>
  end %returnVals#0, %returnVals#1 : <i32>, <i32>
}

// -----

// CHECK-LABEL:   handshake.func @cmergeToMuxIndexOpt(
// CHECK-SAME:                                        %[[VAL_0:.*]]: !handshake.channel<i32>, %[[VAL_1:.*]]: !handshake.channel<i32>,
// CHECK-SAME:                                        %[[VAL_2:.*]]: !handshake.control<>, ...) -> !handshake.channel<i32> attributes {argNames = ["arg0", "arg1", "start"], resNames = ["out0"]} {
// CHECK:           %[[VAL_3:.*]], %[[VAL_4:.*]] = control_merge %[[VAL_0]]  : <i32>, <i1>
// CHECK:           %[[VAL_5:.*]], %[[VAL_6:.*]] = control_merge %[[VAL_1]]  : <i32>, <i1>
// CHECK:           %[[VAL_7:.*]] = extui %[[VAL_6]] : <i1> to <i32>
// CHECK:           %[[VAL_8:.*]] = addi %[[VAL_5]], %[[VAL_7]] : <i32>
// CHECK:           %[[VAL_9:.*]] = addi %[[VAL_8]], %[[VAL_3]] : <i32>
// CHECK:           %[[VAL_10:.*]] = return %[[VAL_9]] : <i32>
// CHECK:           end %[[VAL_10]] : <i32>
// CHECK:         }
handshake.func @cmergeToMuxIndexOpt(%arg0: !handshake.channel<i32>, %arg1: !handshake.channel<i32>, %start: !handshake.control<>) -> !handshake.channel<i32> {
  %result, %index = control_merge %arg0 : <i32>, <i32>
  %mux = mux %index [%arg1] : <i32>, <i32>
  %otherResult, %otherIndex = control_merge %arg1 : <i32>, <i32>
  %add1 = addi %otherResult, %otherIndex : <i32>
  %add2 = addi %add1, %result : <i32>
  %ret = return %add2 : <i32>
  end %ret : <i32>
}


// -----

// CHECK-LABEL:   handshake.func @memAddrOpt(
// CHECK-SAME:                               %[[VAL_0:.*]]: memref<1000xi32>,
// CHECK-SAME:                               %[[VAL_1:.*]]: !handshake.control<>, ...) -> !handshake.channel<i32> attributes {argNames = ["mem", "start"], resNames = ["out0"]} {
// CHECK:           %[[VAL_2:.*]], %[[VAL_3:.*]] = mem_controller{{\[}}%[[VAL_0]] : memref<1000xi32>] (%[[VAL_4:.*]], %[[VAL_5:.*]], %[[VAL_6:.*]], %[[VAL_7:.*]], %[[VAL_8:.*]], %[[VAL_9:.*]]) {connectedBlocks = [0 : i32]} : (!handshake.channel<i32>, !handshake.channel<i10>, !handshake.channel<i10>, !handshake.channel<i32>, !handshake.channel<i10>, !handshake.channel<i32>) -> (!handshake.channel<i32>, !handshake.control<>)
// CHECK:           %[[VAL_10:.*]] = constant %[[VAL_1]] {value = 0 : i8} : <i8>
// CHECK:           %[[VAL_11:.*]] = extui %[[VAL_10]] : <i8> to <i10>
// CHECK:           %[[VAL_12:.*]] = constant %[[VAL_1]] {value = 500 : i16} : <i16>
// CHECK:           %[[VAL_13:.*]] = trunci %[[VAL_12]] : <i16> to <i10>
// CHECK:           %[[VAL_14:.*]] = constant %[[VAL_1]] {value = 999 : i32} : <i32>
// CHECK:           %[[VAL_15:.*]] = trunci %[[VAL_14]] : <i32> to <i10>
// CHECK:           %[[VAL_16:.*]] = constant %[[VAL_1]] {value = 42 : i32} : <i32>
// CHECK:           %[[VAL_4]] = constant %[[VAL_1]] {handshake.bb = 0 : ui32, value = 2 : i32} : <i32>
// CHECK:           %[[VAL_5]], %[[VAL_17:.*]] = mc_load{{\[}}%[[VAL_11]]] %[[VAL_2]] {handshake.bb = 0 : ui32} : <i10>, <i32>
// CHECK:           %[[VAL_6]], %[[VAL_7]] = mc_store{{\[}}%[[VAL_13]]] %[[VAL_16]] {handshake.bb = 0 : ui32} : <i32>, <i10>
// CHECK:           %[[VAL_8]], %[[VAL_9]] = mc_store{{\[}}%[[VAL_15]]] %[[VAL_16]] {handshake.bb = 0 : ui32} : <i32>, <i10>
// CHECK:           %[[VAL_18:.*]] = return %[[VAL_17]] : <i32>
// CHECK:           end %[[VAL_18]], %[[VAL_3]] : <i32>, <>
// CHECK:         }
handshake.func @memAddrOpt(%mem: memref<1000xi32>, %start: !handshake.control<>) -> !handshake.channel<i32> {
  %ldData1, %done = mem_controller[%mem : memref<1000xi32>] (%ctrl1, %ldAddr1, %stAddr1, %stData1, %stAddr2, %stData2) {connectedBlocks = [0 : i32]} : (!handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>, !handshake.channel<i32>) -> (!handshake.channel<i32>, !handshake.control<>)
  %addr1 = constant %start {value = 0 : i8} : <i8>
  %addr2 = constant %start {value = 500 : i16}: <i16>
  %addr3 = constant %start {value = 999 : i32}: <i32>
  %dataStore = constant %start {value = 42 : i32}: <i32>
  %ctrl1 = constant %start {value = 2 : i32, handshake.bb = 0 : ui32}: <i32>
  %addr1Ext = extui %addr1 : <i8> to <i32>
  %addr2Ext = extui %addr2 : <i16> to <i32>
  %ldAddr1, %ldVal = mc_load[%addr1Ext] %ldData1 {handshake.bb = 0 : ui32} : <i32>, <i32>
  %stAddr1, %stData1 = mc_store[%addr2Ext] %dataStore {handshake.bb = 0 : ui32} : <i32>, <i32>
  %stAddr2, %stData2 = mc_store[%addr3] %dataStore {handshake.bb = 0 : ui32} : <i32>, <i32>
  %returnVal = return %ldVal : <i32>
  end %returnVal, %done : <i32>, <>
}

// -----

// CHECK-LABEL:   handshake.func @simpleCycle(
// CHECK-SAME:                                %[[VAL_0:.*]]: !handshake.channel<i8>, %[[VAL_1:.*]]: !handshake.channel<i1>, %[[VAL_2:.*]]: !handshake.channel<i1>,
// CHECK-SAME:                                %[[VAL_3:.*]]: !handshake.control<>, ...) -> !handshake.channel<i32> attributes {argNames = ["arg0", "index", "cond", "start"], resNames = ["out0"]} {
// CHECK:           %[[VAL_4:.*]] = mux %[[VAL_1]] {{\[}}%[[VAL_0]], %[[VAL_5:.*]]] : <i1>, <i8>
// CHECK:           %[[VAL_5]], %[[VAL_6:.*]] = cond_br %[[VAL_2]], %[[VAL_4]] : <i1>, <i8>
// CHECK:           %[[VAL_7:.*]] = extsi %[[VAL_6]] : <i8> to <i32>
// CHECK:           %[[VAL_8:.*]] = return %[[VAL_7]] : <i32>
// CHECK:           end %[[VAL_8]] : <i32>
// CHECK:         }
handshake.func @simpleCycle(%arg0: !handshake.channel<i8>, %index: !handshake.channel<i1>, %cond: !handshake.channel<i1>, %start: !handshake.control<>) -> !handshake.channel<i32> {
  %ext = extsi %arg0 : <i8> to <i32>
  %muxOut = mux %index [%ext, %true] : <i1>, <i32>
  %true, %false = cond_br %cond, %muxOut : <i1>, <i32>
  %returnVal = return %false : <i32>
  end %returnVal : <i32>
}

// -----

// CHECK-LABEL:   handshake.func @complexCycle(
// CHECK-SAME:                                 %[[VAL_0:.*]]: !handshake.channel<i8>, %[[VAL_1:.*]]: !handshake.channel<i16>, %[[VAL_2:.*]]: !handshake.channel<i24>, %[[VAL_3:.*]]: !handshake.channel<i2>, %[[VAL_4:.*]]: !handshake.channel<i1>, %[[VAL_5:.*]]: !handshake.channel<i1>,
// CHECK-SAME:                                 %[[VAL_6:.*]]: !handshake.control<>, ...) -> !handshake.channel<i32> attributes {argNames = ["arg0", "arg1", "arg2", "bigIndex", "index", "cond", "start"], resNames = ["out0"]} {
// CHECK:           %[[VAL_7:.*]] = extsi %[[VAL_0]] {handshake.bb = 0 : ui32} : <i8> to <i24>
// CHECK:           %[[VAL_8:.*]] = extsi %[[VAL_1]] {handshake.bb = 0 : ui32} : <i16> to <i24>
// CHECK:           %[[VAL_9:.*]] = mux %[[VAL_3]] {{\[}}%[[VAL_7]], %[[VAL_10:.*]], %[[VAL_11:.*]], %[[VAL_12:.*]]] : <i2>, <i24>
// CHECK:           %[[VAL_10]], %[[VAL_13:.*]] = cond_br %[[VAL_5]], %[[VAL_9]] : <i1>, <i24>
// CHECK:           %[[VAL_14:.*]] = mux %[[VAL_4]] {{\[}}%[[VAL_8]], %[[VAL_13]]] : <i1>, <i24>
// CHECK:           %[[VAL_11]], %[[VAL_15:.*]] = cond_br %[[VAL_5]], %[[VAL_14]] : <i1>, <i24>
// CHECK:           %[[VAL_16:.*]] = mux %[[VAL_4]] {{\[}}%[[VAL_2]], %[[VAL_15]]] : <i1>, <i24>
// CHECK:           %[[VAL_12]], %[[VAL_17:.*]] = cond_br %[[VAL_5]], %[[VAL_16]] : <i1>, <i24>
// CHECK:           %[[VAL_18:.*]] = extsi %[[VAL_17]] : <i24> to <i32>
// CHECK:           %[[VAL_19:.*]] = return %[[VAL_18]] : <i32>
// CHECK:           end %[[VAL_19]] : <i32>
// CHECK:         }
handshake.func @complexCycle(%arg0: !handshake.channel<i8>, %arg1: !handshake.channel<i16>, %arg2: !handshake.channel<i24>, %bigIndex: !handshake.channel<i2>, %index: !handshake.channel<i1>, %cond: !handshake.channel<i1>, %start: !handshake.control<>) -> !handshake.channel<i32> {
  %ext0 = extsi %arg0 : <i8> to <i32>
  %ext1 = extsi %arg1 : <i16> to <i32>
  %ext2 = extsi %arg2 : <i24> to <i32>
  %mux0 = mux %bigIndex [%ext0, %condTrue0, %condTrue1, %condTrue2] : <i2>, <i32>
  %condTrue0, %condFalse0 = cond_br %cond, %mux0 : <i1>, <i32>
  %mux1 = mux %index [%ext1, %condFalse0] : <i1>, <i32>
  %condTrue1, %condFalse1 = cond_br %cond, %mux1 : <i1>, <i32>
  %mux2 = mux %index [%ext2, %condFalse1] : <i1>, <i32>
  %condTrue2, %condFalse2 = cond_br %cond, %mux2 : <i1>, <i32>
  %returnVal = return %condFalse2 : <i32>
  end %returnVal : <i32>
}
