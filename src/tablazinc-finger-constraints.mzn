
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
