% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/locations.R
\name{Location}
\alias{Location}
\title{Create Location}
\usage{
Location(
  name = NULL,
  abbreviation = NULL,
  country_code = NULL,
  country_name = NULL,
  program = NULL,
  type = NULL,
  latitude = NULL,
  longitude = NULL,
  altitude = NULL,
  noaa_station_id = NULL
)
}
\arguments{
\item{name}{Unique location name (must not conflict with an existing location name)}

\item{abbreviation}{Location abbreviation}

\item{country_code}{ISO Alpha-3 country code}

\item{country_name}{Uppercase english short name from the ISO standard}

\item{program}{Name of one or more existing Breeding Programs}

\item{type}{Location type (Farm, Field, Greenhouse, Screenhouse, Lab, Storage, Other)}

\item{latitude}{(optional) Location latitude (decimal degrees)}

\item{longitude}{(optional) Location longitude (decimal degrees)}

\item{altitude}{(optional) Location elevation (meters)}

\item{noaa_station_id}{(optional) NOAA Station ID (ex: GHCND:US1NYTM0042)}
}
\value{
Location
}
\description{
Create a Location containing all of the provided properties. 
Latitude, Longitude, and Altitude are optional and if not provided 
will be queried from the DataScienceToolkit API using the Location name.
}
\details{
The \code{\link{geocodeLocation}} function can be used to obtain lat/lon/alt 
properties from a more specific location name (such as a street address), the 
results of which can be used to create the Location.

The \code{\link{lookupNOAAStationId}} function can be used to obtain the NOAA
Station ID of the location (using its lat and lon) if it is unknown.

Use the \code{\link{getCountryCodes}} function to get a list of supported country 
codes and the \code{\link{getLocationTypes}} function to get a list of supported 
location types.
}
\examples{
# Use the Location name to query lat/lon/alt properties
location <- Location(
     "Batavia, NY",
     "BAT",
     "USA",
     "United States of America",
     "Cornell",
     "Field"
)

# Geocode an address to use as lat/lon/alt properties
geo <- geocodeLocation("2 Caldwell Drive, Ithaca, NY")
noaa_station_id <- lookupNOAAStationId(geo$latitude, geo$longitude)
location <- Location(
     "Caldwell - Ithaca, NY", 
     "ITH_CALD",
     "USA",
     "United States of America",
     "Cornell",
     "Field",
     geo$latitude,
     geo$longitude,
     geo$altitude,
     noaa_station_id
)

}
\seealso{
Other Location: 
\code{\link{Location-class}},
\code{\link{buildLocationTemplate}()},
\code{\link{geocodeLocation}()},
\code{\link{getCountryCodes}()},
\code{\link{getLocationTypes}()},
\code{\link{lookupNOAAStationID}()},
\code{\link{writeLocationTemplate}()}
}
\concept{Location}
