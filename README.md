# Computational Physics

--------------------------------------------------------------------------------

## General Information

### Content

**Lecturers:** Erik Schnetter, Dustin Lang, several guest lecturers

**Outline:** This course is a practical introduction to computational
physics, mixing theoretical lectures and lab-based (programming) work.
The main topics will be:
- Hyperbolic partial differential equations (PDEs) with examples from
  general relativity
- Linear algebra (matrix factorization) with examples from condensed
  matter physics
- Optimization (in particular convex optimization) with examples from
  quantum information
- Data analysis (image processing) with examples from astronomy

The course begins with an introduction to the Julia language and
related practices (e.g. version control, automated tests). It covers
also certain software technologies such multi-threaded, distributed,
or GPU programming.

**Reference material:** no textbook, although "Scientific Computing"
by Heath might be useful


--------------------------------------------------------------------------------

### Format

**Course number:** This is course PHYS 776 at the [University of
Waterloo](https://uwaterloo.ca/physics-astronomy/)

**Format:** The course consists of six two-week modules; most can be
attended independently

**Assessment mechanism:** One lab assignment per module, pair work is
encouraged

**Assessment type:** pass/fail


--------------------------------------------------------------------------------

### Location

**Location:** Time Room, Perimeter Institute

**Time:** Mondays 13:00 - 14:30 and Wednesdays 12:30 - 14:00

**First Lecture:** Monday Jan. 13, 2020


--------------------------------------------------------------------------------

### Contact

Contact Erik Schnetter <eschnetter@perimeterinstitute.ca> by email, or
open an issue in this repository (which will be public).




--------------------------------------------------------------------------------

## Schedule

**Week 1: Jan 13 & 16: (Note: Class meets on Thu instead of Wed!)**
*Introduction to the [Julia](https://julialang.org) programming
language.* Most of the course content will be based on Julia.

**Week 2: Jan 20 & 22:** *Reproducible science: Git, Github and shell
scripts.* Version control with `git` and friends is a must these days,
not just for big software projects, but also for small lab projects,
coursework, and papers. Being able to reproduce your results is also
essential, and writing `bash` shell scripts is a reasonable way of
doing this.

**Week 3: Jan 27 & 29:** *Discretizing functions.* One often needs to
represent functions in a computer (e.g. a density or velocity field).
We discuss and experiment with a few approaches.

**Week 4: Feb 3 & 5:** *(Elliptic) partial differential equations
(PDEs).* We discuss ODEs, PDEs, and in particular elliptic PDEs. We
will then calculate the structure of a spherically symmetric star in
general relativity, solving the Tolman-Oppenheimer-Volkoff (TOV)
equation.

**Week 5: Feb 10 & 12:** *Time-dependent (hyperbolic) partial
differential equations (PDEs).* Time-dependent problems are more
difficult to solve, as there are numerous ways to encounter
instabilities. We will discuss topics such as well-posedness, stable
discretizations, and will solve a wave equation.

**Week 6: Feb 17 & 19:** *No lectures* (Family Day, Reading week)

**Week 7: Feb 24 & 26:** *Spectral representations.* Working in
Fourier space or with Spherical Harmonics is more natural for some
problems, and the Fast Fourier Transform (FFT) makes this
computationally tractable. FFT libraries have some complexities (pun
intended), so we will experiment with them.

**Week 8: Mar 2 & 4:** *Will East: Relativistic Hydrodynamics*

**Week 9: Mar 9 & 11:** *Denis Rosset: Convex Optimization*

**Week 10: Mar 16 & 18:** *Parallel Computing (threads), Distributed
Computing (MPI)*

**Week 11: Mar 23 & 25:** *Image Processing I.* Using astronomical
images as an example, we will experiment with some basic image
processing algorithms.

**Week 12: Mar 30 & 31:** *Image Processing II.* Building on last
  week's experiments, we will work on detecting and measuring stars in
  astronomical images.
