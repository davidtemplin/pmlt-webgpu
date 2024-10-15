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

    // Compute 2^i
    let two_pow_i: u32 = u32(1) << uniforms.iteration;
    let m: u32 = u32(global_invocation_index >= two_pow_i);

    // Determine which CDF arrays will serve as primary and auxiliary this iteration
    let read_index = uniforms.iteration % 2;
    let write_index = (read_index + 1) % 2;

    // Compute the translated index
    let j = chain.min_path_index[uniforms.chain_id] + global_invocation_index;
    
    // Update prefix sums
    path.cdf[write_index][j] = path.cdf[read_index][j] + f32(m) * path.cdf[read_index][j - m * two_pow_i];

    // Ensure that the primary array contains the final result
    if uniforms.iteration == uniforms.final_iteration && write_index != PRIMARY {
        path.cdf[PRIMARY][j] = path.cdf[AUXILIARY][j];
    }
}