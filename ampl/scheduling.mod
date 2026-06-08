set O;
set B;

param bay {O} symbolic in B;
param duration {O} >= 0;
param M > 0;

set PRECEDENCE within {O, O};
set SAME_BAY_PAIRS within {O, O};

var start {O} >= 0;
var cmax >= 0;
var alpha {SAME_BAY_PAIRS} binary;

minimize Makespan:
    cmax;

s.t. Completion {o in O}:
    cmax >= start[o] + duration[o];

s.t. TruckPrecedence {(o1, o2) in PRECEDENCE}:
    start[o2] >= start[o1] + duration[o1];

s.t. NoOverlapForward {(o1, o2) in SAME_BAY_PAIRS}:
    start[o2] >= start[o1] + duration[o1] - M * (1 - alpha[o1,o2]);

s.t. NoOverlapBackward {(o1, o2) in SAME_BAY_PAIRS}:
    start[o1] >= start[o2] + duration[o2] - M * alpha[o1,o2];
