@group(UNIFORM_GROUP) @binding(UNIFORM_BINDING) var<uniform> uniforms: StartChainUniforms;

@compute
@workgroup_size(1)
fn start_chain() {
    let sum = path.cdf[PATH_COUNT - 1];
    let m = binary_search(0, PATH_COUNT - 1, sum, uniforms.random);
    let large_step_index = m * numbers_per_path;
    chain.large_step_index[HI][uniforms.chain_id] = 0;
    chain.large_step_index[LO][uniforms.chain_id] = large_step_index;
    chain.small_step_count[uniforms.chain_id] = 1;
    chain.b[uniforms.chain_id] = sum;
    chain.iteration[uniforms.chain_id] += 1;
}