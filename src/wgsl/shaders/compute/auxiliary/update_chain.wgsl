@group(UNIFORM_GROUP) @binding(UNIFORM_BINDING) var<uniform> uniforms: UpdateChainUniforms;

@compute
@workgroup_size(1)
fn update_chain() {
    // Add the current contribution
    let c = get_chain_contribution(uniforms.chain_id);
    let max_path_index = chain.max_path_index[uniforms.chain_id];
    let a = 1.0 - path.cdf[PRIMARY][max_path_index];
    let weight = get_contribution_weight(uniforms.chain_id, a, CURRENT, NO_STEP);
    let pixel = get_chain_pixel(uniforms.chain_id);
    contribute(c * weight, pixel.x, pixel.y);

    // Compute normalization factor
    let sum = path.cdf[PRIMARY][max_path_index] + chain.scalar_contribution[uniforms.chain_id];

    // Accept or reject
    if uniforms.random <= path.cdf[PRIMARY][max_path_index] / sum {
        // Binary search
        let min_path_index = chain.min_path_index[uniforms.chain_id];
        let m = binary_search(min_path_index, max_path_index, sum, uniforms.random);

        // Update the current contribution
        let contribution = get_path_contribution(m);
        chain.scalar_contribution[uniforms.chain_id] = luminance(contribution);
        set_chain_contribution(uniforms.chain_id, contribution);
        set_chain_pixel(uniforms.chain_id, get_pixel(m));

        // Update the sample space parameters
        if path.step_type[m] == LARGE_STEP {
            set_chain_large_step_index(uniforms.chain_id, compute_large_step_index(uniforms.chain_id, m));
            chain.small_step_count[uniforms.chain_id] = 1;
        } else {
            chain.small_step_count[uniforms.chain_id] = chain.small_step_count[uniforms.chain_id] + 1;
        }
    }
    
    // Increment the iteration
    chain.iteration[uniforms.chain_id] += 1;
}