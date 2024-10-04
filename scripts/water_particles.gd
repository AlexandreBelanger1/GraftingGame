extends GPUParticles2D

func water(enable:bool):
	emitting = enable

func setLifetime(time:float):
	lifetime = time

func getLifetime():
	return lifetime
