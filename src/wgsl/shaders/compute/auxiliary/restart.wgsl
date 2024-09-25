@compute
@workgroup_size(WORKGROUP_SIZE)
fn restart(@builtin(global_invocation_id) id: vec3u, @builtin(local_path_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index = id.x;
    let i = chain.min_path_index[uniforms.chain_id] + global_invocation_index;

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if global_invocation_index < chain.path_count[uniforms.chain_id] {
        path.vertex_index[i] = 0;
        path.scalar_contribution[i] = 0;
        path.prod_ri[CAMERA][i] = 1.0;
        path.prod_ri[LIGHT][i] = 1.0;
        path.sum_inv_ri[CAMERA][i] = 0.0;
        path.sum_inv_ri[LIGHT][i] = 0.0;
        queue_id = SAMPLE_CAMERA_QUEUE_ID;
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}