# Initial Campaign Packet

Status: draft until required sign-offs are recorded.

## Purpose

This packet gates promotion claims and intentionally promotion-eligible
campaign launches. It does not gate all implementation work:
controller-authorized construction can proceed under explicit non-claims while
promotion review is pending. It references the live campaign artifacts instead
of duplicating them; keep those artifacts current and use this file to record
that the initial objective, working capability target, executable design
deliverable, readiness boundary, and DV/evidence boundary have been reviewed
by the right authorities.

## Required Sign-Offs

| Role | Required Review | Sign-Off Status | Sign-Off Record |
| --- | --- | --- | --- |
| Human silicon architect | Objective, working capability target, executable design deliverable, readiness ladder, hard gates, soft preferences, baselines, accepted tradeoffs, user-visible boundaries, area/power/performance/security intent | pending; set to `signed` when complete | TBD |
| DV engineer / verification owner | Full initial DV/evidence-plan adequacy for the capability target, deliverable/readiness ladder, promotion matrix, evidence tiers, known gaps, deferred DV, re-review triggers | pending; set to `signed` when complete | TBD |

## Controller-Recorded Discovery/Implementation Exception

Use this when the controller explicitly allows narrowed-scope discovery or
implementation before the two sign-offs above are complete. It should name the
useful construction path that may continue, what is deferred, the non-claims
that label the work, and why no promotion claim is approved yet.

| Role | Required Review | Exception Status | Exception Record |
| --- | --- | --- | --- |
| Controller-recorded discovery/implementation exception | Narrowed-scope construction path, deferred reviews, preserved non-claims, and no promotion approval | recorded | User request of 2026-07-16 authorizes implementation and recorded static/directed checks under the supplied claim boundary. Human silicon-architect and DV-owner promotion sign-offs remain pending. |

## Campaign Artifacts Under Review

- `objective.md` and `objective.json`
- `dv-plan.md`
- `milestones.md` and `milestones.json`
- `candidate-ledger.md`
- `decision-log.md`

## Initial DV/Evidence Plan Boundary

`dv-plan.md` must be complete enough at campaign resolution for
independent review. At minimum it should name evidence tiers, the promotion
matrix or coverage surface, configs/modes/seeds/traffic/reset/error/security
surfaces relevant to the objective, pass/fail criteria per tier,
source/provenance and reproduction requirements, known gaps or deferred
decisions, non-claims, and re-review triggers.
It should also identify construction work that remains valid when a stronger
promotion claim is pending verifier review.

## Re-Review Triggers

- hard gate, success metric, baseline, comparison flow, or promotion matrix changes;
- public interface, architectural boundary, security boundary, reset/clock/CDC, or data-integrity risk changes;
- evidence tier, accepted non-claim, or deferred-DV boundary changes;
- promoted candidate work outside the signed source/base boundary;
- verifier downgrades, blocks, or requires reruns for a promotion-relevant claim.

## Non-Claims

- This packet records review state; it does not accept a design claim.
- Sign-off on the initial packet does not waive later evidence gaps or material-change re-review.
