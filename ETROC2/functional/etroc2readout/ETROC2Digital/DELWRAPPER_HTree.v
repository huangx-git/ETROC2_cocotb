module DELWRAPPER_HTree(
  input I,
  output Z
);
  // tmrg do_not_touch

assign #(`HTREE_MIN_DELAY/6:`HTREE_TYP_DELAY/6:`HTREE_MAX_DELAY/6) Z = I;

endmodule
