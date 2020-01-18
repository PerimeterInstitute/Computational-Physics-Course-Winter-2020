using Test
using Particles

p = Particle(0//1, 0//1, 1//1)
q = Particle(1//1, 1//1, 2//1)

r = pmerge(p, q)
@test r == Particle(2//3, 2//3, 3//1)



# Property test for 100 random particle pairs
randrational() = rand(1:1000000) // 1000000
for n in 1:100
    p1 = Particle(randrational(), randrational(), randrational())
    p2 = Particle(randrational(), randrational(), randrational())
    p3 = pmerge(p1, p2)
    # test CoM
    @test p1.mass * p1.posx + p2.mass * p2.posx == p3.mass * p3.posx
    @test p1.mass * p1.posy + p2.mass * p2.posy == p3.mass * p3.posy
    # test total mass
    @test p1.mass + p2.mass == p3.mass
end
