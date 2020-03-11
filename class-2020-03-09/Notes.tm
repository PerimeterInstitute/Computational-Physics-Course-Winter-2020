<TeXmacs|1.99.12>

<style|generic>

<\body>
  <doc-data|<doc-title|Opinionated survey of (non)convex optimization
  tools<line-break>(and related topics)>|<doc-author|<author-data|<author-name|Denis
  Rosset>|<\author-affiliation>
    Perimeter Institute
  </author-affiliation>>>>

  A generic optimization problem is written

  <\equation>
    <tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<table|<row|<cell|<text|minimize>>|<cell|f<around*|(|<wide|x|\<vect\>>|)>>|<cell|>>|<row|<cell|over>|<cell|<wide|x|\<vect\>>\<in\><with|font|Bbb*|R><rsup|n>>|<cell|>>|<row|<cell|<text|such
    that>>|<cell|x<rsub|i>\<in\><with|font|Bbb*|Z>>|<cell|i\<in\>\<cal-I\>\<subset\><around*|{|1,\<ldots\>,n|}>>>|<row|<cell|>|<cell|g<rsub|j><around*|(|<wide|x|\<vect\>>|)>\<leq\>0>|<cell|j\<in\>\<cal-J\>>>|<row|<cell|>|<cell|h<rsub|k><around*|(|<wide|x|\<vect\>>|)>=0>|<cell|k\<in\>\<cal-K\>>>>>>
  </equation>

  where <math|\<cal-J\>=<around*|{|1,\<ldots\>,<around*|\||\<cal-J\>|\|>|}>>
  and <math|\<cal-K\>=<around*|{|1,\<ldots\>,<around*|\||\<cal-K\>|\|>|}>>.

  <section|Reference material>

  The material below is a synthesis of our first-hand experiences with
  various solvers and problems. Our reference for optimization is the
  book<nbsp><cite|Nocedal2000> by Nocedal and Wright (copy here
  <slink|http://fourier.eng.hmc.edu/e176/lectures/NumericalOptimization.pdf>),
  and an excellent reference for <em|convex> optimization is the
  book<nbsp><cite|Boyd2004> by Boyd, available on GitHub. For the practical
  aspects, the MOSEK modeling cookbook<nbsp><cite|aps2020mosek> is excellent;
  we cite the Release 3.2.1 available on GitHub.

  Those books have been written at the turn of the century, but the theory
  has not changed much; machine learning has simply spurred interest in first
  order methods due to the size of the models.

  <section|Definitions>

  <subsection|Number of objectives>

  An optimization problem without an objective is a <em|satisfiability
  problem> or <em|feasibility problem>.

  <\small>
    When numerical errors are present, we can reformulate the feasibility
    problem

    <\equation>
      <tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<table|<row|<cell|Find>|<cell|<wide|x|\<vect\>>\<in\><with|font|Bbb*|R><rsup|n>>|<cell|>>|<row|<cell|<text|such
      that>>|<cell|x<rsub|i>\<in\><with|font|Bbb*|Z>>|<cell|i\<in\>\<cal-I\>\<subset\><around*|{|1,\<ldots\>,n|}>>>|<row|<cell|>|<cell|g<rsub|j><around*|(|<wide|x|\<vect\>>|)>\<leq\>0>|<cell|j=1,\<ldots\>,J>>|<row|<cell|>|<cell|h<rsub|k><around*|(|<wide|x|\<vect\>>|)>=0>|<cell|k=1,\<ldots\>,K>>>>>
    </equation>

    as the minimization problem

    <\equation>
      <tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<table|<row|<cell|<text|minimize>>|<cell|s>|<cell|>>|<row|<cell|over>|<cell|<wide|x|\<vect\>>\<in\><with|font|Bbb*|R><rsup|n>,s\<in\><with|font|Bbb*|R>>|<cell|>>|<row|<cell|<text|such
      that>>|<cell|x<rsub|i>\<in\><with|font|Bbb*|Z>>|<cell|i\<in\>\<cal-I\>\<subset\><around*|{|1,\<ldots\>,n|}>>>|<row|<cell|>|<cell|g<rsub|j><around*|(|<wide|x|\<vect\>>|)>\<leq\>s>|<cell|j=1,\<ldots\>,J>>|<row|<cell|>|<cell|-s\<leqslant\>h<rsub|k><around*|(|<wide|x|\<vect\>>|)>\<leqslant\>s=0>|<cell|k=1,\<ldots\>,K>>>>>
    </equation>

    so that there is always a feasible solution with <math|s> big enough.
    This is especially helpful for convex problems (more on that later). Then
    \Psolver returns infeasible\Q means that the problem formulation is not
    numerically stable; otherwise a solution with <math|s\<leqslant\>0> is
    feasible and <math|s\<gtr\>0> describes infeasibility.
  </small>

  The formulations we will consider later have a single objective. To change
  a minimization problem into a maximization problem and vice-versa, write
  <math|f<around*|(|<wide|x|\<vect\>>|)>\<rightarrow\>-f<around*|(|<wide|x|\<vect\>>|)>>
  as some solvers support only one optimization direction.

  When several objectives are present, we are speaking of multiobjective
  optimization.

  <\small>
    The simplest approach is to minimize a linear combination of objectives

    <\equation*>
      f<around*|(|<wide|x|\<vect\>>|)>=\<alpha\><rsub|1>f<rsub|1><around*|(|<wide|x|\<vect\>>|)>+\<alpha\><rsub|2>f<rsub|2><around*|(|<wide|x|\<vect\>>|)>+\<cdots\>
    </equation*>

    for various values of <math|\<alpha\><rsub|1>,\<alpha\><rsub|2>,\<ldots\>>;
    this is part of the <em|scalariztion> approaches. To organize the
    results, plot the <em|Pareto front>. We also had success with genetic
    algorithms which maintain good diversity in the population of solutions
    (for example NSGA-II<nbsp><cite|Deb2002>).
  </small>

  <subsection|Type of objective>

  The simplest type of objective function is <em|linear>:

  <\equation>
    <label|Eq:Affine>f<around*|(|<wide|x|\<vect\>>|)>=<wide|c|\<vect\>><rsup|\<top\>>\<cdot\><wide|x|\<vect\>>+d.
  </equation>

  \;

  (Strictly speaking, it is <em|affine> for <math|d\<neq\>0> although this
  subtle point is often lost. We use <em|linear> for both.)

  Otherwise, the problem is said to have <em|nonlinear> constraints.

  An objective function is <em|convex> when<nbsp><cite-detail|Boyd2004|Chap.
  2 and 3>

  <\equation>
    <label|Eq:Convex>f<around*|(|\<alpha\>*<wide|x|\<vect\>><rsub|1>+<around*|(|1-\<alpha\>|)><wide|x|\<vect\>><rsub|2>|)>\<leqslant\>\<alpha\>f<around*|(|<wide|x|\<vect\>><rsub|1>|)>+<around*|(|1-\<alpha\>|)>f<around*|(|<wide|x|\<vect\>><rsub|2>|)>,<space|2em>\<alpha\>\<in\><around*|[|0,1|]>.
  </equation>

  This implies that any local minimum of <math|f> is also a global
  minimum<nbsp><cite-detail|Boyd2004|4.2.2>.

  <em|Polynomial> objective functions have the form

  <\equation>
    <label|Eq:Poly>f<around*|(|<wide|x|\<vect\>>|)>=\<alpha\>+<big|sum><rsub|i<rsub|1>>\<beta\><rsub|i<rsub|1>>x<rsub|i<rsub|1>>+<big|sum><rsub|i<rsub|1>\<leqslant\>i<rsub|2>>\<gamma\><rsub|i<rsub|1>i<rsub|2>>x<rsub|i<rsub|1>>x<rsub|i<rsub|2>>+\<cdots\>
  </equation>

  Sometimes, objective functions are not known in closed form: it can be
  obtained from an integration, solving a differential equation, solving an
  inner optimization problem, even running an experiment. The computation of
  <math|f<around*|(|<wide|x|\<vect\>>|)>> may even be <em|noisy>. In those
  cases, the derivatives <math|\<partial\>f/\<partial\>x<rsub|i>>,
  <math|\<partial\><rsup|2>f/\<partial\>x<rsub|i>\<partial\>x<rsub|j>> may
  not be available, and cannot be computed by finite difference schemes: the
  solving algorithm needs to be <em|derivative-free><nbsp><cite-detail|Nocedal2000|Chap.
  9>.

  <subsection|Type of constraints>

  If <math|\<cal-I\>=\<cal-J\>=\<cal-K\>=\<emptyset\>>, the problem is an
  <em|unconstrainted> optimization problem.

  When <math|\<cal-I\>=\<cal-K\>=0> (no integrality or equality constraints),
  and all <math|g<rsub|j><around*|(|<wide|x|\<vect\>>|)>> have the form of
  simple bounds

  <\equation>
    \<ell\><rsub|i>\<leqslant\>x<rsub|i>\<leqslant\>u<rsub|i><space|2em>\<Rightarrow\><space|2em>\<ell\><rsub|i>-x<rsub|i>\<leqslant\>0,<space|1em>,x<rsub|i>-u<rsub|i>\<leqslant\>0,
  </equation>

  the problem is a <em|bounded> optimization problem.

  A problem has <em|linear constraints> when all <math|g<rsub|j>> and
  <math|h<rsub|k>> are linear<nbsp><eqref|Eq:Affine> and there are no
  integrality constraints (<math|\<cal-I\>=0>). Otherwise, the problem is
  said to have <em|nonlinear> constraints.

  A problem has <em|convex constraints> when all inequality constraints
  <math|g<rsub|j>> are convex<nbsp><eqref|Eq:Convex>, all equality
  constraints <math|h<rsub|k>> are linear<nbsp><eqref|Eq:Affine>.

  Constraints can also be polynomial as in<nbsp><eqref|Eq:Poly>.

  A <em|semidefinite programming> (SDP) constraint is constructed as follows.
  Given fixed symmetric matrices <math|C> and
  <math|<around*|{|A<rsub|i>|}><rsub|i>>, we write the affine combination
  <math|\<chi\>=C-<big|sum><rsub|i=1><rsup|n>A<rsub|i><rsub|>x<rsub|i>> using
  the optimization variables (the signs are somewhat arbitrary for now). We
  then impose that <math|\<chi\>> is a <em|semidefinite positive> matrix,
  i.e. that its eigenvalues <math|eig<around*|(|\<chi\>|)>> are all
  nonnegative<nbsp><cite-detail|Boyd2004|4.6.2>. Semidefinite constraints are
  quite expressive (two examples:<nbsp><cite|Parrilo2003><nbsp><cite|Fawzi2018>)
  and relatively efficient to compute.

  <subsection|Scale of problems>

  This relates to the number of variables and constraints, and will guide
  algorithm selection.

  Small problems include a handful of variables and constraints (say
  <math|1-10>). They can sometimes be solved by exact/algebraic methods.

  Medium-scale problems usually involve less than a thousand variables and
  constraints: for those, second-order derivative information (the Hessian)
  can be stored in memory using a dense matrix.

  Large-scale problems are such that second-order derivative information is
  too expensive to be stored in memory (in our experience, algorithms are
  more memory bound than CPU bound). Algorithms use the structure of the
  problem to reduce computational requirements: for example sparsity,
  approximating second-order information or even not using second-order
  information at all (at the price of convergence speed).

  <subsection|Problem types>

  <\wide-block>
    <tformat|<cwith|4|8|3|3|color|#a0a0a0>|<cwith|6|6|3|3|color|#a0a0a0>|<cwith|4|4|3|3|color|#a0a0a0>|<cwith|7|8|3|3|color|#a0a0a0>|<table|<row|<\cell>
      Objective type
    </cell>|<\cell>
      Constraint type
    </cell>|<\cell>
      Integrality
    </cell>|<\cell>
      Problem type
    </cell>>|<row|<\cell>
      Linear
    </cell>|<\cell>
      Linear
    </cell>|<\cell>
      <with|color|#a0a0a0|<math|\<cal-I\>=\<emptyset\>>>
    </cell>|<\cell>
      Linear program (LP)
    </cell>>|<row|<\cell>
      Linear
    </cell>|<\cell>
      Linear
    </cell>|<\cell>
      <math|\<cal-I\>\<neq\>\<emptyset\>>
    </cell>|<\cell>
      Mixed integer linear program (MILP)
    </cell>>|<row|<\cell>
      Linear
    </cell>|<\cell>
      Semidefinite
    </cell>|<\cell>
      <math|\<cal-I\>=\<emptyset\>>
    </cell>|<\cell>
      Semidefinite program (SDP)
    </cell>>|<row|<\cell>
      Convex
    </cell>|<\cell>
      Convex
    </cell>|<\cell>
      <math|\<cal-I\>=\<emptyset\>>
    </cell>|<\cell>
      Convex program
    </cell>>|<row|<\cell>
      Polynomial
    </cell>|<\cell>
      Polynomial
    </cell>|<\cell>
      <math|\<cal-I\>=\<emptyset\>>
    </cell>|<\cell>
      Polynomial optimization problem (POP)
    </cell>>|<row|<\cell>
      Nonlinear
    </cell>|<\cell>
      None
    </cell>|<\cell>
      <math|\<cal-I\>=\<emptyset\>>
    </cell>|<\cell>
      Unconstrained optimization problem
    </cell>>|<row|<\cell>
      Nonlinear
    </cell>|<\cell>
      Bounds
    </cell>|<\cell>
      <math|\<cal-I\>=\<emptyset\>>
    </cell>|<\cell>
      Bounded optimization problem
    </cell>>|<row|<\cell>
      Nonlinear
    </cell>|<\cell>
      Nonlinear
    </cell>|<\cell>
      <math|\<cal-I\>\<neq\>\<emptyset\>>
    </cell>|<\cell>
      Mixed integer nonlinear program (MINLP)
    </cell>>>>
  </wide-block>

  Note that LP, SDP are convex programs. Integrality constraints appear
  mostly in MILP, generic MINLP are an active area of research.

  <section|Approaches>

  <subsection|Problems specified by user-defined functions>

  In this approach, algorithms start with a user-given point
  <math|<wide|x|\<vect\>><rsub|0>>, gather information about the objective
  and constraints around <math|<wide|x|\<vect\>><rsub|0>>, compute a first
  iterate <math|<wide|x|\<vect\>><rsub|1>> that respects the constraints and
  such that <math|f<around*|(|<wide|x|\<vect\>><rsub|1>|)>\<less\>f<around*|(|<wide|x|\<vect\>><rsub|0>|)>>,
  repeat the procedure to obtain <math|<wide|x|\<vect\>><rsub|2>>,
  etc<text-dots>, until one of the stopping criteria of the algorithm is
  achieved (for example, the improvement <math|f<around*|(|<wide|x|\<vect\>><rsub|i+1>|)>-f<around*|(|<wide|x|\<vect\>><rsub|i>|)>>
  is small, the norm of the estimated gradient is below some tolerance, or
  the step size <math|<around*|\<\|\|\>|<wide|x|\<vect\>><rsub|i+1>-<wide|x|\<vect\>><rsub|i>|\<\|\|\>>>
  is too small).

  The main difference here is between convex and nonconvex programs. If the
  problem is not convex, there is no guarantee that the returned solution is
  globally optimal, or even feasible, while convex programs provide such
  certainty.

  (Several heuristics are available for nonconvex programs, but they are
  outside the scope of this survey).

  <subsubsection|Derivative-free algorithms>

  <\itemize-dot>
    <item><tabular|<tformat|<cwith|2|3|3|3|color|#a0a0a0>|<table|<row|<cell|Objective
    type>|<cell|Constraint type>|<cell|Integrality>|<cell|Problem
    type>>|<row|<\cell>
      Nonlinear
    </cell>|<\cell>
      None
    </cell>|<\cell>
      <math|\<cal-I\>=\<emptyset\>>
    </cell>|<\cell>
      Unconstrained optimization problem
    </cell>>|<row|<\cell>
      Nonlinear
    </cell>|<\cell>
      Bounds
    </cell>|<\cell>
      <math|\<cal-I\>=\<emptyset\>>
    </cell>|<\cell>
      Bounded optimization problem
    </cell>>>>>
  </itemize-dot>

  The algorithms below do not require gradient/Hessian information,
  see<nbsp><cite-detail|Nocedal2000|Chap. 9>.

  The Nelder-Mead or amoeba method is common for unconstrained problems:
  <verbatim|fminsearch> in Matlab standard toolbox; available in the
  <slink|https://github.com/JuliaNLSolvers/Optim.jl> Julia toolbox. It works
  on functions that are not differentiable, but can converge to non-optimal
  points. It is best used on problems with a number of variables between 10
  and 20.

  Model-based methods approximate the objective function by taking a number
  of samples and building a linear or quadratic model. We found the
  BOBYQA<nbsp><cite|Powell2009> algorithm for bounded optimization problems
  to work very efficiently, even in the presence of noise; algorithms in this
  family work up to several hundred variables. See
  <slink|https://github.com/stevengj/nlopt> for the MATLAB interface and
  <slink|https://github.com/JuliaOpt/NLopt.jl> for the Julia interface.

  <subsubsection|Derivative-based algorithms>

  There, the user supplies the objective and the constraints along with the
  gradients <math|\<nabla\>f>, <math|\<nabla\>g<rsub|j>>,
  <math|\<nabla\>h<rsub|k>> (some algorithms require second-order
  derivatives, but we do not recommend them outside of problems with specific
  structure).

  For unconstrained problems, the BFGS algorithm uses the values
  <math|f<around*|(|<wide|x|\<vect\>><rsub|i>|)>> and
  <math|<around*|(|\<nabla\>f|)><around*|(|<wide|x|\<vect\>><rsub|i>|)>> of
  the known iterates to approximate the second-order derivative information
  (Hessian). It is provided by the Optimization Toolbox in MATLAB through the
  <verbatim|quasi-newton> algorithm of the function <verbatim|fminunc>; in
  Julia, see the <slink|https://github.com/JuliaNLSolvers/Optim.jl> toolbox.
  In Julia, a limited memory version (LBFGS) is provided for large scale
  problems, where the Hessian matrix is approximated using the last <math|m>
  iterates, reducing memory use.

  For constrained problems, interior-point methods try to move in a central
  path at a certain distance of the constraints. In the MATLAB Optimization
  Toolbox, <verbatim|fmincon> has an implementation of the interior-point
  method; the <verbatim|Ipopt> solver has Julia bindings:
  <slink|https://github.com/JuliaOpt/Ipopt.jl>. MATLAB additionally has an
  sequential quadratic programming algorithm that can works more precisely
  for medium scale problems (instead of following a central path, it actively
  searches for inequality constraints that are be saturated).

  The Knitro nonlinear solver is state-of-the-art but academic licenses are
  not free.

  Final note: if the Julia code is written with generic types in mind, the
  gradients can be automatically computed by forward autodifferentiation.

  <subsection|Problems given in a canonical form>

  Some problem types have canonical forms. For example, linear programs (LP)
  have the (primal) form:

  <\equation>
    <label|Eq:LP><tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<table|<row|<cell|<text|minimize>>|<cell|<wide|c|\<vect\>><rsup|\<top\>><wide|x|\<vect\>>>>|<row|<cell|over>|<cell|<wide|x|\<vect\>>\<in\><with|font|Bbb*|R><rsup|n>>>|<row|<cell|<text|such
    that>>|<cell|A<wide|x|\<vect\>>=<wide|b|\<vect\>>>>|<row|<cell|>|<cell|<wide|x|\<vect\>>\<geqslant\>0>>>>>
  </equation>

  while semidefinite programs (SDP)<nbsp><cite-detail|Boyd2004|4.6.2> have
  the (primal) form:

  <\equation>
    <label|Eq:SDP><tabular|<tformat|<cwith|1|-1|1|1|cell-halign|r>|<table|<row|<cell|<text|minimize>>|<cell|Tr
    C X>>|<row|<cell|over>|<cell|X\<in\><with|font|Bbb*|R><rsup|n\<times\>n>,X=X<rsup|\<top\>>>>|<row|<cell|<text|such
    that>>|<cell|Tr A<rsub|k>X=b<rsub|k>,k\<in\>\<cal-K\>>>|<row|<cell|>|<cell|eig<around*|(|X|)>\<geqslant\>0>>>>>
  </equation>

  In that case, the problem is fully specified by the tuples
  <math|<around*|(|A,<wide|b|\<vect\>>,<wide|c|\<vect\>>|)>> or
  <math|<around*|(|<around*|{|A<rsub|k>|}>,<wide|b|\<vect\>>,C|)>>, and this
  data can be given to the solver using text files. Then the solver can run
  independently.

  For linear programs in exact precision, see also
  Section<nbsp><reference|Sec:Exact>.

  The solver Gurobi <slink|https://www.gurobi.com/> is excellent for linear
  and mixed-integer linear programming, though MOSEK is close (and MOSEK
  supports SDPs).

  For convex problems given in canonical forms, the MOSEK
  <slink|https://www.mosek.com/> solver represents the state of the art. It
  has a free academic license. For extended precision arithmetic, use the
  SDPA family <slink|http://sdpa.sourceforge.net/family.html>. We did not
  have great experiences with the SCS solver
  (<slink|https://github.com/cvxgrp/scs>), sometimes recommended in Julia
  examples, but it seems to have applications. Its code is particularly
  simple to follow though.

  All these solvers interface with Matlab and Julia; for Julia, see in
  particular <slink|https://github.com/JuliaOpt>.

  <subsection|Using a modeling framework>

  Writing a convex program in a canonical
  form<nbsp><eqref|Eq:LP>-<eqref|Eq:SDP> can be tedious. Luckily, both MATLAB
  and Julia have modeling frameworks that enable the use of standard syntax.
  Under the hood, the problems are transformed in the canonical form and
  solved. We describe below the different frameworks available. Some of them
  work even for nonconvex programs whose objective and constraints are given
  in a closed form.

  Still, modeling frameworks are not magical: they often result in canonical
  formulations that are more complex than necessary, with obvious
  redundancies (some frameworks, for example, do not substitute simple
  equality constraints such as <math|x<rsub|1>=x<rsub|2>>).

  <subsubsection|YALMIP (Matlab)>

  YALMIP is the one of the oldest framework in existence. It's based on
  MATLAB, though it runs on the open source clone Octave (
  <slink|https://www.gnu.org/software/octave/> ).

  The core of YALMIP is convex optimization over real-valued linear or
  semidefinite programs, and that core is stable, and interfaces with myriads
  of solvers.

  Beyond convex programming, YALMIP has support for nonconvex problems,
  complex variables, dualization, global optimization, polynomial
  optimization, <text-dots> but often it is not possible to use two
  extensions at the same time (for example, getting the dual variable
  corresponding to a complex SDP constraint). We observed that YALMIP
  performs the translation of the problem to its canonical form quite
  mechanically, without applying obvious eliminations.

  YALMIP has amazing documentation.

  <subsubsection|CVX (Matlab)>

  The CVX toolbox ( <slink|http://cvxr.com/cvx/> ) is restricted to convex
  programs, using an approach known as Disciplined Convex
  Programming<nbsp><cite|Grant2006>: the problem needs to be entered in a way
  that makes the convexity obvious to the toolbox (in practice, this is not a
  huge restriction). CVX encourages a modular style of convex programming:
  convex sets of importance can be defined in user functions and reused.

  The version 3 has critical bugs, but the version 2.2 is rock solid. It
  supports complex variables, including getting the dual variables of complex
  constraints. The documentation is great. CVX supports a limited number of
  solvers, compared to YALMIP, but it supports MOSEK, which is often all that
  is needed.

  CVX performs model translation better than YALMIP, and applies simple
  variable substitutions.

  <subsubsection|JuMP (Julia)>

  JuMP ( <slink|https://github.com/JuliaOpt/JuMP.jl> ) looks like the Julia
  equivalent of YALMIP. It interfaces myriads of solvers, offers nonconvex
  modeling and a quantity of extensions. It is actively used in research. It
  does not seem to be as versatile as YALMIP yet, and the documentation is
  sometimes lacking, in particular for its extensions. Of course YALMIP has
  nearly two decades of existence.

  <subsubsection|Convex.jl (Julia)>

  On the other hand, Convex.jl ( <slink|https://github.com/JuliaOpt/Convex.jl>
  ) is a Julia implementation of Disciplined Convex Programming, and has a
  limited scope compared to JuMP. In our limited experience, it seems more
  robust and ready to tackle medium or large scale optimization problems; it
  supports a large variety of solvers. Its documentation is pretty great.

  <subsection|Special cases>

  <subsubsection|Exact arithmetic><label|Sec:Exact>

  To solve linear programs, including those with multiple objectives, the
  feasible set can be manipulated using Fourier-Motzkin
  elimination<nbsp><cite|Williams1986>. We employed succesfully, for
  combinatorial problems.

  <\wide-block>
    <tformat|<table|<row|<\cell>
      Software
    </cell>|<\cell>
      Link
    </cell>|<\cell>
      Platform
    </cell>>|<row|<\cell>
      PORTA
    </cell>|<\cell>
      <slink|http://porta.zib.de/>
    </cell>|<\cell>
      Binary
    </cell>>|<row|<\cell>
      PANDA
    </cell>|<\cell>
      <slink|http://comopt.ifi.uni-heidelberg.de/software/PANDA/>
    </cell>|<\cell>
      Binary
    </cell>>>>
  </wide-block>

  Julia has bindings to many libraries: <slink|https://juliapolyhedra.github.io/>
  under a common interface, which we haven't tried.

  We also used rational LP solvers, which can be very efficient for medium
  scale problems:

  <\wide-block>
    <tformat|<table|<row|<\cell>
      Software
    </cell>|<\cell>
      Link
    </cell>|<\cell>
      Platform
    </cell>>|<row|<\cell>
      QSopt_ex
    </cell>|<\cell>
      <slink|https://www.math.uwaterloo.ca/~bico/qsopt/ex/index.html>
    </cell>|<\cell>
      Binary
    </cell>>|<row|<\cell>
      SoPlex
    </cell>|<\cell>
      <slink|https://soplex.zib.de/index.php>
    </cell>|<\cell>
      Binary
    </cell>>|<row|<\cell>
      GLPK (exact mode)
    </cell>|<\cell>
      <slink|https://www.gnu.org/software/glpk/>
    </cell>|<\cell>
      Julia, Matlab
    </cell>>>>
  </wide-block>

  \ 

  For polynomial problems, the elimination of quantifiers can be done using
  the Cylindrical Algebraic Decomposition<nbsp><cite|Caviness1998>,
  implemented in Mathematica.

  <subsubsection|Verified bounds>

  Semidefinite programs are often too expensive to be solved exactly, apart
  from small examples<nbsp><cite|Henrion2016>. Nevertheless certified bounds
  can be obtained using the VSDP package in Matlab<nbsp><cite|Jansson2006>.

  <subsubsection|Discrete/combinatorial optimization>

  When all variables are discrete and bounded, ideally all
  <math|x<rsub|i>\<in\><around*|{|0,1|}>>, consider using a SAT solver. We
  recommend MiniSat, <slink|http://minisat.se/>. Beyond that, the Z3 solver
  <slink|https://github.com/Z3Prover/z3>.

  <\bibliography|bib|tm-plain|../../../Documents/Bibliography/ZotOutput>
    <\bib-list|12>
      <bibitem*|1><label|bib-aps2020mosek>MOSEK ApS. <newblock>MOSEK modeling
      cookbook. <newblock>2020.<newblock>

      <bibitem*|2><label|bib-Boyd2004>Stephen Boyd<localize| and >Lieven
      Vandenberghe. <newblock><with|font-shape|italic|Convex Optimization>.
      <newblock>Cambridge University Press, Cambridge, UK ; New York,
      New.<localize| edition>, mar 2004.<newblock>

      <bibitem*|3><label|bib-Caviness1998>Bob<nbsp>F.<nbsp>Caviness<localize|
      and >Jeremy<nbsp>R.<nbsp>Johnson<localize|, editors>.
      <newblock><with|font-shape|italic|Quantifier Elimination and
      Cylindrical Algebraic Decomposition>. <newblock>Texts & Monographs in
      Symbolic Computation. Springer-Verlag, Wien, 1998.<newblock>

      <bibitem*|4><label|bib-Deb2002>K.<nbsp>Deb, A.<nbsp>Pratap,
      S.<nbsp>Agarwal<localize|, and >T.<nbsp>Meyarivan. <newblock>A fast and
      elitist multiobjective genetic algorithm: NSGA-II.
      <newblock><with|font-shape|italic|IEEE Transactions on Evolutionary
      Computation>, 6(2):182\U197, apr 2002. <newblock>Conference Name: IEEE
      Transactions on Evolutionary Computation.<newblock>

      <bibitem*|5><label|bib-Fawzi2018>Hamza Fawzi<localize| and >Omar Fawzi.
      <newblock>Efficient optimization of the quantum relative entropy.
      <newblock><with|font-shape|italic|J. Phys. A: Math. Theor.>,
      51(15):154003, mar 2018.<newblock>

      <bibitem*|6><label|bib-Grant2006>Michael Grant, Stephen Boyd<localize|,
      and >Yinyu Ye. <newblock>Disciplined Convex Programming.
      <newblock><localize|In >Leo Liberti<localize| and >Nelson
      Maculan<localize|, editors>, <with|font-shape|italic|Global
      Optimization>, <localize|number><nbsp>84<localize| in >Nonconvex
      Optimization and Its Applications, <localize|pages >155\U210. Springer
      US, 2006.<newblock>

      <bibitem*|7><label|bib-Henrion2016>Didier Henrion, Simone
      Naldi<localize|, and >Mohab<nbsp>Safey<nbsp>El Din. <newblock>SPECTRA-a
      Maple library for solving linear matrix inequalities in exact
      arithmetic. <newblock><with|font-shape|italic|ArXiv preprint
      arXiv:1611.01947>, 2016.<newblock>

      <bibitem*|8><label|bib-Jansson2006>Christian Jansson. <newblock>VSDP: A
      MATLAB software package for verified semidefinite programming.
      <newblock><with|font-shape|italic|DELTA>, 1:4, 2006.<newblock>

      <bibitem*|9><label|bib-Nocedal2000>Jorge Nocedal<localize| and >Stephen
      Wright. <newblock><with|font-shape|italic|Numerical Optimization>.
      <newblock>Springer, New York, 1st. ed. 1999. Corr. 2nd printing
      edition<localize| edition>, apr 2000.<newblock>

      <bibitem*|10><label|bib-Parrilo2003>Pablo<nbsp>A.<nbsp>Parrilo.
      <newblock>Semidefinite programming relaxations for semialgebraic
      problems. <newblock><with|font-shape|italic|Math. Program., Ser. B>,
      96(2):293\U320, may 2003.<newblock>

      <bibitem*|11><label|bib-Powell2009>Michael<nbsp>JD Powell.
      <newblock>The BOBYQA algorithm for bound constrained optimization
      without derivatives. <newblock><with|font-shape|italic|Cambridge NA
      Report NA2009/06, University of Cambridge, Cambridge>, <localize|pages
      >26\U46, 2009.<newblock>

      <bibitem*|12><label|bib-Williams1986>H.<nbsp>P.<nbsp>Williams.
      <newblock>Fourier's Method of Linear Programming and Its Dual.
      <newblock><with|font-shape|italic|The American Mathematical Monthly>,
      93(9):681\U695, nov 1986.<newblock>
    </bib-list>
  </bibliography>
</body>

<\initial>
  <\collection>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|Eq:Affine|<tuple|4|?>>
    <associate|Eq:Convex|<tuple|5|?>>
    <associate|Eq:LP|<tuple|8|?>>
    <associate|Eq:Poly|<tuple|6|?>>
    <associate|Eq:SDP|<tuple|9|?>>
    <associate|Sec:Exact|<tuple|3.4.1|?>>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-10|<tuple|3.1.1|?>>
    <associate|auto-11|<tuple|3.1.2|?>>
    <associate|auto-12|<tuple|3.2|?>>
    <associate|auto-13|<tuple|3.3|?>>
    <associate|auto-14|<tuple|3.3.1|?>>
    <associate|auto-15|<tuple|3.3.2|?>>
    <associate|auto-16|<tuple|3.3.3|?>>
    <associate|auto-17|<tuple|3.3.4|?>>
    <associate|auto-18|<tuple|3.4|?>>
    <associate|auto-19|<tuple|3.4.1|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-20|<tuple|3.4.2|?>>
    <associate|auto-21|<tuple|3.4.3|?>>
    <associate|auto-22|<tuple|3.4.3|?>>
    <associate|auto-3|<tuple|2.1|?>>
    <associate|auto-4|<tuple|2.2|?>>
    <associate|auto-5|<tuple|2.3|?>>
    <associate|auto-6|<tuple|2.4|?>>
    <associate|auto-7|<tuple|2.5|?>>
    <associate|auto-8|<tuple|3|?>>
    <associate|auto-9|<tuple|3.1|?>>
    <associate|bib-Boyd2004|<tuple|2|?>>
    <associate|bib-Caviness1998|<tuple|3|?>>
    <associate|bib-Deb2002|<tuple|4|?>>
    <associate|bib-Fawzi2018|<tuple|5|?>>
    <associate|bib-Grant2006|<tuple|6|?>>
    <associate|bib-Henrion2016|<tuple|7|?>>
    <associate|bib-Jansson2006|<tuple|8|?>>
    <associate|bib-Nocedal2000|<tuple|9|?>>
    <associate|bib-Parrilo2003|<tuple|10|?>>
    <associate|bib-Powell2009|<tuple|11|?>>
    <associate|bib-Williams1986|<tuple|12|?>>
    <associate|bib-aps2020mosek|<tuple|1|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      Nocedal2000

      Boyd2004

      aps2020mosek

      Deb2002

      Boyd2004

      Boyd2004

      Nocedal2000

      Boyd2004

      Parrilo2003

      Fawzi2018

      Nocedal2000

      Powell2009

      Boyd2004

      Grant2006

      Williams1986

      Caviness1998

      Henrion2016

      Jansson2006
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Reference
      material> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Definitions>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <with|par-left|<quote|1tab>|2.1<space|2spc>Number of objectives
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1tab>|2.2<space|2spc>Type of objective
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|2.3<space|2spc>Type of constraints
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|2.4<space|2spc>Scale of problems
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1tab>|2.5<space|2spc>Problem types
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Approaches>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8><vspace|0.5fn>

      <with|par-left|<quote|1tab>|3.1<space|2spc>Problems specified by
      user-defined functions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|2tab>|3.1.1<space|2spc>Derivative-free algorithms
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|2tab>|3.1.2<space|2spc>Derivative-based
      algorithms <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1tab>|3.2<space|2spc>Problems given in a
      canonical form <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|3.3<space|2spc>Using a modeling framework
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|2tab>|3.3.1<space|2spc>YALMIP (Matlab)
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|2tab>|3.3.2<space|2spc>CVX (Matlab)
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|2tab>|3.3.3<space|2spc>JuMP (Julia)
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|2tab>|3.3.4<space|2spc>Convex.jl (Julia)
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|1tab>|3.4<space|2spc>Special cases
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|2tab>|3.4.1<space|2spc>Exact arithmetic
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|2tab>|3.4.2<space|2spc>Verified bounds
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|2tab>|3.4.3<space|2spc>Discrete/combinatorial
      optimization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Bibliography>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>