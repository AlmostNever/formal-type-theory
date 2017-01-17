(* Inversion theorems for ptt. *)

Require Import syntax ptt.

Fixpoint TyIdInversion G A u v (H : istype G (Id A u v)) {struct H} :
  isctx G * istype G A * isterm G u A * isterm G v A.
Proof.
  inversion H.

  - { split ; [(split ; [split | idtac]) | idtac].

      - assumption.
      - apply (@TyCtxConv G0 G) ; auto.
        now apply TyIdInversion with (u := u) (v := v).
      - apply (@TermCtxConv G0 G) ; auto.
        + now apply TyIdInversion with (u := u) (v:= v).
        + now apply TyIdInversion with (u := u) (v:= v).
      - apply (@TermCtxConv G0 G) ; auto.
        + now apply TyIdInversion with (u := u) (v:= v).
        + now apply TyIdInversion with (u := u) (v:= v).
    }

  - { split ; [(split ; [split | idtac]) | idtac].
      - assumption.
      - assumption.
      - assumption.
      - assumption.
    }

Defined.

Fixpoint TyProdInversion G A B (H : istype G (Prod A B)) {struct H} :
  isctx G * istype G A * istype (ctxextend G A) B.
Proof.
  inversion H.

  - { split ; [ split | idtac ].
      - assumption.
      - apply (@TyCtxConv G0 G) ; auto.
        now apply (TyProdInversion G0 A B).
      - apply (@TyCtxConv (ctxextend G0 A) (ctxextend G A)).
        + apply CtxExtend ; auto.
          now apply (TyProdInversion G0 A B).
        + apply CtxExtend.
          * assumption.
          * apply (@TyCtxConv G0 G) ; auto.
            now apply (TyProdInversion G0 A B).
        + now apply (TyProdInversion G0 A B).
        + apply EqCtxExtend ; auto.
          * now apply (TyProdInversion G0 A B).
          * now apply (TyProdInversion G0 A B).
          * apply EqTyRefl ; auto.
            now apply (TyProdInversion G0 A B).
    }

  - { split ; [ split | idtac ].
      - assumption.
      - assumption.
      - assumption.
    }
Defined.