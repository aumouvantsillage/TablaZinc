% ------------------------------------------------------------------------------
% Input data, from datafiles.
% ------------------------------------------------------------------------------

% The notes to play, represented by their MIDI numbers (A0=21, C8=108).
% We do not support polyphony yet.
array[int] of int: melody;

% Fingers are numbered as: none=0, index=1, middle=2, ring=3, pinky=4.
% In the tablature output, each finger will be represented by a one-letter ID.
array[int] of string: finger_ids;

% String tuning, as an array of MIDI note numbers.
array[int] of int: string_tuning;

% The length of a string, in semitones.
int: string_length;

% ------------------------------------------------------------------------------
% Helper constants and data validation.
% ------------------------------------------------------------------------------

int: melody_length = length(melody);
set of int: note_index = 1..melody_length;

constraint assert(melody_length > 1,
    "Invalid datafile: melody should contain at least two notes."
);

int: finger_count = length(finger_ids);
set of int: finger_index = 0..finger_count;

constraint assert(finger_count > 0,
    "Invalid datafile: finger count is too small."
);

int: string_count = length(string_tuning);
set of int: string_index = 1..string_count;

constraint assert(string_count > 0,
    "Invalid datafile: string count is too small."
);

set of int: fret_index = 0..string_length;

constraint assert(string_length ≥ finger_count,
    "Invalid datafile: string length is too small."
);

% ------------------------------------------------------------------------------
% Decision variables.
% ------------------------------------------------------------------------------

% The result will be computed as a sequence of triplets (string_index, fret_index, finger_index).
% We consider that only one note can be played at a given fret on a given string (i.e. no bending).
array[note_index] of var string_index: tab_strings;
array[note_index] of var fret_index:   tab_frets;
array[note_index] of var finger_index: tab_fingers;

% ------------------------------------------------------------------------------
% Constraints.
% ------------------------------------------------------------------------------

% The relationship between notes, strings and frets.
constraint forall(n ∈ note_index) (
    string_tuning[tab_strings[n]] + tab_frets[n] = melody[n]
);

% Always use 0 as the finger index for open strings.
constraint forall(n ∈ note_index) (
    tab_frets[n] = 0 ↔ tab_fingers[n] = 0
);

% ------------------------------------------------------------------------------
% Output.
% ------------------------------------------------------------------------------

output [
    let {
        string_index: current_string = fix(tab_strings[n]);
        finger_index: current_finger = fix(tab_fingers[n]);
        fret_index:   current_fret   = fix(tab_frets[n]);
    } in
    if current_string = s then
        "-"                                         ++
        if current_fret < 10 then "-" else "" endif ++
        show(current_fret)                          ++
        if current_finger > 0 then finger_ids[current_finger] else "-" endif
    else
        "----"
    endif ++
    if n = melody_length then "-\n" else "" endif |
    s ∈ reverse(string_index), n ∈ note_index
];
