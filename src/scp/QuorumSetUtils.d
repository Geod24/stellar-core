// Copyright 2016 Stellar Development Foundation and contributors. Licensed
// under the Apache License, Version 2.0. See the COPYING file at the root
// of this distribution or at http://www.apache.org/licenses/LICENSE-2.0
module scp.QuorumSetUtils;

struct SCPQuorumSet
{
    uint threshold;
	void[52] data;
}

static assert(SCPQuorumSet.sizeof == 56);

extern(C++, stellar):

// DMD/LDC doesn't perform substitutions :(
pragma(mangle, "_ZN7stellar15isQuorumSetSaneERKNS_12SCPQuorumSetEb")
public bool isQuorumSetSane(ref const SCPQuorumSet qSet, bool extraChecks)
{
	// import core.stdc.stdio;
	// printf("Hello from D side!\n");
	import std.stdio;
	writeln("Hello with an initialized D runtime!");
	return true;
}
