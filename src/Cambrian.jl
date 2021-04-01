module Cambrian

using Random
using Logging
using Statistics
using YAML
using JSON
import Formatting
import Dates

include("config.jl")
include("logger.jl")
include("individual.jl")
include("evolution.jl")
include("selection.jl")
include("evaluation.jl")
include("step.jl")
include("oneplus.jl")
include("GA.jl")

##
# Giving these methods bang names, since they are expected to mutate the
# AbstractEvolution instance.
##

@deprecate populate(e) populate!(e) true
@deprecate evaluate(e) evaluate!(e) true
@deprecate generation(e) generation!(e) true

end
