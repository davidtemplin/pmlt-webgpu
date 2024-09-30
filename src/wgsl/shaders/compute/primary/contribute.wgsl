@compute
@workgroup_size(WORKGROUP_SIZE)
fn contribute_main(@builtin(global_invocation_id) gid: vec3u) {
    // Determine the global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[CONTRIBUTE_QUEUE_ID][global_invocation_index];

    // Check bounds
    if i < atomicLoad(&queue.count[CONTRIBUTE_QUEUE_ID]) {
        // Context
        let chain_id = path.length[i] - MIN_PATH_LENGTH;

        let pixel = get_pixel(i);

        // Compute the final contribution
        let c = get_path_contribution(i);
        let sc = luminance(c);
        path.cdf[i] = sc;

        // Compute the weight
        let a = min(1.0, sc / chain.scalar_contribution[chain_id]) / f32(chain.path_count[chain_id]);
        let weight = get_contribution_weight(chain_id, a, PROPOSAL, path.step_type[i]);

        // Contribute
        contribute(c * weight, pixel.x, pixel.y);
    }
}