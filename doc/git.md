Difference between reset and checkout:

                             |  head  | index |  wd   |  wd safe
    Commit Level -----------------------------------------------
    reset --soft [commit]    |  REF   |  NO   |  NO   |  YES
    reset [commit]           |  REF   |  YES  |  NO   |  YES
    reset --hard [commit]    |  REF   |  YES  |  YES  |  NO
    checkout [commit]        |  HEAD  |  YES  |  YES  |  YES

    File Level -------------------------------------------------
    reset (commit) [file]    |  NO    |  YES  |  NO   |  YES
    checkout (commit) [file] |  NO    |  YES  |  YES  |  NO
