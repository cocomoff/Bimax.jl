module BiMax

export bimax,
       BiCluster

struct BiCluster{T}
    rows::Vector{T}
    cols::Vector{T}
end

function bimax(m::Matrix{Int})
    z = Vector{Int}[]
    rows = 1:size(m, 1)
    cols = 1:size(m, 2)
    conquer(m, rows, cols, z)
end

function conquer(m::Matrix{Int},
                 rows::AbstractArray{Int, 1},
                 cols::AbstractArray{Int, 1},
                 z::Vector{Vector{Int}})

    # 全部が1のとき，分割統治は必要ない
    _allones(m, rows, cols) && (return [BiCluster(rows, cols)])

    cones, czeros, rones, rmixed, rzeros = divide(m, rows, cols, z)

    mones = Int[]
    mzeros = Int[]
    if !isempty(rones)
        mones = conquer(m, vcat(rones, rmixed), cones, z)
    end
    if !isempty(rzeros) && isempty(rmixed)
        mzeros = conquer(m, rzeros, czeros, z)
    elseif !isempty(rmixed)
        znew = vcat(z, Vector{Int}[czeros])
        mzeros = conquer(m, vcat(rmixed, rzeros), vcat(cones, czeros), znew)
    end
    vcat(mones, mzeros)
end

function divide(m::Matrix{Int},
                rows::AbstractArray{Int, 1},
                cols::AbstractArray{Int, 1},
                z::Vector{Vector{Int}})
    onecolumns(i) = filter(j -> m[i, j] == 1, cols)

    is = reduce(m, rows, cols, z)
    i = candidate(m, is, cols)
    cones = (i === nothing) ? cols : onecolumns(i)
    czeros = setdiff(cols, cones)
    rones = Int[]
    rmixed = Int[]
    rzeros = Int[]
    for i in is
        cones1 = onecolumns(i)
        if issubset(cones1, cones)
            push!(rones, i)
        elseif issubset(cones1, czeros)
            push!(rzeros, i)
        else
            push!(rmixed, i)
        end
    end
    cones, czeros, rones, rmixed, rzeros
end

function reduce(m::Matrix{Int},
                rows::AbstractArray{Int, 1},
                cols::AbstractArray{Int, 1},
                z::Vector{Vector{Int}})
    rones = Int[]
    for i in rows
        cones = filter(j -> m[i, j] == 1, cols)
        if isempty(cones) || any(zs -> isempty(intersect(cones, zs)), z)
            continue
        end
        push!(rones, i)
    end
    rones
end

function candidate(m::Matrix{Int},
                   rows::AbstractArray{Int, 1},
                   cols::AbstractArray{Int, 1})
    for i in rows
        if 0 < sum(map(j -> m[i, j], cols)) < length(cols)
            return i
        end
    end
    return nothing
end


function _allones(m::Matrix{Int},
                  rows::AbstractArray{Int, 1},
                  cols::AbstractArray{Int, 1})
    for i in rows, j in cols
        (m[i, j] == 0) && (return false)
    end
    true
end

end