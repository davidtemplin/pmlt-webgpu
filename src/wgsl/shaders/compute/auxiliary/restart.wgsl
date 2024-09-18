@compute
@workgroup_size(WORKGROUP_SIZE)
fn restart(@builtin(global_invocation_id) id: vec3u, @builtin(local_path_index) lid: u32) {
    let global_invocation_index = id.x;
    let path_count = chain.path_count[uniforms.chain_id];
    let min_path_index = chain.min_path_index[uniforms.chain_id];
    let global_path_index = min_path_index + path_count;
    var queue_id: u32 = NULL_QUEUE_ID;
    if global_invocation_index < path_count {
        path_state.vertex_index[global_path_index] = 0;
        path_state.scalar_contribution[global_path_index] = 0;
        queue_id = SAMPLE_CAMERA_QUEUE_ID;
    }

    enqueue(global_path_index, lid, queue_id);
}