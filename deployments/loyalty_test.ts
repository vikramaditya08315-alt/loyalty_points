
import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const alice = accounts.get("deployer")!;
const bob = accounts.get("wallet_1")!;

describe("Loyalty Points Contract", () => {
  it("issues points to a user", () => {
    const { result: issueResult } = simnet.callPublicFn("loyalty", "issue-points", [alice.address, 100], alice.address);
    expect(issueResult).toBeOk(100);

    const { result: balanceResult } = simnet.callReadOnlyFn("loyalty", "get-balance", [alice.address], alice.address);
    expect(balanceResult).toBeOk(100);

    const { result: supplyResult } = simnet.callReadOnlyFn("loyalty", "get-total-supply", [], alice.address);
    expect(supplyResult).toBeOk(100);
  });

  it("redeems points for a user", () => {
    simnet.callPublicFn("loyalty", "issue-points", [bob.address, 50], bob.address);
    const { result: redeemResult } = simnet.callPublicFn("loyalty", "redeem-points", [30], bob.address);
    expect(redeemResult).toBeOk(30);

    const { result: balanceResult } = simnet.callReadOnlyFn("loyalty", "get-balance", [bob.address], bob.address);
    expect(balanceResult).toBeOk(20);

    const { result: supplyResult } = simnet.callReadOnlyFn("loyalty", "get-total-supply", [], bob.address);
    expect(supplyResult).toBeOk(20);
  });

  it("fails to redeem more points than available", () => {
    const { result } = simnet.callPublicFn("loyalty", "redeem-points", [100], bob.address);
    expect(result).toBeErr("Insufficient points");
  });
});
