@compute
@workgroup_size(WORKGROUP_SIZE)
fn contribute_main(@builtin(global_invocation_id) gid: vec3u) {
    // Determine the global path index (i)
    let global_invocation_index = id.x;
    let i = queue.index[CONTRIBUTE_QUEUE_ID][global_invocation_index];

    // Check bounds
    if i < atomicLoad(&queue.count[CONTRIBUTE_QUEUE_ID]) {
        // Context
        let chain_id = path.length[i] - MIN_PATH_LENGTH;
        let pixel_coordinates = get_pixel_coordinates(i);

        // Compute the final contribution
        let c = get_path_contribution(i);
        let sc = luminance(c);
        path.scalar_contribution[i] = sc;
        path.cdf[i] = sc;

        // Compute the weight
        let a = min(1.0, sc / chain.scalar_contribution[chain_id]) / chain.path_count[chain_id];
        let weight = get_contribution_weight(chain_id, a, PROPOSAL, path.step_type[i]);

        // Contribute
        contribute(c * weight, pixel_coordinates.x, pixel_coordinates.y);
    }
}