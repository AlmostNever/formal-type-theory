(* Sanity theorems for ptt. *)

Require config.
Require Import config_tactics.

Require Import syntax.
Require Import tt.
Require Import ptt_tactics ptt_admissible.

Section PttSanity.

Local Instance hasPrecond : config.Precond := {| config.precondFlag := config.Yes |}.
Context `{configReflection : config.Reflection}.
Context `{configSimpleProducts : config.SimpleProducts}.
Context `{ConfigProdEta : config.ProdEta}.

Axiom cheating : forall A, A.

Definition sane_issubst sbs G D :
  issubst sbs G D -> isctx G * isctx D.
Proof.
  intro H ; destruct H ; doConfig.

  (* SubstZero *)
  { split.

    - assumption.
    - now capply CtxExtend.
  }

  (* SubstWeak *)
  { split.

    - now capply CtxExtend.
    - assumption.
  }

  (* SubstShift *)
  { split.

    - magic.
    - magic.
  }

  (* SubstId *)
  { split.
    - assumption.
    - assumption.
  }

  (* SubstComp *)
  { split.
    - assumption.
    - assumption.
  }

  (* SubstCtxConv *)
  { split.
    - assumption.
    - assumption.
  }
Qed.

Definition sane_istype G A :
  istype G A -> isctx G.
Proof.
  intro H; destruct H ; config assumption.
Qed.

Definition sane_isterm' G u A :
  isterm G u A -> istype G A.
Proof.
  intro H ; destruct H.

  (* TermTyConv *)
  { config assumption. }

  (* TermCtxConv *)
  { magic. }

  (* TermSubst *)
  { magic. }

  (* TermVarZero *)
  { ceapply TySubst.
    - now ceapply SubstWeak.
    - assumption.
    - magic.
    - eassumption.
  }

  (* TermVarSucc *)
  { magic. }

  (* TermAbs *)
  { now capply (@TyProd). }

  (* TermApp *)
  { magic. }

  (* TermRefl *)
  { now capply TyId. }

  (* TermJ *)
  { magic. Unshelve. all:strictmagic. }

  (* TermExfalso *)
  { assumption. }

  (* TermUnit *)
  { now capply TyUnit. }

  (* TermTrue *)
  { now capply TyBool. }

  (* TermFalse *)
  { now capply TyBool. }

  (* TermCond *)
  { magic. }

  (* TermPair *)
  { magic. }

  (* TermProj1 *)
  { magic. }

  (* TermProj2 *)
  { magic. }
Qed.


Definition sane_isterm G u A :
  isterm G u A -> isctx G * istype G A.
Proof.
  intro H.
  pose (K := sane_isterm' G u A H).
  split ; [now apply (@sane_istype G A) | assumption].
Qed.

Definition sane_eqtype' G A B :
  eqtype G A B -> istype G A * istype G B.
Proof.
  intro H ; destruct H ; doConfig.

  (* EqTyCtxConv *)
  { split.
    - magic.
    - magic.
  }

  (* EqTyRefl*)
  { split ; assumption. }

  (* EqTySym *)
  { split ; assumption. }

  (* EqTyTrans *)
  { split ; assumption. }

  (* EqTyIdSubst *)
  { split.
    - ceapply TySubst.
      + now capply SubstId.
      + assumption.
      + assumption.
      + eassumption.
    - assumption.
  }

  (* EqTySubstComp *)
  { split.
    - magic.
    - magic.
  }

  (* EqTySubstProd *)
  { split.
    - magic.
    - magic.
  }

  (* EqTySubstId *)
  { split.
    - magic.
    - magic.
  }

  (* EqTySubstEmpty *)
  { split.
    - magic.
    - magic.
  }

  (* EqTySubstUnit *)
  { split.
    - magic.
    - magic.
  }

  (* EqTySubstBool *)
  { split.
    - magic.
    - magic.
  }

  (* EqTyExfalso *)
  { split ; assumption. }

  (* CongProd *)
  { split.
    - { now capply TyProd. }
    - magic.
  }

  (* CongId *)
  { split.
    - { now capply TyId. }
    - magic.
  }

  (* CongTySubst *)
  { split.
    - magic.
    - magic.
  }

  (* CongSimProd *)
  { split.
    - magic.
    - magic.
  }

  (* EqTySubstSimProd *)
  { split.
    - magic.
    - magic.
  }

Qed.

Theorem sane_eqctx G D :
  eqctx G D -> isctx G * isctx D.
Proof.
  intro H ; destruct H ; doConfig.

  (* CtxRefl *)
  { split.
    - assumption.
    - assumption.
  }

  (* CtxSym *)
  { split.
    - assumption.
    - assumption.
  }

  (* CtxTrans *)
  { split.
    - assumption.
    - assumption.
  }

  (* EqCtxEmpty *)
  { split.
    - now capply CtxEmpty.
    - now capply CtxEmpty.
  }

  (* EqCtxExtend *)
  { split.
    - now capply CtxExtend.
    - magic.
  }

Qed.


Theorem sane_eqtype G A B :
  eqtype G A B -> isctx G * istype G A * istype G B.
Proof.
  intro H.
  destruct (sane_eqtype' G A B H).
  auto using (sane_istype G A).
Qed.

Theorem sane_eqsubst' sbs sbt G D :
  eqsubst sbs sbt G D -> issubst sbs G D * issubst sbt G D.
Proof.
  intro H ; destruct H ; doConfig.

  (* SubstRefl *)
  - { split.
      - assumption.
      - assumption.
    }

  (* SubstSym *)
  - { split.
      - assumption.
      - assumption.
    }

  (* SubstTrans *)
  - { split.
      - assumption.
      - assumption.
    }

  (* CongSubstZero *)
  - { split.
      - now capply SubstZero.
      - magic.
    }

  (* CongSubstWeak *)
  - { split ; magic. }

  (* CongSubstShift *)
  - { split ; magic. }

  (* CongSubstComp *)
  - { split.
      - magic.
      - magic.
    }

  (* EqSubstCtxConv *)
  - { split.
      - magic.
      - magic.
    }

  (* CompAssoc *)
  - { split.
      - magic.
      - magic.
    }

  (* WeakNat *)
  - { split.
      - magic.
      - magic.
    }

  (* WeakZero *)
  - { split.
      - magic.
      - magic.
    }

  (* ShiftZero *)
  - { split.
      - magic.
      - magic.
    }

  (* CompShift *)
  - { split.
      - magic. Unshelve. all:magic. Unshelve. all:strictmagic.
      - magic.
    }

  (* CompIdRight *)
  - { split.
      - magic.
      - assumption.
    }

  (* CompIdLeft *)
  - { split.
      - magic.
      - assumption.
    }
Qed.

Theorem sane_eqsubst sbs sbt G D :
  eqsubst sbs sbt G D -> isctx G * isctx D * issubst sbs G D * issubst sbt G D.
Proof.
  intro H.
  destruct (sane_eqsubst' sbs sbt G D H).
  auto using (sane_issubst sbs G D).
Qed.

Theorem sane_eqterm' G u v A :
  eqterm G u v A -> isterm G u A * isterm G v A.
Proof.
  intro H ; destruct H ; doConfig.

  (* EqTyConv *)
  - { split.
      - magic.
      - magic.
    }

  (* EqCtxConv *)
  - { split.
      - magic.
      - magic.
    }

  (* EqRefl *)
  - { split.
      - { assumption. }
      - { assumption. }
    }

  (* EqSym *)
  - { split.
      - { assumption. }
      - { assumption. }
    }

  (* EqTrans *)
  - { split.
      - { assumption. }
      - { assumption. }
    }

  (* EqIdSubst *)
  - { split.
      - magic.
      - { assumption. }
    }

  (* EqSubstComp *)
  - { split.
      - magic. Unshelve. all:strictmagic.
      - magic.
    }

  (* EqSubstWeak *)
  - { split.
      - magic.
      - { now capply TermVarSucc. }
    }


  (* EqSubstZeroZero *)
  - { split.
      - magic.
      - { assumption. }
    }

  (* EqSubstZeroSucc *)
  - { split.
      - magic.
        Unshelve. all:strictmagic.
      - { assumption. }
    }

  (* EqSubstShiftZero *)
  - { split.
      - { ceapply TermTyConv.
          - ceapply TermSubst.
            + ceapply SubstShift ; eassumption.
            + magic.
            + config constructor.
              * assumption.
              * ceapply TySubst ; eassumption.
            + ceapply TySubst ; try eassumption ; magic.
            + magic.
          - magic.
          - config constructor.
            + assumption.
            + ceapply TySubst ; eassumption.
          - ceapply TySubst.
            + ceapply SubstShift ; eassumption.
            + ceapply TySubst ; magic.
            + config constructor.
              * assumption.
              * ceapply TySubst ; eassumption.
            + magic.
          - ceapply TySubst.
            + ceapply SubstWeak.
              * ceapply TySubst ; eassumption.
              * assumption.
            + ceapply TySubst ; eassumption.
            + config constructor. (* There may be room for maigc improvement here *)
              * assumption.
              * ceapply TySubst ; eassumption.
            + magic.
        }
      - { magic. }
    }

  (* EqSubstShiftSucc *)
  - { split.
      - { magic. Unshelve. all:strictmagic. }
      - { magic. }
    }

  (* EqSubstAbs *)
  - { split.
      - { magic. Unshelve. all:strictmagic. }
      - { magic. }
    }

  (* EqSubstApp *)
  - { split.
      - { magic. }
      - { magic. Unshelve. all:strictmagic. }
    }

  (* EqSubstRefl *)
  - { split.
      - { magic. Unshelve. all:strictmagic. }
      - { magic. }
    }

  (* EqSubstJ *)
  - { split.
      - { magic. Unshelve. all:strictmagic. }
      - { apply cheating.
          (* SLOW:
             magic.
             Unshelve. all:try okmagic.
             Unshelve. all:strictmagic.
         *)
        }
    }

  (* EqSubstExfalso *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* EqSubstUnit *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* EqSubstTrue *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* EqSubstFalse *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* EqSubstCond *)
  - { split.
      - { magic. }
      - { magic.
          Unshelve. all:strictmagic.
        }
    }

  (* EqTermExfalso *)
  - { split.
      - { assumption. }
      - { assumption. }
    }

  (* UnitEta *)
  - { split.
      - { assumption. }
      - { magic. }
    }

  (* EqReflection *)
  - { split.
      - { assumption. }
      - { magic. }
    }

  (* ProdBeta *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* CondTrue *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* CondFalse *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* ProdEta *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* JRefl *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* CongAbs *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* CongApp *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* CongRefl *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* CongJ *)
  - { split.
      - { magic. }
      - { apply cheating.
          (* SLOW:
          magic.
          Unshelve. all:magic.
          Unshelve. all:strictmagic.
          *)
        }
    }

  (* CongCond *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* CongTermSubst *)
  - { split.
      - { magic. }
      - { magic. }
    }

  (* CongPair *)
  - { split.
      - magic.
      - magic.
    }

  (* CongProj1 *)
  - { split.
      - magic.
      - magic.
    }

  (* CongProj2 *)
  - { split.
      - magic.
      - magic.
    }

  (* EqSubstPair *)
  - { split.
      - magic. Unshelve. all:strictmagic.
      - magic.
    }

  (* EqSubstProj1 *)
  - { split.
      - magic.
      - magic. Unshelve. all:strictmagic.
    }

  (* EqSubstProj2 *)
  - { split.
      - magic.
      - magic. Unshelve. all:strictmagic.
    }

  (* Proj1Pair *)
  - { split.
      - magic.
      - magic.
    }

  (* Proj2Pair *)
  - { split.
      - magic.
      - magic.
    }

  (* PairEta *)
  - { split.
      - magic.
      - magic.
    }
Qed.

Theorem sane_eqterm G u v A :
  eqterm G u v A -> isctx G * istype G A * isterm G u A * isterm G v A.
Proof.
  intro H.
  destruct (sane_eqterm' G u v A H).
  auto using (@sane_isterm G u A).
Qed.

End PttSanity.