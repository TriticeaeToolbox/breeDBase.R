% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/accessionSearch.R
\name{getAccessionSearchDB}
\alias{getAccessionSearchDB}
\title{Get Accession Search Database}
\usage{
getAccessionSearchDB(name)
}
\arguments{
\item{name}{The name of the database}
}
\value{
Accession Search Database, a list with the following names:
\describe{
  \item{name}{Database name}
  \item{address}{Database BrAPI URL}
  \item{version}{Database BrAPI version}
  \item{call_limit}{Max number of concurrent connections to the Databse}
}
}
\description{
Get the Accession Search Database by the name of the BrAPI-compliant 
database configured by the accession search server.
}
\details{
The name must match the name of a database supported by the accession 
search server.  Use the \code{\link{getAccessionSearchDBs}} function 
to get a list of all of the supported databases.
}
\seealso{
\link{getAccessionSearchDBs}

Other accessionSearch: 
\code{\link{createAccessionSearchDB}()},
\code{\link{getAccessionSearchCacheStatus}()},
\code{\link{getAccessionSearchConfig}()},
\code{\link{getAccessionSearchDBs}()},
\code{\link{getAccessionSearchServer}()},
\code{\link{performAccessionSearch}()},
\code{\link{updateAccessionSearchCache}()}
}
\concept{accessionSearch}
