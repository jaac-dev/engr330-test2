# Results

| Module | Width | Max Time | # of LUTs |
| ------ | ----- | -------- | --------- |
| rca    | 8     | 7.118ns  | 8         |
| rca    | 16    | 9.496ns  | 29        |
| rca    | 32    | 12.324ns | 56        |
| rca    | 64    | 19.844ns | 112       |
| cla    | 8     | 7.132ns  | 13        |
| cla    | 16    | 9.496ns  | 29        |
| cla    | 32    | 9.856ns  | 67        |
| cla    | 64    | 13.395ns | 148       |
| pa     | 8     | 7.118ns  | 8         |
| pa     | 16    | 9.496ns  | 29        |
| pa     | 32    | 9.130ns  | 144       |
| pa     | 64    | 9.290ns  | 363       |

As can be seen, the RCA scales pretty linearly in terms of resources, but has drastic max time increases. The CLA scales exponentionally in terms of resources, but has a pretty linear max time scale. The PA is arguably the best implementation having the lowest max path at 64 bits.
