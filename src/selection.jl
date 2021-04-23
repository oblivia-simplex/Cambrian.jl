
# There should be support for a parallel sort, here, I think.


"return a winner individual from a tournament of size t_size from a population"
function tournament_selection(pop::Array{<:Individual}, t_size::Int)
    inds = shuffle!(collect(1:length(pop)))
    sort(pop[inds[1:t_size]])[end]
end

function tournament_selection(geo::Geography, t_size::Int)
    inds = choose_combatants(geo, t_size)
    sort(geo.deme[inds])[end]
end

"return the best individual from a population"
function max_selection(pop::Array{<:Individual})
    sort(pop)[end]
end

function max_selection(geo::Geography)
    max_selection(geo.deme)
end

"return a random individual from a population"
function random_selection(pop::Array{<:Individual})
    pop[rand(1:length(pop))]
end

function random_selection(geo::Geography)
    rand(geo.deme)
end

## Why is t_size hardcoded here?
selection(pop::Array{<:Individual}) = tournament_selection(pop, 4)

selection(geo::Geography) = tournament_selection(geo, 4)
