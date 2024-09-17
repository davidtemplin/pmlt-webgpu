@group(UNIFORMS_GROUP) @binding(UNIFORMS_BINDING) var<uniform> uniforms: BuildCdfUniforms;

@compute
@workgroup_size(WORKGROUP_SIZE)
fn build_cdf(@builtin(global_invocation_id) id: vec3u) {
    let global_invocation_index = id.x;
    if global_invocation_index >= uniforms.path_count {
        return;
    }
    let i = uniforms.iteration;
    let two_pow_i: u32 = u32(1) << i;
    let m = u32(global_invocation_index >= two_pow_i);
    let j = uniforms.min_path_index + global_invocation_index;
    path_state.scalar_contribution[j] = path_state.scalar_contribution[j] + f32(m) * path_state.scalar_contribution[j - m * two_pow_i];
}