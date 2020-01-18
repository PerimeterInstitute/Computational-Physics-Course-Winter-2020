module Particles

export Particle
struct Particle{T}
    posx::T
    posy::T
    mass::T
end

export pmerge
function pmerge(p::Particle{T}, q::Particle{T}) where {T<:Number}
    M = p.mass + q.mass
    Particle((p.mass * p.posx + q.mass * q.posx) / M,
             (p.mass * p.posy + q.mass * q.posy) / M,
	     M)
end

end # module
