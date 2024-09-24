@group(UNIFORMS_GROUP) @binding(UNIFORMS_BINDING) var<uniform> uniforms: BuildCdfUniforms;

@compute
@workgroup_size(WORKGROUP_SIZE)
fn build_cdf(@builtin(global_invocation_id) id: vec3u) {
    // Determine the global invocation index
    let global_invocation_index = id.x;

    // Compute parameters
    let chain_id = uniforms.chain_id;
    let min_path_index = chain.min_path_index[chain_id];
    let path_count = chain.path_count[chain_id];

    // Check bounds
    if global_invocation_index >= path_count {
        return;
    }

    // Compute index parameters
    let i = uniforms.iteration;
    let two_pow_i: u32 = u32(1) << i;
    let m = u32(global_invocation_index >= two_pow_i);
    let j = min_path_index + global_invocation_index;
    
    // Update prefix sums
    path.cdf[j] = path.cdf[j] + f32(m) * path.cdf[j - m * two_pow_i];
}