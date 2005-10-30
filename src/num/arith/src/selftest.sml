open simpLib Parse boolLib HolKernel

fun die s = (print s; Process.exit Process.failure)

fun pr s = print (StringCvt.padRight #" " 60 s)

val _ = pr "Testing SUC_FILTER_ss ...                     "
val ss = boolSimps.bool_ss ++ numSimps.REDUCE_ss ++ numSimps.SUC_FILTER_ss
val th = QCONV (SIMP_CONV ss [arithmeticTheory.FUNPOW])
               ``FUNPOW (f:'a->'a) 2 x``
val _ = if not (aconv (rhs (concl th)) ``(f:'a -> 'a) (f x)``) then
          die "FAILED!\n"
        else print "OK\n"

val _ = pr "Testing coefficient gathering in ARITH_ss ... "
val arith_ss = boolSimps.bool_ss ++ numSimps.ARITH_ss
val _ = if not (aconv (rhs (concl (SIMP_CONV arith_ss [] ``x + x + x``)))
                      ``3 * x``)
        then die "FAILED!\n"
        else print "OK\n"

val _ = pr "Testing arith on ground ctxt ...              "
val _ = let
  val (res, vfn) = ASM_SIMP_TAC arith_ss [] ([``2 <= 0``], ``F``)
in
  if null res andalso concl (vfn []) = F then print "OK\n"
  else die "FAILED!\n"
end

val _ = pr "Testing Alexey Gottsman's arith d.p. problem ... "
val _ = let
  val t =
   ``(e*bv_c+e*(2*bv_cout+wb_sum)+wbs_sum =
        bv_cin+e*(bv_c+wb_a+wb_b)+wbs_a+wbs_b)
     ==>
     (2n*e*bv_cout+e*wb_sum+wbs_sum = bv_cin+e*wb_a+e*wb_b+wbs_a+wbs_b)``
  val result = SOME (numLib.ARITH_CONV t) handle HOL_ERR _ => NONE
in
  case result of
    SOME th => if rhs (concl th) = boolSyntax.T then print "OK\n"
               else die "FAILED!\n"
  | NONE => die "FAILED!\n"
end

val _ = Process.exit Process.success
