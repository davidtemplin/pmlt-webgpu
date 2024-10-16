@compute
@workgroup_size(WORKGROUP_SIZE)
fn distribute(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let i = id.x;

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < PATH_COUNT {
        // Compute the chain ID corresponding to the current path
        var chain_id: u32 = 0;
        for(var i: u32 = 0; i < CHAIN_COUNT; i++) {
            let m = u32(i >= chain.min_path_index[i] && i <= chain.max_path_index[i]);
            chain_id += m * i;
        }

        // Set the properties on the path
        path.step_type[i] = choose_u32(i >= chain.min_small_step_index[chain_id] && i <= chain.max_small_step_index[chain_id], SMALL_STEP, LARGE_STEP);
        path.index[i] = i - chain.min_path_index[chain_id];
        path.length[i] = chain_id + MIN_PATH_LENGTH;
        path.vertex_index[i] = 0;
        path.cdf[PRIMARY][i] = 0;
        path.cdf[AUXILIARY][i] = 0;
        path.prod_ri[CAMERA][i] = 1.0;
        path.prod_ri[LIGHT][i] = 1.0;
        path.sum_inv_ri[CAMERA][i] = 0.0;
        path.sum_inv_ri[LIGHT][i] = 0.0;

        // Set the queue
        queue_id = SAMPLE_CAMERA_QUEUE_ID;
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}