using Makie
import LinearAlgebra: norm

mutable struct Body	
	mass::Float64
	pos::Vector{Float64}
	vel::Vector{Float64}
	force::Vector{Float64}

end

function Force(body1, body2)
	G = 10.5
	
	
	n = norm(body1.pos - body2.pos )
	
	if n < 10
		return 0.0
	end
	
	G *	body1.mass * body2.mass / (n)^3

end

function update_status!(bodies)
	for i = 1:length(bodies)-1
		for j = i+1:length(bodies)
			k = Force(bodies[i], bodies[j])
			
			if k == 0.0
				continue
			end
			
			r = k * (bodies[i].pos - bodies[j].pos)
			bodies[i].force -= r 
			bodies[j].force += r	
		end
	end


	for body in bodies
		body.vel += body.force / body.mass
		body.pos += body.vel
		
		if sum(body.pos .<= -1000 ) + sum(body.pos .>= 1000) > 0
			body.vel *= -0.9
		end

		body.force *= 0
	end
	#@show bodies[1].pos

end


function get_bodies(n)
	bodies = Body[]
	for i = 1:n
			push!(bodies, Body( 5 + 20abs(randn()), -1000 .+ 2000rand(2), zeros(2), zeros(2)  ))
	end

	bodies[1].mass = 200

	bodies
end


function main()
	bodies = get_bodies(100)
	display(bodies)

	scene = Scene()

	t = Node(0.0)
	
	pos = lift(t) do t
		
		#println("asdafad: ", t)
			
		update_status!(bodies)
		
		x = map(b -> b.pos[1], bodies)
		y = map(b -> b.pos[2], bodies)

		[x y]
	end

	
	##display(Array(pos)[1])
	#return pos
	s = scatter!(scene, pos, color=rand(10), markersize=map(b -> b.mass, bodies))
	
	
	display(scene)
	i = 1
	while true
		
			
		t[] = i	

		# display(x)

	
		sleep(1/25)
	end	



end

main()










