set V0;
set VC;
set V := V0 union VC;
set K;
set C;
set P;

param d {V, V} >= 0;
param cd >= 0;
param pen >= 0;
param ts >= 0;
param vel > 0;
param Delta >= 0;
param M > 0;
param cf {K} >= 0;
param HS {K} >= 0;
param cap {K, C} >= 0;
param dem {VC, P} >= 0;
param a {VC} >= 0;
param b {VC} >= 0;

var u {K} binary;
var x {V, V, K} binary;
var z {K, C, P} binary;
var q {K, C} >= 0;
var w {V, K, C} >= 0;
var y {VC, K, C, P} >= 0;
var shortage {VC, P} >= 0;
var t {VC, K} >= 0;
var t_ret {K} >= 0;
var ord {VC, K} >= 0 <= card(VC);

minimize TotalCost:
    sum {k in K} cf[k] * u[k]
  + sum {k in K, i in V, j in V} cd * d[i,j] * x[i,j,k]
  + sum {j in VC, p in P} pen * shortage[j,p];

s.t. NoLoop {i in V, k in K}:
    x[i,i,k] = 0;

s.t. DepartDepot {k in K}:
    sum {j in VC} x[0,j,k] = u[k];

s.t. ReturnDepot {k in K}:
    sum {i in VC} x[i,0,k] = u[k];

s.t. FlowBalance {j in VC, k in K}:
    sum {i in V: i <> j} x[i,j,k] = sum {l in V: l <> j} x[j,l,k];

s.t. VisitAtMostOnce {j in VC}:
    sum {k in K, i in V: i <> j} x[i,j,k] <= 1;

s.t. VisitOnlyIfUsed {j in VC, k in K}:
    sum {i in V: i <> j} x[i,j,k] <= u[k];

s.t. AssignOneProduct {k in K, c in C}:
    sum {p in P} z[k,c,p] = u[k];

s.t. LoadCapacity {k in K, c in C}:
    q[k,c] <= cap[k,c] * sum {p in P} z[k,c,p];

s.t. DemandBalance {j in VC, p in P}:
    sum {k in K, c in C} y[j,k,c,p] + shortage[j,p] = dem[j,p];

s.t. DeliverOnlyIfVisited {j in VC, k in K, c in C}:
    sum {p in P} y[j,k,c,p] <= cap[k,c] * sum {i in V: i <> j} x[i,j,k];

s.t. ProductCompatibility {j in VC, k in K, c in C, p in P}:
    y[j,k,c,p] <= cap[k,c] * z[k,c,p];

s.t. InitialInventory {k in K, c in C}:
    w[0,k,c] = q[k,c];

s.t. InventoryUpper {i in V, k in K, c in C}:
    w[i,k,c] <= cap[k,c];

s.t. InventoryBalanceUpper {i in V, j in VC, k in K, c in C: i <> j}:
    w[j,k,c] <= w[i,k,c] - sum {p in P} y[j,k,c,p] + M * (1 - x[i,j,k]);

s.t. InventoryBalanceLower {i in V, j in VC, k in K, c in C: i <> j}:
    w[j,k,c] >= w[i,k,c] - sum {p in P} y[j,k,c,p] - M * (1 - x[i,j,k]);

s.t. StabilityDepotUpper {k in K}:
    w[0,k,"C0"] / cap[k,"C0"] - w[0,k,"C1"] / cap[k,"C1"] <= Delta + M * (1 - u[k]);

s.t. StabilityDepotLower {k in K}:
    w[0,k,"C1"] / cap[k,"C1"] - w[0,k,"C0"] / cap[k,"C0"] <= Delta + M * (1 - u[k]);

s.t. StabilityStationUpper {i in VC, k in K}:
    w[i,k,"C0"] / cap[k,"C0"] - w[i,k,"C1"] / cap[k,"C1"]
    <= Delta + M * (1 - sum {l in V: l <> i} x[i,l,k]);

s.t. StabilityStationLower {i in VC, k in K}:
    w[i,k,"C1"] / cap[k,"C1"] - w[i,k,"C0"] / cap[k,"C0"]
    <= Delta + M * (1 - sum {l in V: l <> i} x[i,l,k]);

s.t. FirstArrival {j in VC, k in K}:
    t[j,k] >= HS[k] + d[0,j] / vel - M * (1 - x[0,j,k]);

s.t. TimeContinuity {i in VC, j in VC, k in K: i <> j}:
    t[j,k] >= t[i,k] + ts + d[i,j] / vel - M * (1 - x[i,j,k]);

s.t. ReturnTime {i in VC, k in K}:
    t_ret[k] >= t[i,k] + ts + d[i,0] / vel - M * (1 - x[i,0,k]);

s.t. WindowStart {j in VC, k in K}:
    t[j,k] >= a[j] - M * (1 - sum {i in V: i <> j} x[i,j,k]);

s.t. WindowEnd {j in VC, k in K}:
    t[j,k] <= b[j] + M * (1 - sum {i in V: i <> j} x[i,j,k]);

s.t. OrderUse {j in VC, k in K}:
    ord[j,k] <= card(VC) * sum {i in V: i <> j} x[i,j,k];

s.t. MTZ {i in VC, j in VC, k in K: i <> j}:
    ord[j,k] >= ord[i,k] + 1 - card(VC) * (1 - x[i,j,k]);
