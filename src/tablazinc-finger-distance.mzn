
include "tablazinc-common.mzn";

% ------------------------------------------------------------------------------
% Step 3: Minimize the distance between consecutive finger positions.
% ------------------------------------------------------------------------------

int: slide_factor = 2;

% Prevent using the same finger when two consecutive notes are played
% on different frets and different strings.
constraint forall(n ∈ 2..melody_length) (
    tab_strings[n] ≠ tab_strings[n - 1] ∧
    tab_frets[n]   ≠ tab_frets[n - 1]   ∧
    tab_frets[n]   ≠ 0                  →
    tab_fingers[n] ≠ tab_fingers[n - 1]
);

% When consecutive notes are played in the same fret on different strings,
% with the same finger, we assume this is a barré with the index.
constraint forall(n ∈ 2..melody_length) (
    tab_strings[n] ≠ tab_strings[n - 1] ∧
    tab_frets[n]   = tab_frets[n - 1]   ∧
    tab_frets[n]   ≠ 0                  ∧
    tab_fingers[n] = tab_fingers[n - 1] →
    tab_fingers[n] = 1
);

% When consecutive notes are played in the same fret on different strings,
% the strings and fingers must follow the same order.
constraint forall(n ∈ 2..melody_length) (
    tab_strings[n] > tab_strings[n - 1] ∧
    tab_frets[n]   = tab_frets[n - 1]   ∧
    tab_frets[n]   ≠ 0                  →
    tab_fingers[n] ≥ tab_fingers[n - 1]
);

constraint forall(n ∈ 2..melody_length) (
    tab_strings[n] < tab_strings[n - 1] ∧
    tab_frets[n]   = tab_frets[n - 1]   ∧
    tab_frets[n]   ≠ 0                  →
    tab_fingers[n] ≤ tab_fingers[n - 1]
);

function var float: finger_distance(note_index: m, note_index: n) =
    let {
        var int: dfr = tab_frets[n]   - tab_frets[m];
        var int: dfi = tab_fingers[n] - tab_fingers[m];
        var int: dst = tab_strings[n] - tab_strings[m];
    } in
    if dfr ≠ 0 then
        % Notes are played on different frets.
        % The distance is the difference between the fret interval and the finger interval.
        % Sliding has a lower cost.
        if dst = 0 ∧ dfi = 0 then
            abs(dfr) / slide_factor
        else
            abs(dfr - dfi)
        endif
    else
        % Notes are played on the same fret.
        % Minimize the distance between fingers used.
        abs(dfi)
    endif;

solve minimize sum([ finger_distance(n - 1, n) | n ∈ 2..melody_length ]);
