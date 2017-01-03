Require Import syntax.
Require ett ptt.

Axiom postpone_proof : forall A : Type, A.
Ltac later := apply postpone_proof.

Fixpoint sane_isctx G (P : ett.isctx G) {struct P} : ptt.isctx G

with sane_issubst sbs G D (P : ett.issubst sbs G D) {struct P} : ptt.issubst sbs G D

with sane_istype G A (P : ett.istype G A) {struct P} : ptt.istype G A

with sane_isterm G u A (P : ett.isterm G u A) {struct P} : ptt.isterm G u A

with sane_eqctx G D (P : ett.eqctx G D) {struct P} : ptt.eqctx G D

with sane_eqsubst sbs sbt G D (P : ett.eqsubst sbs sbt G D) {struct P} : ptt.eqsubst sbs sbt G D

with sane_eqtype G A B (P : ett.eqtype G A B) {struct P} : ptt.eqtype G A B

with sane_eqterm G u v A (P : ett.eqterm G u v A) {struct P} : ptt.eqterm G u v A.

Proof.

  (* sane_isctx *)
  { destruct P.

    (* CtxEmpty *)
    - { apply ptt.CtxEmpty. }

    (* CtxExtend *)
    - {
        intros ; apply ptt.CtxExtend.
        + now apply sane_isctx.
        + now apply sane_istype.
      }
  }

  (* sane_issubst *)
  { destruct P.

    (* SubstZero *)
    - { apply ptt.SubstZero.
        + eapply ptt.sane_isterm.
          eapply sane_isterm ; eassumption.
        + eapply ptt.sane_isterm.
          eapply sane_isterm ; eassumption.
        + now apply sane_isterm.
      }

    (* SubstWeak *)
    - {
        apply ptt.SubstWeak.
        + eapply ptt.sane_istype.
          eapply sane_istype ; eassumption.
        + now apply sane_istype.
      }

    (* SubstShift. *)
    - {
        apply ptt.SubstShift.
        + eapply (ptt.sane_issubst sbs G D).
          now apply sane_issubst.
        + eapply (ptt.sane_istype D A).
          now apply sane_istype.
        + now apply sane_issubst.
        + now apply sane_istype.
      }

     (* SubstId *)
     - {
         apply ptt.SubstId.
         - now apply sane_isctx.
       }

     (* SubstComp *)
     - {
         apply (@ptt.SubstComp G D E).
         - apply (ptt.sane_issubst sbs G D).
           now apply sane_issubst.
         - apply (ptt.sane_issubst sbt D E).
           now apply sane_issubst.
         - apply (ptt.sane_issubst sbt D E).
           now apply sane_issubst.
         - now apply sane_issubst.
         - now apply sane_issubst.
       }

     (* SubstCtxConv *)
     - {
         apply (@ptt.SubstCtxConv G1 G2 D1 D2).
         - apply (ptt.sane_eqctx G1 G2).
           now apply sane_eqctx.
         - apply (ptt.sane_eqctx G1 G2).
           now apply sane_eqctx.
         - apply (ptt.sane_eqctx D1 D2).
           now apply sane_eqctx.
         - apply (ptt.sane_eqctx D1 D2).
           now apply sane_eqctx.
         - now apply sane_issubst.
         - now apply sane_eqctx.
         - now apply sane_eqctx.
       }
  }

  (* sane_istype *)
  { destruct P.

    (* TyCtxConv *)
    { apply (@ptt.TyCtxConv G D).
      - now apply (ptt.sane_eqctx G D), sane_eqctx.
      - now apply (ptt.sane_eqctx G D), sane_eqctx.
      - now apply sane_istype.
      - now apply sane_eqctx.
    }

    (* TySubst *)
    { apply (@ptt.TySubst G D).
      - now apply (ptt.sane_issubst sbs G D), sane_issubst.
      - now apply (ptt.sane_istype D A), sane_istype.
      - now apply sane_issubst.
      - now apply sane_istype.
    }

    (* TyProd *)
    { apply ptt.TyProd.
      - now apply (ptt.sane_istype G A), sane_istype.
      - now apply sane_istype.
      - now apply sane_istype.
    }

    (* TyId *)
    { apply ptt.TyId.
      - now apply (ptt.sane_istype G A), sane_istype.
      - now apply sane_istype.
      - now apply sane_isterm.
      - now apply sane_isterm.
    }

    (* TyEmpty *)
    { apply ptt.TyEmpty.
      - now apply sane_isctx.
    }

    (* TyUnit *)
    { apply ptt.TyUnit.
      - now apply sane_isctx.
    }

    (* TyBool *)
    { apply ptt.TyBool.
      - now apply sane_isctx.
    }
  }

  (* sane_isterm *)
  { destruct P.

    (* TermTyConv *)
    - { apply (@ptt.TermTyConv G A B).
        - now apply (@ptt.sane_isterm G u A), sane_isterm.
        - now apply (@ptt.sane_isterm G u A), sane_isterm.
        - now apply (@ptt.sane_eqtype G A B), sane_eqtype.
        - now apply sane_isterm.
        - now apply sane_eqtype.
      }

    (* TermCtxConv *)
    - { apply (@ptt.TermCtxConv G D).
        - now apply (@ptt.sane_isterm G u A), sane_isterm.
        - now apply (@ptt.sane_eqctx G D), sane_eqctx.
        - now apply (@ptt.sane_isterm G u A), sane_isterm.
        - now apply sane_isterm.
        - now apply sane_eqctx.
      }

    (* TermSubst *)
    - { apply (@ptt.TermSubst G D A).
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_isterm D u A), sane_isterm.
        - now apply (@ptt.sane_isterm D u A), sane_isterm.
        - now apply sane_issubst.
        - now apply sane_isterm.
      }

    (* TermVarZero *)
    - { apply ptt.TermVarZero.
        - now apply (@ptt.sane_istype G A), sane_istype.
        - now apply sane_istype.
      }

    (* TermVarSucc *)
    - { apply ptt.TermVarSucc.
        - now apply (@ptt.sane_istype G B), sane_istype.
        - now apply (@ptt.sane_isterm G (var k)A), sane_isterm.
        - now apply sane_isterm.
        - now apply sane_istype.
      }

    (* TermAbs *)
    - { apply ptt.TermAbs.
        - now apply (@ptt.sane_istype G A), sane_istype.
        - now apply sane_istype.
        - now apply (@ptt.sane_isterm (ctxextend G A) u B), sane_isterm.
        - now apply sane_isterm.
      }

    (* TermApp *)
    - { apply ptt.TermApp.
        - now apply (@ptt.sane_isterm G v A), sane_isterm.
        - now apply (@ptt.sane_isterm G v A), sane_isterm.
        - now apply sane_istype.
        - now apply sane_isterm.
        - now apply sane_isterm.
      }

    (* TermRefl *)
    - { apply ptt.TermRefl.
        - now apply (ptt.sane_isterm G u A), sane_isterm.
        - now apply (ptt.sane_isterm G u A), sane_isterm.
        - now apply sane_isterm.
      }

    (* TermJ *)
    - { apply ptt.TermJ.
        - now apply (ptt.sane_isterm G u A), sane_isterm.
        - now apply sane_istype.
        - now apply sane_isterm.
        - now apply sane_istype.
        - now apply sane_isterm.
        - now apply sane_isterm.
        - now apply sane_isterm.
      }

    (* TermExfalso *)
    - { apply ptt.TermExfalso.
        - now apply (@ptt.sane_istype G A), sane_istype.
        - now apply sane_istype.
        - now apply sane_isterm.
      }

    (* TermUnit *)
    - { apply ptt.TermUnit.
        - now apply sane_isctx.
      }

    (* TermTrue *)
    - { apply ptt.TermTrue.
        - now apply sane_isctx.
      }

    (* TermFalse *)
    - { apply ptt.TermFalse.
        - now apply sane_isctx.
      }

    (* TermCond *)
    - { apply ptt.TermCond.
        - now apply (@ptt.sane_isterm G u Bool), sane_isterm.
        - now apply sane_isterm.
        - now apply sane_istype.
        - now apply sane_isterm.
        - now apply sane_isterm.
      }
  }

  (* sane_eqctx *)
  { destruct P.

    (* CtxRefl *)
    - { apply ptt.CtxRefl.
        - now apply sane_isctx.
      }

    (* CtxSym *)
    - { apply ptt.CtxSym.
        - now apply (@ptt.sane_eqctx G D), sane_eqctx.
        - now apply (@ptt.sane_eqctx G D), sane_eqctx.
        - now apply sane_eqctx.
      }

    (* CtxTrans *)
    - { apply (@ptt.CtxTrans G D E).
        - now apply (@ptt.sane_eqctx G D), sane_eqctx.
        - now apply (@ptt.sane_eqctx G D), sane_eqctx.
        - now apply (@ptt.sane_eqctx D E), sane_eqctx.
        - now apply sane_eqctx.
        - now apply sane_eqctx.
      }

    (* EqCtxEmpty *)
    - { apply ptt.EqCtxEmpty.
      }

    (* EqCtxExtend *)
    - { apply ptt.EqCtxExtend.
        - now apply (@ptt.sane_eqctx G D), sane_eqctx.
        - now apply (@ptt.sane_eqctx G D), sane_eqctx.
        - now apply (@ptt.sane_eqtype G A B), sane_eqtype.
        - now apply (@ptt.sane_eqtype G A B), sane_eqtype.
        - now apply sane_eqctx.
        - now apply sane_eqtype.
      }
  }

  (* sane_eqsubst *)
  { destruct P.

    (* SubstRefl *)
    - { apply ptt.SubstRefl.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply sane_issubst.
      }

    (* SubstSym *)
    - { apply ptt.SubstSym.
        - now apply (@ptt.sane_eqsubst sbs sbt G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbs sbt G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbs sbt G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbs sbt G D), sane_eqsubst.
        - now apply sane_eqsubst.
      }

    (* SubstTrans *)
    - { apply (@ptt.SubstTrans G D sb1 sb2 sb3).
        - now apply (@ptt.sane_eqsubst sb1 sb2 G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sb1 sb2 G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sb1 sb2 G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sb1 sb2 G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sb2 sb3 G D), sane_eqsubst.
        - now apply sane_eqsubst.
        - now apply sane_eqsubst.
      }

    (* CongSubstZero *)
    - { apply (@ptt.CongSubstZero G1 G2).
        - now apply (@ptt.sane_eqctx G1 G2), sane_eqctx.
        - now apply (@ptt.sane_eqctx G1 G2), sane_eqctx.
        - now apply (@ptt.sane_eqtype G1 A1 A2), sane_eqtype.
        - now apply (@ptt.sane_eqtype G1 A1 A2), sane_eqtype.
        - now apply (@ptt.sane_eqterm G1 u1 u2 A1), sane_eqterm.
        - now apply (@ptt.sane_eqterm G1 u1 u2 A1), sane_eqterm.
        - now apply sane_eqctx.
        - now apply sane_eqtype.
        - now apply sane_eqterm.
      }

    (* CongSubstWeak *)
    - { apply ptt.CongSubstWeak.
        - now apply (@ptt.sane_eqctx G1 G2), sane_eqctx.
        - now apply (@ptt.sane_eqctx G1 G2), sane_eqctx.
        - now apply (@ptt.sane_eqtype G1 A1 A2), sane_eqtype.
        - now apply (@ptt.sane_eqtype G1 A1 A2), sane_eqtype.
        - now apply sane_eqctx.
        - now apply sane_eqtype.
      }

    (* CongSubstShift *)
    - { apply ptt.CongSubstShift.
        - now apply (@ptt.sane_eqctx G1 G2), sane_eqctx.
        - now apply (@ptt.sane_eqctx G1 G2), sane_eqctx.
        - now apply (@ptt.sane_eqtype D A1 A2), sane_eqtype.
        - now apply (@ptt.sane_eqtype D A1 A2), sane_eqtype.
        - now apply (@ptt.sane_eqtype D A1 A2), sane_eqtype.
        - now apply (@ptt.sane_eqsubst sbs1 sbs2 G1 D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbs1 sbs2 G1 D), sane_eqsubst.
        - now apply sane_eqctx.
        - now apply sane_eqsubst.
        - now apply sane_eqtype.
      }

    (* CongSubstComp *)
    - { apply (@ptt.CongSubstComp G D E).
        - now apply (@ptt.sane_eqsubst sbs1 sbs2 G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbs1 sbs2 G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbt1 sbt2 D E), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbs1 sbs2 G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbs1 sbs2 G D), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbt1 sbt2 D E), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbt1 sbt2 D E), sane_eqsubst.
        - now apply sane_eqsubst. 
        - now apply sane_eqsubst. 
      }

    (* EqSubstCtxConv *)
    - { apply (@ptt.EqSubstCtxConv G1 G2 D1 D2).
        - now apply (@ptt.sane_eqctx G1 G2), sane_eqctx.
        - now apply (@ptt.sane_eqctx G1 G2), sane_eqctx.
        - now apply (@ptt.sane_eqctx D1 D2), sane_eqctx.
        - now apply (@ptt.sane_eqctx D1 D2), sane_eqctx.
        - now apply (@ptt.sane_eqsubst sbs sbt G1 D1), sane_eqsubst.
        - now apply (@ptt.sane_eqsubst sbs sbt G1 D1), sane_eqsubst.
        - now apply sane_eqsubst.
        - now apply sane_eqctx.
        - now apply sane_eqctx.
      }

    (* CompAssoc *)
    - { apply (@ptt.CompAssoc G D E F).
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_issubst sbr E F), sane_issubst.
        - now apply (@ptt.sane_issubst sbr E F), sane_issubst.
        - now apply sane_issubst.
        - now apply sane_issubst.
        - now apply sane_issubst.
      }

    (* WeakNat *)
    - { apply ptt.WeakNat.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply sane_issubst.
        - now apply sane_istype.
      }

    (* WeakZero *)
    - { apply ptt.WeakZero.
        - now apply (@ptt.sane_isterm G u A), sane_isterm.
        - now apply (@ptt.sane_isterm G u A), sane_isterm.
        - now apply sane_isterm.
      }

    (* ShiftZero *)
    - { apply ptt.ShiftZero.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_isterm D u A), sane_isterm.
        - now apply sane_issubst.
        - now apply sane_isterm.
      }

    (* CompShift *)
    - { apply ptt.CompShift.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (@ptt.sane_istype E A), sane_istype.
        - now apply sane_issubst.
        - now apply sane_issubst.
        - now apply sane_istype.
      }

    (* CompIdRight *)
    - { apply ptt.CompIdRight.
        - now apply (ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (ptt.sane_issubst sbs G D), sane_issubst.
        - now apply sane_issubst.
      }

    (* CompIdLeft *)
    - { apply ptt.CompIdLeft.
        - now apply (ptt.sane_issubst sbs G D), sane_issubst.
        - now apply (ptt.sane_issubst sbs G D), sane_issubst.
        - now apply sane_issubst.
      }
  }


  (* sane_eqtype *)
  {
    later.
  }

  (* sane_eqterm *)
  {
    later.
  }

Defined.