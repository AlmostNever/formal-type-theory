Require config.
Require Import tt.

Section Ett.

Local Instance hasPrecond : config.Precond := {| config.precondFlag := config.No |}.
Context `{configReflection : config.Reflection}.
Context `{configSimpleProducts : config.SimpleProducts}.
Context `{ConfigProdEta : config.ProdEta}.
Context `{ConfigUniverses : config.Universes}.
Context `{ConfigWithProp : config.WithProp}.

Definition isctx := isctx.
Definition issubst := issubst.
Definition istype := istype.
Definition isterm := isterm.
Definition eqctx := eqctx.
Definition eqsubst := eqsubst.
Definition eqtype := eqtype.
Definition eqterm := eqterm.

End Ett.