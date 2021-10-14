using Revise

include("./src/bimax.jl")
using Main.BiMax

function main()
    M = [
        1 1 1 1 1 0 0 0 0 0 0 0;
        1 1 0 1 0 0 0 0 0 0 0 0;
        1 0 1 0 0 0 0 1 0 0 1 0;
        0 0 0 0 1 0 1 0 1 0 1 1;
        1 0 0 1 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 1 1 0 1 0 0;
        0 0 0 0 0 0 1 0 0 1 1 0;
        0 1 1 1 0 0 0 0 0 0 0 0;
        0 0 0 0 0 1 0 0 0 0 0 0;
        0 1 0 0 0 0 0 0 1 1 0 0;
        0 1 0 0 1 0 0 0 0 0 0 0;
        1 1 0 1 1 0 0 0 0 0 0 0;
    ]

    res = bimax(M)
    for bc in res
        println(bc)
    end

end

main()