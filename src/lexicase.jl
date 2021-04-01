export lexicase_evaluate!

function mse_valid(h::AbstractArray, y::AbstractArray; margin::Float64=0.1)
    sum((h - y).^2) < margin
end

function classify_valid(h::AbstractArray, y::AbstractArray)
    argmax(h) == argmax(y)
end

"""
lexicase selection for data-based GP problems where each genome G in
e.population corresponds to a data-processing function F, where F =
interpret(G). X and Y are 2D arrays, and individuals are evaluated based on
valid(F(X[:, i]), Y[:, i]), where the valid function determines if individuals
should continue to be evaluated.
"""
function lexicase_evaluate!(e::AbstractEvolution, X::AbstractArray, Y::AbstractArray,
                            interpret::Function; valid::Function=classify_valid,
                            verify_best::Bool=true, seed::Int=e.gen)
    Random.seed!(seed)
    npop = length(e.population)
    ndata = size(Y, 2)
    functions = Array{Function}(undef, npop)
    for i in 1:npop
        functions[i] = interpret(e.population[i])
    end
    data_inds = shuffle!(collect(1:ndata))
    is_valid = trues(npop)
    fits = zeros(npop)
    # if verify_best
    #     fits = [e.population[i].fitness[1] for i in 1:npop]
    #     is_valid = fits .== -Inf # do not re-evaluate expert
    # end
    for i in 1:ndata
        x = X[:, data_inds[i]]
        y = Y[:, data_inds[i]]
        for j in 1:npop
            if is_valid[j]
                h = functions[j](x)
                if valid(h, y)
                    fits[j] = i
                else
                    is_valid[j] = false
                end
            end
        end
        if sum(is_valid) <= 1
            break
        end
    end
    for i in 1:npop
        e.population[i].fitness[1] = fits[i]
    end
end

#     if verify_best
#         best = argmax(fits)
#         if e.population[best] == -Inf
#             # new best individual, re-evaluate
#             fits[best] = 0.0
#             for i in 1:ndata
#                 for j in 1:npop
#                     if valid(functions[j](X[:, i]), Y[:, i])
#                         fits[best] += 1.0
#                     end
#                 end
#             end
#         end
#     end
# end
