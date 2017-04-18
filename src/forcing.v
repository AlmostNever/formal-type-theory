(* Forcing Translation

   Based on The Definitional Side of the Forcing
   by Jaber et al.
*)

Require config.
Require Import config_tactics.

Require Import syntax.
Require Import tt.
Require Import checking_tactics.

(* Source type theory *)
Module Stt.

  Section Stt.

  Local Instance hasPrecond : config.Precond
    := {| config.precondFlag := config.Yes |}.
  Local Instance hasReflection : config.Reflection
    := {| config.reflectionFlag := config.No |}.
  Local Instance hasSimpleProducts : config.SimpleProducts
    := {| config.simpleproductsFlag := config.No |}.
  Local Instance hasProdEta : config.ProdEta
    := {| config.prodetaFlag := config.No |}.
  Local Instance hasUniverses : config.Universes
    := {| config.universesFlag := config.Yes |}.
  Local Instance hasProp : config.WithProp
    := {| config.withpropFlag := config.Yes |}.

  Definition isctx   := isctx.
  Definition issubst := issubst.
  Definition istype  := istype.
  Definition isterm  := isterm.
  Definition eqctx   := eqctx.
  Definition eqsubst := eqsubst.
  Definition eqtype  := eqtype.
  Definition eqterm  := eqterm.

  End Stt.

End Stt.

(* Target type theory *)
Module Ttt.

  Section Ttt.

  Local Instance hasPrecond : config.Precond
    := {| config.precondFlag := config.No |}.
  Local Instance hasReflection : config.Reflection
    := {| config.reflectionFlag := config.No |}.
  Local Instance hasSimpleProducts : config.SimpleProducts
    := {| config.simpleproductsFlag := config.No |}.
  Local Instance hasProdEta : config.ProdEta
    := {| config.prodetaFlag := config.No |}.
  Local Instance hasUniverses : config.Universes
    := {| config.universesFlag := config.Yes |}.
  Local Instance hasProp : config.WithProp
    := {| config.withpropFlag := config.Yes |}.

  Definition isctx   := isctx.
  Definition issubst := issubst.
  Definition istype  := istype.
  Definition isterm  := isterm.
  Definition eqctx   := eqctx.
  Definition eqsubst := eqsubst.
  Definition eqtype  := eqtype.
  Definition eqterm  := eqterm.

  End Ttt.

End Ttt.

Section Translation.

(* We give ourselves a category in the source *)
(* Note: This should also hold in the target by equivalence ett/ptt. *)
Context `{ℙ : term}.
Context `{hℙ : Stt.isterm ctxempty ℙ (Uni (uni 0))}.
Context `{_Hom : term}.
Context `{hHom : Stt.isterm ctxempty _Hom (Arrow (El ℙ) (Arrow (El ℙ) (Uni (uni 0))))}.

Definition Hom p q :=
  El (app (app _Hom (El ℙ) (Arrow (El ℙ) (Uni (uni 0))) p) (El ℙ) (Uni (uni 0)) q).

Context `{_idℙ : term}.
Context `{hidℙ : Stt.isterm ctxempty _idℙ (Prod (El ℙ) (Hom (var 0) (var 0)))}.

Definition idℙ p :=
  app _idℙ (El ℙ) (Hom (var 0) (var 0)) p.

Context `{_comp : term}.
Context `{hcomp : Stt.isterm ctxempty _comp (Prod (El ℙ) (Prod (El ℙ) (Prod (El ℙ) (Arrow (Hom (var 2) (var 1)) (Arrow (Hom (var 1) (var 0)) (Hom (var 2) (var 0)))))))}.

Definition comp p q r f g :=
  app (app (app (app (app _comp (El ℙ) (Prod (El ℙ) (Arrow (Hom (var 2) (var 1)) (Arrow (Hom (var 1) (var 0)) (Hom (var 2) (var 0))))) p) (El ℙ) (Prod (El ℙ) (Arrow (Hom p (var 1)) (Arrow (Hom (var 1) (var 0)) (Hom p (var 0))))) q) (El ℙ) (Arrow (Hom p q) (Arrow (Hom q (var 0)) (Hom p (var 0)))) r) (Hom p q) (Arrow (Hom q r) (Hom p r)) f) (Hom q r) (Hom p r) g.

(* This is really illegible so we need to complete the alternative syntax. *)

(* We require extra definitional equalities *)
Context `{CompIdℙLeft : forall Γ f p q, Stt.isterm Γ f (Hom p q) -> Stt.eqterm Γ (comp p p q (idℙ p) f) f (Hom p q)}.
(* Context `{CompIdℙRight} *)

End Translation.