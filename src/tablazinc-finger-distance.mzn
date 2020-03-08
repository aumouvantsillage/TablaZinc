
include "tablazinc-common.mzn";
include "tablazinc-finger-constraints.mzn";

% ------------------------------------------------------------------------------
% Step 3: Minimize the average distance between consecutive finger positions.
% ------------------------------------------------------------------------------

int: slide_factor = 2;

function var float: finger_distance(note_index: n) =
    let {
        var int: dfr = tab_frets[n]   - tab_frets[n - 1];
        var int: dfi = tab_fingers[n] - tab_fingers[n - 1];
        var int: dst = tab_strings[n] - tab_strings[n - 1];
    } in
    % The distance is the difference between the fret interval and the finger interval.
    % Sliding has a lower cost.
    if dst = 0 ∧ dfi = 0 then
        abs(dfr) / slide_factor
    else
        abs(dfr - dfi)
    endif;

solve minimize sum([ finger_distance(n) | n ∈ 2..melody_length ]);
