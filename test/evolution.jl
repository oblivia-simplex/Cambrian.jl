using Cambrian
import YAML

cfg = get_config("test.yaml")

@testset "Random fitness" begin
    e = Evolution{FloatIndividual}(cfg)
    @show e
    evaluate!(e::Evolution) = random_evaluate!(e)
    populate!(e::Evolution) = oneplus_populate!(e)
    @test length(e.population) == prod(cfg.population.size)
    for i in e.population
        @test all(i.fitness .== -Inf)
    end

    evaluate!(e)
    fits = [i.fitness[1] for i in e.population]
    @show fits
    evaluate!(e)
    # random fitness, all values should change
    for i in eachindex(e.population)
        @show i
        @test fits[i] != e.population[i].fitness[1]
    end

    fits = copy([i.fitness[:] for i in e.population])
    step!(e)
    # random fitness, all values should change
    for i in eachindex(e.population)
        @test fits[i] != e.population[i].fitness[1]
    end
end
