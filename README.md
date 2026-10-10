# Godot Water Shader

A water shader for Godot 4. It makes a pool of water that looks good and reacts to things in the scene.

![Screenshot](screenshots/water.png)

## What it does now

- [x] Water color changes with depth (shallow = light, deep = dark)
- [x] Soft edge where water touches walls and objects
- [x] Small ripples using two moving normal maps
- [x] See-through water (you can see the floor and objects inside)
- [x] Different look when the camera is under the water

## What I am adding

- [ ] **Gerstner waves** - bigger, more natural waves
- [ ] **Foam** - white foam on the edges and wave tops
- [ ] **Caustics** - the moving light patterns on the pool floor
- [ ] **Ripples when things touch the water** - a walking character leaves a trail
- [ ] **Buoyancy** - objects float on the water

## How to use

1. Make a `MeshInstance3D` with a plane mesh. Give it enough subdivisions.
2. Make a new `ShaderMaterial` and load `water.gdshader`.
3. Set the textures:
   - `texture_normal` and `texture_normal1` - two water normal maps
   - `wave_noise` - a noise texture (turn on Repeat)
4. Set the colors: `shallow_color`, `deep_color`, `edge_color`.
5. Play with the sliders until it looks right.

## Main settings

| Setting | What it does |
|---|---|
| `beers_cofficient` | How fast water gets dark with depth |
| `depth_offset` | Moves the depth color up or down |
| `edge_scale` | How thick the edge line is |
| `edge_softness` | How soft the edge fade is |
| `roughness` | Lower = shinier water |
| `height_scale` | How tall the waves are |
| `under_density` | How fast the color gets dark when you go under water |

## How the new features will work

- **Gerstner waves:** a few waves added together in `vertex()`. Each moves the point up and sideways, so the tops look sharp.
- **Foam:** uses the water thickness near edges, mixed with a noise texture.
- **Caustics:** a moving light pattern drawn on the floor shader, only below the water level.
- **Ripples:** an `Area3D` finds objects in the water. A small simulation in a `SubViewport` spreads the ripples, and the water shader reads the result.
- **Buoyancy:** the same `Area3D` pushes `RigidBody3D` objects up when they are below the water level.

## Needs

- Godot 4 (Forward+ or Mobile renderer)
- If you use the Compatibility renderer, the depth code needs a small change

## Known problems

- No real reflections yet (planned: ReflectionProbe or planar reflection)
- Objects under the water are not tinted when the camera is under the water
- Floating objects use a flat water level, so they ignore wave height

## License

MIT (change this if you want)
