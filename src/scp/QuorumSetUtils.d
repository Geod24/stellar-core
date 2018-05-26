// Copyright 2016 Stellar Development Foundation and contributors. Licensed
// under the Apache License, Version 2.0. See the COPYING file at the root
// of this distribution or at http://www.apache.org/licenses/LICENSE-2.0
module scp.QuorumSetUtils;

import scp.Stellar_types_XDR;
import scp.Stellar_SCP_XDR;

//@nogc nothrow:

private struct QuorumSetSanityChecker
{
public:
    this(ref const SCPQuorumSet qSet, bool extraChecks)
    {
        this.mExtraChecks = extraChecks;
        this.mIsSane = this.checkSanity(qSet, 0) && mCount >= 1 && mCount <= 1000;
    }

    bool isSane() const
    {
        return mIsSane;
    }

  private:
    bool mExtraChecks;
    bool[NodeID] mKnownNodes;
    bool mIsSane;
    size_t mCount;

    bool checkSanity(ref const SCPQuorumSet qSet, int depth)
	{
		if (depth > 2)
			return false;

		if (qSet.threshold < 1)
			return false;

		auto v = qSet.validators;
		auto i = qSet.innerSets;

		size_t totEntries = v.length + i.length;
		size_t vBlockingSize = totEntries - qSet.threshold + 1;
		mCount += v.length;

		if (qSet.threshold > totEntries)
			return false;

		// threshold is within the proper range
		if (mExtraChecks && qSet.threshold < vBlockingSize)
			return false;

		foreach (const ref n; v)
		{
			// TODO: Fix memory allocation
			if (n in this.mKnownNodes)
				return false;
			this.mKnownNodes[n] = true;
		}

		foreach (const ref iSet; i)
		{
			if (!checkSanity(iSet, depth + 1))
			{
				return false;
			}
		}
		return true;
	}
}
extern(C++, stellar):

// DMD/LDC doesn't perform substitutions :(
pragma(mangle, "_ZN7stellar15isQuorumSetSaneERKNS_12SCPQuorumSetEb")
public bool isQuorumSetSane(ref const SCPQuorumSet qSet, bool extraChecks)
{
    auto checker = QuorumSetSanityChecker(qSet, extraChecks);
    return checker.isSane();
}

version(none):
// helper function that:
//  * removes nodeID
//      { t: n, v: { ...BEFORE... , nodeID, ...AFTER... }, ...}
//      { t: n-1, v: { ...BEFORE..., ...AFTER...} , ... }
//  * simplifies singleton inner set into outerset
//      { t: n, v: { ... }, { t: 1, X }, ... }
//        into
//      { t: n, v: { ..., X }, .... }
//  * simplifies singleton innersets
//      { t:1, { innerSet } } into innerSet
pragma(mangle, "_ZN7stellar13normalizeQSetERNS_12SCPQuorumSetEPKNS_9PublicKeyE")
public void normalizeQSet(ref SCPQuorumSet qSet, const NodeID* idToRemove)
{
	import core.stdc.string : memmove;
	import std.algorithm.searching : countUntil;

    auto v = &qSet.validators;
    if (idToRemove && v.length)
    {
		auto idx = countUntil!(val => val == *idToRemove)(*v);
		assert(idx >= 0);
        qSet.threshold -= (v.length - idx);
        *v = (*v)[0 .. idx];
    }

	for (size_t idx; idx < qSet.innerSets.length; ++idx)
    {
		auto it = &qSet.innerSets[idx];
        normalizeQSet(*it, idToRemove);
        // merge singleton inner sets into validator list
        if (it.threshold == 1 && it.validators.length == 1 &&
            it.innerSets.length == 0)
        {
			*v ~= (*it).validators;
			--idx; // Avoid skipping an element
			memmove(qSet.innerSets.ptr + idx, qSet.innerSets.ptr + idx + 1,
					(qSet.innerSets.length - idx) * qSet.innerSets[0].sizeof);
        }
    }

    // simplify quorum set if needed
    if (qSet.threshold == 1 && v.length == 0 && qSet.innerSets.length == 1)
		qSet = qSet.innerSets[0];
}
