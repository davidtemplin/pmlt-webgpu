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

    // Compute index parameters
    let two_pow_i: u32 = u32(1) << uniforms.iteration;
    let m = u32(global_invocation_index >= two_pow_i);
    let j = chain.min_path_index[uniforms.chain_id] + global_invocation_index;
    
    // Update prefix sums
    path.cdf[j] = path.cdf[j] + f32(m) * path.cdf[j - m * two_pow_i];
}