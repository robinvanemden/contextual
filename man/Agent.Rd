% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/agent.R
\name{Agent}
\alias{Agent}
\alias{do_step}
\alias{get_t}
\alias{set_t}
\alias{agent}
\title{Agent}
\description{
Keeps track of one \code{\link{Bandit}} and \code{\link{Policy}} pair.
}
\details{
Controls the running of one \code{\link{Bandit}} and \code{\link{Policy}}
pair over \emph{t} = {1, \ldots, T} looping over, consecutively,
\code{bandit$get_context(), policy$get_action(), bandit$get_reward()} and \code{policy$set_reward()}
for each time step \code{t}.
}
\section{Schematic}{


\figure{2agent.jpeg}{contextual diagram: simulator}
}

\section{Usage}{

\preformatted{
agent <- Agent$new(policy, bandit, name=NULL, sparse = 0.0)
}
}

\section{Arguments}{


\describe{

\item{\code{policy}}{
\code{\link{Policy}} instance.
}
\item{\code{bandit}}{
\code{\link{Bandit}} instance.
}
\item{\code{name}}{
character; sets the name of the \code{Agent}. If \code{NULL} (default), \code{Agent} generates a name
based on its \code{\link{Policy}} instance's name.
}
\item{\code{sparse}}{
numeric; artificially reduces the data size by setting a sparsity level for the current
\code{\link{Bandit}} and \code{\link{Policy}} pair.
When set to a value between \code{0.0} (default) and \code{1.0} only a fraction \code{sparse} of
the \code{\link{Bandit}}'s data is randomly chosen to be available to improve the \code{Agent}'s
\code{\link{Policy}} through \code{policy$set_reward}.
}

}
}

\section{Methods}{


\describe{

\item{\code{new()}}{ generates and instantializes a new \code{Agent} instance. }

\item{\code{do_step()}}{
advances a simulation by one time step by consecutively calling \code{bandit$get_context()},
\code{policy$get_action()}, \code{bandit$get_reward()} and \code{policy$set_reward()}.
Returns a list of lists containing \code{context}, \code{action}, \code{reward} and \code{theta}.
}

\item{\code{set_t(t)}}{
integer; sets the current time step to \code{t}.
}

\item{\code{get_t()}}{
returns current time step \code{t}.
}

}
}

\examples{
\dontrun{

  policy    <- EpsilonGreedyPolicy$new(epsilon = 0.1)
  bandit    <- BasicBernoulliBandit$new(weights = c(0.6, 0.1, 0.1))

  agent     <- Agent$new(policy, bandit, name = "E.G.", sparse = 0.5)

  history   <- Simulator$new(agents = agent,
                             horizon = 10,
                             simulations = 10)$run()
}
}
\seealso{
Core contextual classes: \code{\link{Bandit}}, \code{\link{Policy}}, \code{\link{Simulator}},
\code{\link{Agent}}, \code{\link{History}}, \code{\link{Plot}}

Bandit subclass examples: \code{\link{BasicBernoulliBandit}}, \code{\link{ContextualLogitBandit}},
\code{\link{OfflineReplayEvaluatorBandit}}

Policy subclass examples: \code{\link{EpsilonGreedyPolicy}}, \code{\link{ContextualLinTSPolicy}}
}
