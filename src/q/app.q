\p 5000

\l rest.q

genData:{
 tbl: ([] time: .z.T; sym: `$5#.Q.A cross .Q.A ; price: {0.01*`int$100*x} 5? 50f);
 `tbl set tbl
 }

data:{[symbol] 
 $[` = `$symbol; :tbl; 
   :select from tbl where sym = `$symbol]
 };

time:{[] enlist[`time]!enlist .z.T}

.rest.define[`time;()!();();`]
.rest.define[`data;()!();();`]

.z.ts:{genData[]}

\t 500


