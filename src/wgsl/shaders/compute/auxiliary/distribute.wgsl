@compute
@workgroup_size(WORKGROUP_SIZE)
fn distribute(@builtin(global_invocation_id) id: vec3u) {
    // Determine the global path index (i)
    let i = id.x;

    // Check bounds
    if i >= PATH_COUNT {
        return;
    }

    // Compute the chain ID corresponding to the current path
    var chain_id: u32 = 0;
    for(var i: u32 = 0; i < CHAIN_COUNT; i++) {
        let m = u32(i >= chain.min_path_index && i <= chain.max_path_index[i]);
        chain_id += m * i;
    }

    // Set the properties on the path
    path.step_type[i] = choose_u32(i >= chain.min_small_step_index && i <= chain.max_small_step_index, SMALL_STEP, LARGE_STEP);
    path.index[i] = i - chain.min_path_index[chain_id];
    path.length[i] = chain_id + MIN_PATH_LENGTH;
    path.vertex_index[i] = 0;
}