% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Producer.R
\name{Producer}
\alias{Producer}
\title{Producer reference class}
\description{
Wrapper for RdKafka::Producer
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Producer-new}{\code{Producer$new()}}
\item \href{#method-Producer-produce}{\code{Producer$produce()}}
\item \href{#method-Producer-flush}{\code{Producer$flush()}}
\item \href{#method-Producer-clone}{\code{Producer$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Producer-new"></a>}}
\if{latex}{\out{\hypertarget{method-Producer-new}{}}}
\subsection{Method \code{new()}}{
Create a new consumer instance
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Producer$new(config)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{config}}{(`list()`)\cr
list of config values. These are passed without modification to
librdkafka}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Producer-produce"></a>}}
\if{latex}{\out{\hypertarget{method-Producer-produce}{}}}
\subsection{Method \code{produce()}}{
Produce message
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Producer$produce(topic, value, key = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{topic}}{(`character`)\cr
kafka topic}

\item{\code{value}}{(`character`)\cr
value of message}

\item{\code{key}}{(`character`)\cr
key of message (optional)}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Producer-flush"></a>}}
\if{latex}{\out{\hypertarget{method-Producer-flush}{}}}
\subsection{Method \code{flush()}}{
Flush producer, i.e. send all messages currently in the
queue
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Producer$flush(timeout = 1000)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{timeout}}{(`integer`)\cr
timeout in ms.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Producer-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Producer-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Producer$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}