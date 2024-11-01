@compute
@workgroup_size(WORKGROUP_SIZE)
fn contribute_main(@builtin(global_invocation_id) gid: vec3u) {
    // Determine the global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[CONTRIBUTE_QUEUE_ID][global_invocation_index];

    // Check bounds
    if global_invocation_index < atomicLoad(&queue.count[CONTRIBUTE_QUEUE_ID]) {
        // Context
        let chain_id = path.length[i] - MIN_PATH_LENGTH;

        let pixel = get_pixel(i);

        // Compute the final contribution
        let c = get_path_contribution(i);
        let sc = luminance(c);
        let a = min(1.0, sc / chain.scalar_contribution[chain_id]) / f32(chain.path_count[chain_id]);
        path.cdf[PRIMARY][i] = choose_f32(image.write_mode == ENABLED, a, sc); // Phase 1, CDF is power distribution, Phase 2, CDF is acceptance probability

        // Compute the weight
        let weight = get_proposal_contribution_weight(chain_id, a, sc, path.step_type[i]);

        // Contribute
        contribute(c * weight, pixel.x, pixel.y);

        // Log
        log_contribution(i);
    }
}