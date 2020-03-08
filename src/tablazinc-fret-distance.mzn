
include "tablazinc-common.mzn";

% ------------------------------------------------------------------------------
% Step 2: Minimize the distance between consecutive frets.
% ------------------------------------------------------------------------------

function var int: fret_distance(note_index: n) =
    abs(tab_frets[n] - tab_frets[n - 1]);

solve minimize sum([ fret_distance(n) | n ∈ 2..melody_length ]);
