@compute
@workgroup_size(WORKGROUP_SIZE)
fn contribute_main(@builtin(global_invocation_id) gid: vec3u) {
    // Determine the global path index (i)
    let global_invocation_index = id.x;
    let i = queue.index[CONTRIBUTE_QUEUE_ID][global_invocation_index];

    // Check bounds
    if i < atomicLoad(&queue.count[CONTRIBUTE_QUEUE_ID]) {
        // Compute the final MIS weight
        let mis_weight = path.sum_inv_ri[CAMERA][i] * path.prod_ri[CAMERA][i] + path.prod_ri[CAMERA][i] - 1.0 
          + path.sum_inv_ri[LIGHT][i] * path.prod_ri[LIGHT][i] + path.prod_ri[LIGHT][i] - 1.0;

        // Context
        let path_length = path.length[i];
        let chain_id = path_length - MIN_PATH_LENGTH;
        let path_length_pdf = chain.path_length_pdf[chain_id];
        let step_type = path.step_type[i];
        let step_term = f32(step_type == LARGE_STEP);
        let path_count = chain.path_count[chain_id];
        let pixel_coordinates = get_pixel_coordinates(i);

        // Compute the final contribution
        let c = get_beta(i) * mis_weight;
        let sc = luminance(c);
        path.scalar_contribution[i] = sc;

        // Compute the weight
        let a = min(1.0, sc / chain.scalar_contribution[chain_id]) / path_count;
        let b = chain.b[chain_id];
        let weight = ((f32(path_length) / path_length_pdf) * (a + step_term)) / ((sc / b) + LARGE_STEP_PROBABILITY);

        // Contribute
        contribute(c * weight, pixel_coordinates.x, pixel_coordinates.y);
    }
}