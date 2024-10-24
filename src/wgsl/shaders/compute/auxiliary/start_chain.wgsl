@group(UNIFORM_GROUP) @binding(UNIFORM_BINDING) var<uniform> uniforms: StartChainUniforms;

@compute
@workgroup_size(1)
fn start_chain() {
    let sum = path.cdf[PRIMARY][PATH_COUNT - 1];
    let m = binary_search(0, PATH_COUNT - 1, sum, uniforms.random);
    populate_random_numbers(uniforms.chain_id, m);
    chain.b[uniforms.chain_id] = sum / f32(PATH_COUNT);
    let contribution = get_path_contribution(m);
    chain.scalar_contribution[uniforms.chain_id] = luminance(contribution);
    set_chain_contribution(uniforms.chain_id, contribution);
    set_chain_pixel(uniforms.chain_id, get_pixel(m));
}