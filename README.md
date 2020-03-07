# TablaZinc

This is an experiment to generate tablatures for fretted string instruments --
such as the guitar, bass, mandolin,  banjo, etc -- using a constraint solver.

The input is a melody, represented by an array of MIDI note numbers
with no duration indication.
The output is a tablature with fingering annotations for the fretting hand.

The `src` and `data` folders contain model files and data files
written in the [MiniZinc](https://www.minizinc.org/) language.

Disclaimer
----------

I have no prior experience with constraint programming in general,
and MiniZinc in particular.

If you are a beginner in this field and are looking for well-written examples,
this repository might not be the right place.

If you are an expert, your feedback will be welcome.
Please [open a new issue](https://github.com/senshu/TablaZinc/issues).

Usage
-----

The following command outputs a tablature from two data files
(an instrument definition file, and a melody file)
using a set of constraints specified in a model file:

```
minizinc src/<model-file> data/<instrument-file> data/<melody-file>
```

Example
-------

We provide the following data files:

* `data/guitar-std.dzn`, instrument definition parameters for the guitar in standard tuning.
* `data/yardbird-suite.dzn`, the first eight bars of the jazz standard *Yardbird Suite* by Charlie Parker,
  where consecutive notes with the same pitch have been merged.

Three model files are currently available:

* `src/tablazinc-satisfy.mzn` generates a tablature with the correct notes, but
  with no concern for playability.

```
-8i--3i--5i--6i--4i--0---1i--3i--0---1i--0---1i--3i--0-----------0---1i--3i--5i--0---1i--3i-
---------------------------------------------------------1i--3i-----------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
```

* `src/tablazinc-fret-distance.mzn` attempts to minimize the distance between
  consecutive notes on the fretboard. There is no constraint on which finger to use for each note.

```
-8i-----------------------------------------------------------------------------------------
-----8i-10i-11i--9i----------8i------------------8i--5i-------------------------------------
---------------------9i-10i------9i-10i--9i-10i----------5i--7i--9i-10i-12i-14i-------------
--------------------------------------------------------------------------------14i-15i-17i-
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
```

* `src/tablazinc-finger-distance.mzn` attempts to minimize the distance between
  finger locations for consecutive notes. This version can take several minutes to complete
  with the default solver, even for such a short melody.

```
-8i-----------------------------------------------------------------------------------------
-----8i-10r-11r--9i---------------------------------------------------------10m-------------
---------------------9i-10m-12p--9i-10m--9i-10m-12p--9i----------9i-10m-12p------9i-10m-12p-
--------------------------------------------------------10m-12p-----------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
```

The fingering annotations use the letters `i` (index), `m` (middle), `r` (ring), and `p` (pinky).
If you have a different number of fingers, or if you want to use other letters,
you can change the parameter `finger_ids` in the instrument definition file `guitar-std.dzn`.
