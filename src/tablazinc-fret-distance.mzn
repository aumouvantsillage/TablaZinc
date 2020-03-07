
include "tablazinc-common.mzn";

% ------------------------------------------------------------------------------
% Step 2: Minimize the distance between consecutive frets.
% ------------------------------------------------------------------------------

function var int: fret_distance(note_index: m, note_index: n) =
    abs(tab_frets[n] - tab_frets[m]);

solve minimize sum([ fret_distance(n - 1, n) | n ∈ 2..melody_length ]);
