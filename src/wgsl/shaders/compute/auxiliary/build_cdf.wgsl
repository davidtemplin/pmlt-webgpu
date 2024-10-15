@group(UNIFORM_GROUP) @binding(UNIFORM_BINDING) var<uniform> uniforms: BuildCdfUniforms;

@compute
@workgroup_size(WORKGROUP_SIZE)
fn build_cdf(@builtin(global_invocation_id) id: vec3u) {
    // Determine the global invocation index
    let global_invocation_index = id.x;

    // Check bounds
    if global_invocation_index >= chain.path_count[uniforms.chain_id] {
        return;
    }

    // Compute p = 2^i, and an indicator, m
    let p: u32 = u32(1) << uniforms.iteration;
    let m: u32 = u32(global_invocation_index >= p);

    // Determine which CDF array will be read (r) and written (w)
    let r = uniforms.iteration % 2;
    let w = choose_u32(uniforms.iteration == uniforms.final_iteration, PRIMARY, (r + 1) % 2);

    // Compute the translated index
    let j = chain.min_path_index[uniforms.chain_id] + global_invocation_index;
    
    // Update prefix sums
    path.cdf[w][j] = path.cdf[r][j] + f32(m) * path.cdf[r][j - m * p];
}