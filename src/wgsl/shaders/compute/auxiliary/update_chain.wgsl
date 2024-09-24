@compute
@workgroup_size(1)
fn update_chain() {
    // Add the current contribution
    let c = get_chain_contribution(chain_id);
    let path_length = uniforms.chain_id + MIN_PATH_LENGTH;
    let pdf = chain.pdf[uniforms.chain_id];
    let sc = chain.scalar_contribution[uniforms.chain_id];
    let min_path_index = chain.min_path_index[uniforms.chain_id];
    let path_count = chain.path_count[uniforms.chain_id];
    let max_path_index = chain.max_path_index[uniforms.chain_id];
    let a = 1.0 - path_state.scalar_contribution[max_path_index];
    let b = chain.b[chain_id];
    let weight = ((f32(path_length) / pdf) * a) / ((sc / b) + LARGE_STEP_PROBABILITY);
    let pixel_coordinates = get_chain_pixel_coordinates(uniforms.chain_id);
    contribute(c * weight, pixel_coordinates.x, pixel_coordinates.y);

    // Compute normalization factor
    let sum = path.cdf[r] + chain.scalar_contribution[chain_id];

    // Accept or reject
    if uniforms.random <= path_state.cdf[r] / sum {
        // Binary search
        let m = binary_search(min_path_index, max_path_index, sum, uniforms.random);

        // Update the current contribution
        chain.scalar_contribution[chain_id] = path.scalar_contribution[m];
        set_chain_contribution(get_path_contribution(i));

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