@group(UNIFORM_GROUP) @binding(UNIFORM_BINDING) var<uniform> uniforms: UpdateChainUniforms;

@compute
@workgroup_size(1)
fn update_chain() {
    // Add the current contribution
    let c = get_chain_contribution(uniforms.chain_id);
    let max_path_index = chain.max_path_index[uniforms.chain_id];
    let a = 1.0 - path.cdf[max_path_index];
    let step_type = chain.step_type[uniforms.chain_id];
    let weight = get_contribution_weight(chain_id, a, CURRENT, step_type);
    let pixel_coordinates = get_chain_pixel_coordinates(uniforms.chain_id);
    contribute(c * weight, pixel_coordinates.x, pixel_coordinates.y);

    // Compute normalization factor
    let sum = path.cdf[r] + chain.scalar_contribution[chain_id];

    // Accept or reject
    if uniforms.random <= path.cdf[r] / sum {
        // Binary search
        let min_path_index = chain.min_path_index[uniforms.chain_id];
        let m = binary_search(min_path_index, max_path_index, sum, uniforms.random);

        // Update the current contribution
        let contribution = get_path_contribution(m);
        chain.scalar_contribution[chain_id] = luminance(contribution);
        set_chain_contribution(contribution);

        // Update the sample space parameters
        if step_type == LARGE_STEP {
            set_chain_large_step_index(compute_large_step_index(chain_id, m));
            chain.small_step_count[chain_id] = 1;
        } else {
            chain.small_step_count[chain_id] = chain.small_step_count[chain_id] + 1;
        }
    }
    
    // Increment the iteration
    chain.iteration[chain_id] += 1;
}