// Copyright 2015 Stellar Development Foundation and contributors. Licensed
// under the Apache License, Version 2.0. See the COPYING file at the root
// of this distribution or at http://www.apache.org/licenses/LICENSE-2.0
module scp.Stellar_SCP_XDR;

import scp.Stellar_types_XDR;
//import stdcpp.vector;

//extern(C++, stellar):

//alias vector!ubyte Value;
/*
struct SCPBallot
{
    uint32 counter; // n
    Value value;    // x
	}*/

enum SCPStatementType
{
    SCP_ST_PREPARE = 0,
    SCP_ST_CONFIRM = 1,
    SCP_ST_EXTERNALIZE = 2,
    SCP_ST_NOMINATE = 3
}

/*
struct SCPNomination
{
    Hash quorumSetHash; // D
    vector!Value votes;      // X
    vector!Value accepted;   // Y
	}*/
 /*
struct SCPStatement
{
    NodeID nodeID;    // v
    uint64 slotIndex; // i

    union pledges //switch (SCPStatementType type)
    {
		//case SCP_ST_PREPARE:
        struct prepare
        {
            Hash quorumSetHash;       // D
            SCPBallot ballot;         // b
            SCPBallot* prepared;      // p
            SCPBallot* preparedPrime; // p'
            uint32 nC;                // c.n
            uint32 nH;                // h.n
        }
		//case SCP_ST_CONFIRM:
        struct confirm
        {
            SCPBallot ballot;   // b
            uint32 nPrepared;   // p.n
            uint32 nCommit;     // c.n
            uint32 nH;          // h.n
            Hash quorumSetHash; // D
        }
		//case SCP_ST_EXTERNALIZE:
        struct externalize
        {
            SCPBallot commit;         // c
            uint32 nH;                // h.n
            Hash commitQuorumSetHash; // D used before EXTERNALIZE
        }
		//case SCP_ST_NOMINATE:
        SCPNomination nominate;
    }
}

struct SCPEnvelope
{
    SCPStatement statement;
    Signature signature;
	}*/

// supports things like: A,B,C,(D,E,F),(G,H,(I,J,K,L))
// only allows 2 levels of nesting
struct SCPQuorumSet
{
    uint32 threshold;
	void[52] data;
//    vector!PublicKey validators;
//    vector!SCPQuorumSet innerSets;
}

static assert(SCPQuorumSet.sizeof == 56);
